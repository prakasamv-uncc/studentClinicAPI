using StudentClinicAPI.DTOs;

namespace StudentClinicAPI.Services;

public interface IAuthService
{
    Task<LoginResponse?> LoginAsync(LoginRequest request);
    Task<UserDto?> RegisterAsync(RegisterRequest request);
    Task<bool> ChangePasswordAsync(int userId, ChangePasswordRequest request);
}

public interface IPatientService
{
    Task<List<PatientDto>> GetAllPatientsAsync();
    Task<PatientDto?> GetPatientByIdAsync(int patientId);
    Task<PatientDto?> GetPatientByMrnAsync(string mrn);
    Task<PatientDto> CreatePatientAsync(PatientDto dto);
    Task<PatientDto?> UpdatePatientAsync(int patientId, PatientDto dto);
    Task<bool> DeletePatientAsync(int patientId);
    Task<List<PatientDto>> SearchPatientsAsync(string searchTerm);
}

public interface IVisitService
{
    Task<List<VisitDto>> GetAllVisitsAsync();
    Task<VisitDto?> GetVisitByIdAsync(int visitId);
    Task<List<VisitDto>> GetVisitsByPatientIdAsync(int patientId);
    Task<VisitDto> CreateVisitAsync(VisitDto dto);
    Task<VisitDto?> UpdateVisitAsync(int visitId, VisitDto dto);
    Task<bool> DeleteVisitAsync(int visitId);
}

public interface IPrescriptionService
{
    Task<List<PrescriptionDto>> GetAllPrescriptionsAsync();
    Task<PrescriptionDto?> GetPrescriptionByIdAsync(int prescriptionId);
    Task<List<PrescriptionDto>> GetPrescriptionsByVisitIdAsync(int visitId);
    Task<List<PrescriptionDto>> GetPrescriptionsByPatientIdAsync(int patientId);
    Task<PrescriptionDto> CreatePrescriptionAsync(PrescriptionDto dto);
    Task<PrescriptionDto?> UpdatePrescriptionAsync(int prescriptionId, PrescriptionDto dto);
    Task<bool> DeletePrescriptionAsync(int prescriptionId);
}

public interface IPharmacyService
{
    Task<List<PrescriptionDto>> GetPendingPrescriptionsAsync();
    Task<bool> DispensePrescriptionAsync(int userId, PharmacyDispenseDto dto);
    Task<List<dynamic>> GetDispenseHistoryAsync(int prescriptionId);
}

public interface IUserService
{
    Task<List<UserDto>> GetAllUsersAsync();
    Task<UserDto?> GetUserByIdAsync(int userId);
    Task<UserDto?> UpdateUserAsync(int userId, UserDto dto);
    Task<bool> DeleteUserAsync(int userId);
    Task<bool> AssignRoleAsync(int userId, int roleId);
    Task<bool> RemoveRoleAsync(int userId, int roleId);
    Task<bool> AssignDepartmentAsync(int userId, int departmentId);
    Task<bool> RemoveDepartmentAsync(int userId, int departmentId);
}

public interface IAuditLogService
{
    Task<List<AuditLogDto>> GetAuditLogsAsync(string? tableName = null, int? userId = null, DateTime? startDate = null, DateTime? endDate = null);
    Task<AuditLogDto?> GetAuditLogByIdAsync(int auditId);
}

public interface IPermissionService
{
    Task<List<PermissionDto>> GetUserPermissionsAsync(int userId);
    Task<bool> CheckPermissionAsync(int userId, string resource, string action);
}

public interface IDepartmentService
{
    Task<List<dynamic>> GetAllDepartmentsAsync();
    Task<dynamic?> GetDepartmentByIdAsync(int departmentId);
}
