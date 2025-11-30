using System.Security.Claims;
using System.Text.Json;
using StudentClinicAPI.Data;
using StudentClinicAPI.Models;

namespace StudentClinicAPI.Middleware;

public class AuditLogMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<AuditLogMiddleware> _logger;

    public AuditLogMiddleware(RequestDelegate next, ILogger<AuditLogMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context, StudentClinicDbContext dbContext)
    {
        // Skip audit logging for GET requests and certain paths
        if (context.Request.Method == "GET" || 
            context.Request.Path.StartsWithSegments("/swagger") ||
            context.Request.Path.StartsWithSegments("/api/auth/login"))
        {
            await _next(context);
            return;
        }

        var originalBodyStream = context.Response.Body;

        try
        {
            using var responseBody = new MemoryStream();
            context.Response.Body = responseBody;

            await _next(context);

            // Only log successful modifications (2xx status codes)
            if (context.Response.StatusCode >= 200 && context.Response.StatusCode < 300)
            {
                var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                var username = context.User.FindFirst(ClaimTypes.Name)?.Value;

                if (userId != null)
                {
                    var auditLog = new AuditLog
                    {
                        TableName = GetTableNameFromPath(context.Request.Path),
                        RecordId = 0, // Will be updated by stored procedures
                        Action = context.Request.Method,
                        UserId = int.Parse(userId),
                        Username = username,
                        IpAddress = context.Connection.RemoteIpAddress?.ToString(),
                        UserAgent = context.Request.Headers["User-Agent"].ToString(),
                        CreatedAt = DateTime.UtcNow
                    };

                    // Don't await to avoid slowing down the response
                    _ = Task.Run(async () =>
                    {
                        try
                        {
                            dbContext.AuditLogs.Add(auditLog);
                            await dbContext.SaveChangesAsync();
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Error saving audit log");
                        }
                    });
                }
            }

            responseBody.Seek(0, SeekOrigin.Begin);
            await responseBody.CopyToAsync(originalBodyStream);
        }
        finally
        {
            context.Response.Body = originalBodyStream;
        }
    }

    private string GetTableNameFromPath(PathString path)
    {
        var segments = path.Value?.Split('/', StringSplitOptions.RemoveEmptyEntries);
        if (segments != null && segments.Length >= 2)
        {
            return segments[1]; // Returns the controller name
        }
        return "Unknown";
    }
}
