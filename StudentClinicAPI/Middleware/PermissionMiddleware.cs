using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using StudentClinicAPI.Data;

namespace StudentClinicAPI.Middleware;

public class PermissionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<PermissionMiddleware> _logger;

    // Paths that don't require permission check
    private static readonly HashSet<string> _publicPaths = new()
    {
        "/api/auth/login",
        "/api/auth/register",
        "/swagger",
        "/health"
    };

    public PermissionMiddleware(RequestDelegate next, ILogger<PermissionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context, StudentClinicDbContext dbContext)
    {
        // Skip authentication check for public paths
        if (_publicPaths.Any(p => context.Request.Path.StartsWithSegments(p)))
        {
            await _next(context);
            return;
        }

        // Check if user is authenticated
        if (!context.User.Identity?.IsAuthenticated ?? true)
        {
            await _next(context);
            return;
        }

        var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (userId == null)
        {
            await _next(context);
            return;
        }

        // Get resource and action from request
        var resource = GetResourceFromPath(context.Request.Path);
        var action = GetActionFromMethod(context.Request.Method);

        // Check if user has permission
        var hasPermission = await CheckUserPermission(dbContext, int.Parse(userId), resource, action);

        if (!hasPermission)
        {
            _logger.LogWarning($"User {userId} attempted to access {resource}:{action} without permission");
            context.Response.StatusCode = 403;
            await context.Response.WriteAsJsonAsync(new
            {
                success = false,
                message = "You do not have permission to perform this action",
                resource,
                action
            });
            return;
        }

        await _next(context);
    }

    private string GetResourceFromPath(PathString path)
    {
        var segments = path.Value?.Split('/', StringSplitOptions.RemoveEmptyEntries);
        if (segments != null && segments.Length >= 2)
        {
            return segments[1].ToLower(); // Returns the controller name
        }
        return "unknown";
    }

    private string GetActionFromMethod(string method)
    {
        return method.ToUpper() switch
        {
            "GET" => "SELECT",
            "POST" => "INSERT",
            "PUT" => "UPDATE",
            "PATCH" => "UPDATE",
            "DELETE" => "DELETE",
            _ => "SELECT"
        };
    }

    private async Task<bool> CheckUserPermission(StudentClinicDbContext dbContext, int userId, string resource, string action)
    {
        try
        {
            var hasPermission = await dbContext.UserRoles
                .Where(ur => ur.UserId == userId)
                .Join(dbContext.RolePermissions, ur => ur.RoleId, rp => rp.RoleId, (ur, rp) => rp)
                .Join(dbContext.Permissions, rp => rp.PermissionId, p => p.PermissionId, (rp, p) => p)
                .AnyAsync(p => p.Resource.ToLower() == resource && p.Action.ToLower() == action.ToLower());

            return hasPermission;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error checking permission for user {userId}, resource {resource}, action {action}");
            return false;
        }
    }
}
