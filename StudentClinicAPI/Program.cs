using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using StudentClinicAPI.Data;
using StudentClinicAPI.Services;
using StudentClinicAPI.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Text.Encodings.Web;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var serverVersion = new MySqlServerVersion(new Version(8, 0, 0));

builder.Services.AddDbContext<StudentClinicDbContext>(options =>
    options.UseMySql(connectionString, serverVersion)
        .LogTo(Console.WriteLine, LogLevel.Information)
        .EnableSensitiveDataLogging()
        .EnableDetailedErrors()
);

// Register services
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IPatientService, PatientService>();
builder.Services.AddScoped<IVisitService, VisitService>();
builder.Services.AddScoped<IPrescriptionService, PrescriptionService>();
builder.Services.AddScoped<IPharmacyService, PharmacyService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IAuditLogService, AuditLogService>();
builder.Services.AddScoped<IPermissionService, PermissionService>();
builder.Services.AddScoped<IDepartmentService, DepartmentService>();
builder.Services.AddScoped<StoredProcedureService>();

// When JWT/authentication is disabled for development, register a permissive
// development authentication scheme so [Authorize] attributes don't cause
// authentication challenges (which would throw when no default scheme exists).
// This scheme authenticates every request as a local "dev" user. It is only
// registered in the Development environment.
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddAuthentication("DevAuth")
        .AddScheme<AuthenticationSchemeOptions, DevAllowAllAuthHandler>("DevAuth", options => { });
}

// Authorization is configured to allow all requests by default for endpoints
// without explicit [Authorize], but controllers that have [Authorize]
// will see the permissive DevAuth identity above.
builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = new Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder()
        .RequireAssertion(_ => true)
        .Build();
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Student Clinic EMR API",
        Version = "v1",
        Description = "API for Student Clinic Electronic Medical Records System with RBAC, Audit Trail, and Stored Procedures"
    });

    // No security definitions added: Swagger will not require a Bearer token.
});

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

Console.WriteLine("Application built successfully. Starting...");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseDeveloperExceptionPage();
}
else
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseExceptionHandler("/error");
}

// Enable CORS - must come before authentication/authorization
app.UseCors();

// Ensure authentication/authorization middleware runs before controllers.
// We register a permissive development authentication scheme above so this
// middleware will provide a principal even when JWT is not configured.
app.UseAuthentication();
app.UseAuthorization();

// Minimal middleware for debugging
Console.WriteLine("Configuring middleware pipeline...");

app.MapGet("/", () => "API is running!");
app.MapGet("/test", () => Results.Ok(new { status = "OK", message = "Test endpoint works!" }));

app.MapControllers();

Console.WriteLine("Starting application...");
app.Run();
Console.WriteLine("Application has stopped.");

// Development authentication handler that authenticates every request as a
// local dev principal. This is intended only for local development when the
// real JWT authentication is disabled. Remove or guard behind an environment
// check before using in production.
public class DevAllowAllAuthHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public DevAllowAllAuthHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock)
        : base(options, logger, encoder, clock)
    {
    }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        // Use a numeric NameIdentifier so controllers that parse the claim as
        // an integer (user id) do not throw format exceptions. Default to 1
        // for local development; this can be adjusted if needed.
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Name, "devuser")
        };
        var identity = new ClaimsIdentity(claims, Scheme.Name);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, Scheme.Name);
        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}
