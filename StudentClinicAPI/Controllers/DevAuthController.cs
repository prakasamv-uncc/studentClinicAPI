using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using StudentClinicAPI.DTOs;

namespace StudentClinicAPI.Controllers;

[ApiController]
[Route("api/dev")]
    public class DevAuthController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly IWebHostEnvironment _env;
    private readonly StudentClinicAPI.Data.StudentClinicDbContext _context;

    public DevAuthController(IConfiguration configuration, IWebHostEnvironment env, StudentClinicAPI.Data.StudentClinicDbContext context)
    {
        _configuration = configuration;
        _env = env;
        _context = context;
    }

    // Development-only token generator to facilitate testing via Swagger.
    // Visible only when ASPNETCORE_ENVIRONMENT=Development. Returns a signed JWT using JwtSettings.
    [HttpPost("token")]
    [Microsoft.AspNetCore.Authorization.AllowAnonymous]
    public ActionResult<object> GenerateToken([FromBody] DevTokenRequest request)
    {
        if (!_env.IsDevelopment())
        {
            return NotFound();
        }

        var jwtSettings = _configuration.GetSection("JwtSettings");
        var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey not configured");
        var issuer = jwtSettings["Issuer"];
        var audience = jwtSettings["Audience"];
        var expirationMinutes = double.TryParse(jwtSettings["ExpirationMinutes"], out var m) ? m : 480;

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, request.UserId.ToString()),
            new Claim(ClaimTypes.Name, request.Username ?? string.Empty),
            new Claim(ClaimTypes.Email, request.Email ?? string.Empty)
        };

        if (!string.IsNullOrEmpty(request.Roles))
        {
            foreach (var r in request.Roles.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                claims.Add(new Claim(ClaimTypes.Role, r));
            }
        }

        if (request.IncludeCredentialHash && !string.IsNullOrEmpty(request.Password))
        {
            claims.Add(new Claim("cred_hash", HashCredential(request.Username ?? string.Empty, request.Password)));
        }

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expirationMinutes),
            signingCredentials: credentials
        );

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        return Ok(new { Token = tokenString });
    }

    private static string HashCredential(string username, string password)
    {
        using var sha256 = SHA256.Create();
        var input = $"{username}:{password}";
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
        return BitConverter.ToString(bytes).Replace("-", "").ToLower();
    }

    public class DevTokenRequest
    {
        public int UserId { get; set; } = 1;
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? Roles { get; set; }
        public string? Password { get; set; }
        public bool IncludeCredentialHash { get; set; } = false;
    }

    public class DevTokenCredentialRequest
    {
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public bool IncludeCredentialHash { get; set; } = false;
    }

    // Development-only: generate token by verifying username + password against DB
    [HttpPost("token-by-username")]
    [Microsoft.AspNetCore.Authorization.AllowAnonymous]
    public async Task<ActionResult<object>> GenerateTokenByUsername([FromBody] DevTokenCredentialRequest request)
    {
        if (!_env.IsDevelopment())
        {
            return NotFound();
        }

        if (string.IsNullOrWhiteSpace(request.Username) || string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new { error = "Username and password are required" });
        }

        // Find user by username with related auth and roles
        var user = await _context.StaffUsers
            .Include(u => u.UserAuth)
            .Include(u => u.UserRoles!)
                .ThenInclude(ur => ur.Role)
            .FirstOrDefaultAsync(u => u.Username == request.Username);

        if (user == null || user.UserAuth == null)
        {
            return BadRequest(new { error = "Invalid username or password" });
        }

        // Verify password (SHA256 hash)
        using var sha256 = System.Security.Cryptography.SHA256.Create();
        var hashBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(request.Password));
        var passwordHash = BitConverter.ToString(hashBytes).Replace("-", "").ToLower();

        if (user.UserAuth.PasswordHash != passwordHash)
        {
            return BadRequest(new { error = "Invalid username or password" });
        }

        // Generate token
        var jwtSettings = _configuration.GetSection("JwtSettings");
        var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey not configured");
        var issuer = jwtSettings["Issuer"];
        var audience = jwtSettings["Audience"];
        var expirationMinutes = double.TryParse(jwtSettings["ExpirationMinutes"], out var m) ? m : 480;

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
            new Claim(ClaimTypes.Name, user.Username),
            new Claim(ClaimTypes.Email, user.UserAuth.Email)
        };

        var roles = user.UserRoles?.Select(ur => ur.Role?.RoleName).Where(r => !string.IsNullOrEmpty(r)).Select(r => r!).ToList() ?? new List<string>();
        foreach (var r in roles)
            claims.Add(new Claim(ClaimTypes.Role, r));

        if (request.IncludeCredentialHash)
        {
            var credHash = HashCredential(user.Username, request.Password);
            claims.Add(new Claim("cred_hash", credHash));
        }

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expirationMinutes),
            signingCredentials: credentials
        );

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
        return Ok(new { Token = tokenString });
    }
}
