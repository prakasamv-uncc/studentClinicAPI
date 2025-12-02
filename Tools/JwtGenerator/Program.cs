using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.Text.Json;

// Simple JWT generator that reads JwtSettings from the main project's appsettings.json
// Usage examples:
// dotnet run -- --username demo --email demo@example.com --userid 123 --roles Admin,User --password secret --includeCred true

string? projectRoot = AppContext.BaseDirectory;
// navigate up until we find appsettings.json (project root)
var dir = new DirectoryInfo(projectRoot);
while (dir != null && !dir.GetFiles("appsettings.json").Any())
{
    dir = dir.Parent;
}

string appsettingsPath;
if (dir == null)
{
    // fallback to relative path
    appsettingsPath = Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "..", "appsettings.json");
}
else
{
    appsettingsPath = Path.Combine(dir.FullName, "appsettings.json");
}

if (!File.Exists(appsettingsPath))
{
    Console.Error.WriteLine($"Could not find appsettings.json at {appsettingsPath}. Please run from the solution or provide Jwt settings as args.");
}

var configJson = File.Exists(appsettingsPath) ? JsonDocument.Parse(File.ReadAllText(appsettingsPath)) : null;

string GetSetting(string key, string? defaultValue = null)
{
    if (configJson == null) return defaultValue ?? string.Empty;
    if (configJson.RootElement.TryGetProperty("JwtSettings", out var jwts) && jwts.TryGetProperty(key, out var v))
    {
        if (v.ValueKind == JsonValueKind.String) return v.GetString() ?? defaultValue ?? string.Empty;
        // for numbers or other types, return raw text
        return v.GetRawText().Trim('"');
    }
    return defaultValue ?? string.Empty;
}

// parse args
var argsDict = new Dictionary<string, string?>();
string? lastKey = null;
foreach (var a in args)
{
    if (a.StartsWith("--")) { lastKey = a.Substring(2); argsDict[lastKey] = null; }
    else if (lastKey != null) { argsDict[lastKey!] = a; lastKey = null; }
}

string username = argsDict.ContainsKey("username") && !string.IsNullOrEmpty(argsDict["username"]) ? argsDict["username"]! : "demo_user";
string email = argsDict.ContainsKey("email") && !string.IsNullOrEmpty(argsDict["email"]) ? argsDict["email"]! : "demo@example.com";
int userId = argsDict.ContainsKey("userid") && int.TryParse(argsDict["userid"], out var uid) ? uid : 1;
var roles = argsDict.ContainsKey("roles") && !string.IsNullOrEmpty(argsDict["roles"]) ? argsDict["roles"]!.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(r => r.Trim()).ToList() : new List<string>{"User"};
string? password = argsDict.ContainsKey("password") ? argsDict["password"] : null;

var secret = GetSetting("SecretKey");
var issuer = GetSetting("Issuer");
var audience = GetSetting("Audience");
var expirationMinutesStr = GetSetting("ExpirationMinutes", "480");
var includeCredStr = GetSetting("IncludeCredentialHashInToken", "false");

if (argsDict.ContainsKey("secret") && !string.IsNullOrEmpty(argsDict["secret"])) secret = argsDict["secret"]!;
if (argsDict.ContainsKey("issuer") && !string.IsNullOrEmpty(argsDict["issuer"])) issuer = argsDict["issuer"]!;
if (argsDict.ContainsKey("audience") && !string.IsNullOrEmpty(argsDict["audience"])) audience = argsDict["audience"]!;
if (argsDict.ContainsKey("expiration") && !string.IsNullOrEmpty(argsDict["expiration"])) expirationMinutesStr = argsDict["expiration"]!;
if (argsDict.ContainsKey("includeCred") && !string.IsNullOrEmpty(argsDict["includeCred"])) includeCredStr = argsDict["includeCred"]!;

if (string.IsNullOrEmpty(secret) || secret.Length < 16)
{
    Console.Error.WriteLine("SecretKey missing or too short. Provide a strong key via appsettings.json or --secret.");
    return;
}

if (!double.TryParse(expirationMinutesStr, out var expirationMinutes)) expirationMinutes = 480;
if (!bool.TryParse(includeCredStr, out var includeCred)) includeCred = false;

var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));
var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

var claims = new List<Claim>
{
    new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
    new Claim(ClaimTypes.Name, username),
    new Claim(ClaimTypes.Email, email)
};

foreach (var r in roles)
    claims.Add(new Claim(ClaimTypes.Role, r));

if (includeCred && !string.IsNullOrEmpty(password))
{
    claims.Add(new Claim("cred_hash", HashCredential(username, password)));
}

var jwt = new JwtSecurityToken(
    issuer: string.IsNullOrEmpty(issuer) ? null : issuer,
    audience: string.IsNullOrEmpty(audience) ? null : audience,
    claims: claims,
    expires: DateTime.UtcNow.AddMinutes(expirationMinutes),
    signingCredentials: creds
);

var token = new JwtSecurityTokenHandler().WriteToken(jwt);

Console.WriteLine("\n=== JWT Token ===\n");
Console.WriteLine(token);

Console.WriteLine("\n=== Payload (decoded) ===\n");
var payload = token.Split('.')[1];
// pad base64
int mod4 = payload.Length % 4;
if (mod4 > 0) payload = payload.PadRight(payload.Length + (4 - mod4), '=');
var json = Encoding.UTF8.GetString(Convert.FromBase64String(payload));
Console.WriteLine(JsonSerializer.Serialize(JsonDocument.Parse(json), new JsonSerializerOptions { WriteIndented = true }));

static string HashCredential(string username, string password)
{
    using var sha256 = SHA256.Create();
    var input = $"{username}:{password}";
    var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
    return BitConverter.ToString(bytes).Replace("-", "").ToLower();
}
