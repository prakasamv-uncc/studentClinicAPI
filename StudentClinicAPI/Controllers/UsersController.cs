using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Services;

namespace StudentClinicAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;
    private readonly ILogger<UsersController> _logger;

    public UsersController(IUserService userService, ILogger<UsersController> logger)
    {
        _userService = userService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<UserDto>>>> GetAllUsers()
    {
        try
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(ApiResponse<List<UserDto>>.SuccessResult(users));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all users");
            return StatusCode(500, ApiResponse<List<UserDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<UserDto>>> GetUserById(int id)
    {
        try
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null)
            {
                return NotFound(ApiResponse<UserDto>.ErrorResult("User not found"));
            }
            return Ok(ApiResponse<UserDto>.SuccessResult(user));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting user {id}");
            return StatusCode(500, ApiResponse<UserDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ApiResponse<UserDto>>> UpdateUser(int id, [FromBody] UserDto dto)
    {
        try
        {
            var user = await _userService.UpdateUserAsync(id, dto);
            if (user == null)
            {
                return NotFound(ApiResponse<UserDto>.ErrorResult("User not found"));
            }
            return Ok(ApiResponse<UserDto>.SuccessResult(user, "User updated successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error updating user {id}");
            return StatusCode(500, ApiResponse<UserDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult<ApiResponse<bool>>> DeleteUser(int id)
    {
        try
        {
            var result = await _userService.DeleteUserAsync(id);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("User not found or could not be deleted"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "User deleted successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting user {id}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost("{userId}/roles/{roleId}")]
    public async Task<ActionResult<ApiResponse<bool>>> AssignRole(int userId, int roleId)
    {
        try
        {
            var result = await _userService.AssignRoleAsync(userId, roleId);
            if (!result)
            {
                return BadRequest(ApiResponse<bool>.ErrorResult("Failed to assign role"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Role assigned successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error assigning role {roleId} to user {userId}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{userId}/roles/{roleId}")]
    public async Task<ActionResult<ApiResponse<bool>>> RemoveRole(int userId, int roleId)
    {
        try
        {
            var result = await _userService.RemoveRoleAsync(userId, roleId);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("Role assignment not found"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Role removed successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error removing role {roleId} from user {userId}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost("{userId}/departments/{departmentId}")]
    public async Task<ActionResult<ApiResponse<bool>>> AssignDepartment(int userId, int departmentId)
    {
        try
        {
            var result = await _userService.AssignDepartmentAsync(userId, departmentId);
            if (!result)
            {
                return BadRequest(ApiResponse<bool>.ErrorResult("Failed to assign department"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Department assigned successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error assigning department {departmentId} to user {userId}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{userId}/departments/{departmentId}")]
    public async Task<ActionResult<ApiResponse<bool>>> RemoveDepartment(int userId, int departmentId)
    {
        try
        {
            var result = await _userService.RemoveDepartmentAsync(userId, departmentId);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("Department assignment not found"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Department removed successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error removing department {departmentId} from user {userId}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }
}

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AuditLogController : ControllerBase
{
    private readonly IAuditLogService _auditLogService;
    private readonly ILogger<AuditLogController> _logger;

    public AuditLogController(IAuditLogService auditLogService, ILogger<AuditLogController> logger)
    {
        _auditLogService = auditLogService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<AuditLogDto>>>> GetAuditLogs(
        [FromQuery] string? tableName = null,
        [FromQuery] int? userId = null,
        [FromQuery] DateTime? startDate = null,
        [FromQuery] DateTime? endDate = null)
    {
        try
        {
            var logs = await _auditLogService.GetAuditLogsAsync(tableName, userId, startDate, endDate);
            return Ok(ApiResponse<List<AuditLogDto>>.SuccessResult(logs));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting audit logs");
            return StatusCode(500, ApiResponse<List<AuditLogDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<AuditLogDto>>> GetAuditLogById(int id)
    {
        try
        {
            var log = await _auditLogService.GetAuditLogByIdAsync(id);
            if (log == null)
            {
                return NotFound(ApiResponse<AuditLogDto>.ErrorResult("Audit log not found"));
            }
            return Ok(ApiResponse<AuditLogDto>.SuccessResult(log));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting audit log {id}");
            return StatusCode(500, ApiResponse<AuditLogDto>.ErrorResult("An error occurred"));
        }
    }
}

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DepartmentsController : ControllerBase
{
    private readonly IDepartmentService _departmentService;
    private readonly ILogger<DepartmentsController> _logger;

    public DepartmentsController(IDepartmentService departmentService, ILogger<DepartmentsController> logger)
    {
        _departmentService = departmentService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<dynamic>>>> GetAllDepartments()
    {
        try
        {
            var departments = await _departmentService.GetAllDepartmentsAsync();
            return Ok(ApiResponse<List<dynamic>>.SuccessResult(departments));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all departments");
            return StatusCode(500, ApiResponse<List<dynamic>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<dynamic>>> GetDepartmentById(int id)
    {
        try
        {
            var department = await _departmentService.GetDepartmentByIdAsync(id);
            if (department == null)
            {
                return NotFound(ApiResponse<dynamic>.ErrorResult("Department not found"));
            }
            return Ok(ApiResponse<dynamic>.SuccessResult(department));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting department {id}");
            return StatusCode(500, ApiResponse<dynamic>.ErrorResult("An error occurred"));
        }
    }
}
