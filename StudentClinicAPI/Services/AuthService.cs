using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using StudentClinicAPI.Data;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Models;

namespace StudentClinicAPI.Services;

public class AuthService : IAuthService
{
    private readonly StudentClinicDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<AuthService> _logger;

    public AuthService(StudentClinicDbContext context, IConfiguration configuration, ILogger<AuthService> logger)
    {
        _context = context;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request)
    {
        try
        {
            var userAuth = await _context.UserAuths
                .Include(ua => ua.StaffUser)
                    .ThenInclude(su => su.UserRoles)
                        .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(ua => ua.Email == request.Email && ua.IsActive);

            if (userAuth == null)
            {
                _logger.LogWarning($"Login failed: User not found for email {request.Email}");
                return null;
            }

            // Verify password (SHA256 hash matching SQL)
            var passwordHash = HashPassword(request.Password);
            if (userAuth.PasswordHash != passwordHash)
            {
                _logger.LogWarning($"Login failed: Invalid password for email {request.Email}");
                return null;
            }

            var roles = userAuth.StaffUser.UserRoles.Select(ur => ur.Role.RoleName).ToList();
            var permissions = await GetUserPermissions(userAuth.UserId);

            var token = GenerateJwtToken(userAuth.UserId, userAuth.StaffUser.Username, userAuth.Email, roles, request.Password);

            return new LoginResponse
            {
                UserId = userAuth.UserId,
                Username = userAuth.StaffUser.Username,
                Email = userAuth.Email,
                Token = token,
                Roles = roles,
                Permissions = permissions
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during login");
            return null;
        }
    }

    public async Task<UserDto?> RegisterAsync(RegisterRequest request)
    {
        try
        {
            // Check if user already exists
            if (await _context.UserAuths.AnyAsync(ua => ua.Email == request.Email))
            {
                _logger.LogWarning($"Registration failed: Email {request.Email} already exists");
                return null;
            }

            if (await _context.StaffUsers.AnyAsync(su => su.Username == request.Username))
            {
                _logger.LogWarning($"Registration failed: Username {request.Username} already exists");
                return null;
            }

            var username = request.Username;

            // Create staff user
            var staffUser = new StaffUser
            {
                Username = username,
                DisplayName = $"{request.FirstName} {request.LastName}",
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.StaffUsers.Add(staffUser);
            await _context.SaveChangesAsync();

            // Create user auth
            var userAuth = new UserAuth
            {
                UserId = staffUser.UserId,
                Email = request.Email,
                PasswordHash = HashPassword(request.Password),
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.UserAuths.Add(userAuth);
            await _context.SaveChangesAsync();

            return new UserDto
            {
                UserId = staffUser.UserId,
                Username = staffUser.Username,
                DisplayName = staffUser.DisplayName,
                Email = userAuth.Email,
                IsActive = staffUser.IsActive,
                Roles = new List<string>(),
                Departments = new List<string>()
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during registration");
            return null;
        }
    }

    public async Task<bool> ChangePasswordAsync(int userId, ChangePasswordRequest request)
    {
        try
        {
            var userAuth = await _context.UserAuths.FindAsync(userId);
            if (userAuth == null)
            {
                return false;
            }

            // Verify old password
            var oldPasswordHash = HashPassword(request.OldPassword);
            if (userAuth.PasswordHash != oldPasswordHash)
            {
                return false;
            }

            // Update password
            userAuth.PasswordHash = HashPassword(request.NewPassword);
            userAuth.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error changing password for user {userId}");
            return false;
        }
    }

    private string GenerateJwtToken(int userId, string username, string email, List<string> roles, string? password = null)
    {
        var jwtSettings = _configuration.GetSection("JwtSettings");
        var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey not configured");
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
            new Claim(ClaimTypes.Name, username),
            new Claim(ClaimTypes.Email, email)
        };

        // Add roles as claims
        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        // Optionally add a credential hash (username+password) as a claim if configured.
        // This avoids placing plaintext passwords in tokens. The configuration flag
        // JwtSettings:IncludeCredentialHashInToken controls this (default: false).
        var includeCred = false;
        if (bool.TryParse(jwtSettings["IncludeCredentialHashInToken"], out var parsed))
        {
            includeCred = parsed;
        }

        if (includeCred && !string.IsNullOrEmpty(password))
        {
            // store only a SHA256 of username:password to avoid plaintext in token
            claims.Add(new Claim("cred_hash", HashCredential(username, password)));
        }

        var token = new JwtSecurityToken(
            issuer: jwtSettings["Issuer"],
            audience: jwtSettings["Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(double.Parse(jwtSettings["ExpirationMinutes"] ?? "480")),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private string HashCredential(string username, string password)
    {
        using var sha256 = SHA256.Create();
        var input = $"{username}:{password}";
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
        return BitConverter.ToString(bytes).Replace("-", "").ToLower();
    }

    private string HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
        return BitConverter.ToString(bytes).Replace("-", "").ToLower();
    }

    private async Task<List<PermissionDto>> GetUserPermissions(int userId)
    {
        return await _context.UserRoles
            .Where(ur => ur.UserId == userId)
            .Join(_context.RolePermissions, ur => ur.RoleId, rp => rp.RoleId, (ur, rp) => rp)
            .Join(_context.Permissions, rp => rp.PermissionId, p => p.PermissionId, (rp, p) => p)
            .Select(p => new PermissionDto
            {
                Resource = p.Resource,
                Action = p.Action
            })
            .Distinct()
            .ToListAsync();
    }
}
