using Microsoft.EntityFrameworkCore;
using StudentClinicAPI.Data;
using StudentClinicAPI.DTOs;

namespace StudentClinicAPI.Services;

public class UserService : IUserService
{
    private readonly StudentClinicDbContext _context;
    private readonly ILogger<UserService> _logger;

    public UserService(StudentClinicDbContext context, ILogger<UserService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<List<UserDto>> GetAllUsersAsync()
    {
        var users = await _context.StaffUsers
            .Include(su => su.UserAuth)
            .Include(su => su.UserRoles)
                .ThenInclude(ur => ur.Role)
            .Include(su => su.StaffDepartments)
                .ThenInclude(sd => sd.Department)
            .Select(su => new UserDto
            {
                UserId = su.UserId,
                Username = su.Username,
                DisplayName = su.DisplayName,
                Email = su.UserAuth != null ? su.UserAuth.Email : "",
                IsActive = su.IsActive,
                Roles = su.UserRoles.Select(ur => ur.Role.RoleName).ToList(),
                Departments = su.StaffDepartments.Select(sd => sd.Department.Name).ToList()
            })
            .ToListAsync();

        return users;
    }

    public async Task<UserDto?> GetUserByIdAsync(int userId)
    {
        var user = await _context.StaffUsers
            .Include(su => su.UserAuth)
            .Include(su => su.UserRoles)
                .ThenInclude(ur => ur.Role)
            .Include(su => su.StaffDepartments)
                .ThenInclude(sd => sd.Department)
            .Where(su => su.UserId == userId)
            .Select(su => new UserDto
            {
                UserId = su.UserId,
                Username = su.Username,
                DisplayName = su.DisplayName,
                Email = su.UserAuth != null ? su.UserAuth.Email : "",
                IsActive = su.IsActive,
                Roles = su.UserRoles.Select(ur => ur.Role.RoleName).ToList(),
                Departments = su.StaffDepartments.Select(sd => sd.Department.Name).ToList()
            })
            .FirstOrDefaultAsync();

        return user;
    }

    public async Task<bool> AssignRoleAsync(int userId, int roleId)
    {
        try
        {
            var userRole = new Models.UserRole { UserId = userId, RoleId = roleId };
            _context.UserRoles.Add(userRole);
            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error assigning role {roleId} to user {userId}");
            return false;
        }
    }

    public async Task<bool> RemoveRoleAsync(int userId, int roleId)
    {
        try
        {
            var userRole = await _context.UserRoles
                .FirstOrDefaultAsync(ur => ur.UserId == userId && ur.RoleId == roleId);
            
            if (userRole == null) return false;

            _context.UserRoles.Remove(userRole);
            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error removing role {roleId} from user {userId}");
            return false;
        }
    }

    public async Task<bool> AssignDepartmentAsync(int userId, int departmentId)
    {
        try
        {
            var staffDepartment = new Models.StaffDepartment { UserId = userId, DepartmentId = departmentId };
            _context.StaffDepartments.Add(staffDepartment);
            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error assigning department {departmentId} to user {userId}");
            return false;
        }
    }

    public async Task<bool> RemoveDepartmentAsync(int userId, int departmentId)
    {
        try
        {
            var staffDepartment = await _context.StaffDepartments
                .FirstOrDefaultAsync(sd => sd.UserId == userId && sd.DepartmentId == departmentId);
            
            if (staffDepartment == null) return false;

            _context.StaffDepartments.Remove(staffDepartment);
            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error removing department {departmentId} from user {userId}");
            return false;
        }
    }
}

public class PermissionService : IPermissionService
{
    private readonly StudentClinicDbContext _context;
    private readonly ILogger<PermissionService> _logger;

    public PermissionService(StudentClinicDbContext context, ILogger<PermissionService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<List<PermissionDto>> GetUserPermissionsAsync(int userId)
    {
        var permissions = await _context.UserRoles
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

        return permissions;
    }

    public async Task<bool> CheckPermissionAsync(int userId, string resource, string action)
    {
        return await _context.UserRoles
            .Where(ur => ur.UserId == userId)
            .Join(_context.RolePermissions, ur => ur.RoleId, rp => rp.RoleId, (ur, rp) => rp)
            .Join(_context.Permissions, rp => rp.PermissionId, p => p.PermissionId, (rp, p) => p)
            .AnyAsync(p => p.Resource.ToLower() == resource.ToLower() && p.Action.ToLower() == action.ToLower());
    }
}

public class DepartmentService : IDepartmentService
{
    private readonly StudentClinicDbContext _context;
    private readonly ILogger<DepartmentService> _logger;

    public DepartmentService(StudentClinicDbContext context, ILogger<DepartmentService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<List<dynamic>> GetAllDepartmentsAsync()
    {
        var departments = await _context.Departments
            .Select(d => new
            {
                d.DepartmentId,
                d.Name,
                StaffCount = d.StaffDepartments.Count
            })
            .ToListAsync<dynamic>();

        return departments;
    }

    public async Task<dynamic?> GetDepartmentByIdAsync(int departmentId)
    {
        var department = await _context.Departments
            .Where(d => d.DepartmentId == departmentId)
            .Select(d => new
            {
                d.DepartmentId,
                d.Name,
                Staff = d.StaffDepartments.Select(sd => new
                {
                    sd.StaffUser.UserId,
                    sd.StaffUser.Username,
                    sd.StaffUser.DisplayName
                }).ToList()
            })
            .FirstOrDefaultAsync<dynamic>();

        return department;
    }
}
