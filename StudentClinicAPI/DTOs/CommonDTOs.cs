namespace StudentClinicAPI.DTOs;

public class LoginRequest
{
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
}

public class LoginResponse
{
    public int UserId { get; set; }
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Token { get; set; } = null!;
    public List<string> Roles { get; set; } = new();
    public List<PermissionDto> Permissions { get; set; } = new();
}

public class RegisterRequest
{
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? PhoneNumber { get; set; }
}

public class ChangePasswordRequest
{
    public string OldPassword { get; set; } = null!;
    public string NewPassword { get; set; } = null!;
}

public class PermissionDto
{
    public string Resource { get; set; } = null!;
    public string Action { get; set; } = null!;
}

public class UserDto
{
    public int UserId { get; set; }
    public string Username { get; set; } = null!;
    public string? DisplayName { get; set; }
    public string Email { get; set; } = null!;
    public bool IsActive { get; set; }
    public List<string> Roles { get; set; } = new();
    public List<string> Departments { get; set; } = new();
}

public class PatientDto
{
    public int? PatientId { get; set; }
    public string Mrn { get; set; } = null!;
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public DateTime Dob { get; set; }
    public string Sex { get; set; } = null!;
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? City { get; set; }
    public string? State { get; set; }
    public string? Zip { get; set; }
    public string? EmergencyContactName { get; set; }
    public string? EmergencyContactPhone { get; set; }
}

public class VisitDto
{
    public int? VisitId { get; set; }
    public int PatientId { get; set; }
    public int ProviderId { get; set; }
    public int? AppointmentId { get; set; }
    public DateTime? CheckInTime { get; set; }
    public DateTime? CheckOutTime { get; set; }
    public string Status { get; set; } = "Scheduled";
    public string? ChiefComplaint { get; set; }
    public string? PatientName { get; set; }
    public string? ProviderName { get; set; }
}

public class PrescriptionDto
{
    public int? PrescriptionId { get; set; }
    public int VisitId { get; set; }
    public string DrugCode { get; set; } = null!;
    public string? DrugName { get; set; }
    public string? Dose { get; set; }
    public string? DoseUnit { get; set; }
    public string? Route { get; set; }
    public string? Frequency { get; set; }
    public int? DurationDays { get; set; }
    public decimal? Quantity { get; set; }
    public int? Refills { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public string Status { get; set; } = "Active";
    public string? PatientName { get; set; }
}

public class PharmacyDispenseDto
{
    public int PrescriptionId { get; set; }
    public decimal DispensedQty { get; set; }
    public string? Notes { get; set; }
}

public class AuditLogDto
{
    public int AuditId { get; set; }
    public string TableName { get; set; } = null!;
    public int RecordId { get; set; }
    public string Action { get; set; } = null!;
    public int? UserId { get; set; }
    public string? Username { get; set; }
    public string? OldValues { get; set; }
    public string? NewValues { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class ApiResponse<T>
{
    public bool Success { get; set; }
    public string? Message { get; set; }
    public T? Data { get; set; }
    public List<string>? Errors { get; set; }

    public static ApiResponse<T> SuccessResult(T data, string? message = null)
    {
        return new ApiResponse<T>
        {
            Success = true,
            Message = message,
            Data = data
        };
    }

    public static ApiResponse<T> ErrorResult(string message, List<string>? errors = null)
    {
        return new ApiResponse<T>
        {
            Success = false,
            Message = message,
            Errors = errors
        };
    }
}
