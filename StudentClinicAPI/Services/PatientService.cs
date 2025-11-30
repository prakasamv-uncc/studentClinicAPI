using Microsoft.EntityFrameworkCore;
using Dapper;
using MySqlConnector;
using StudentClinicAPI.Data;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Models;

namespace StudentClinicAPI.Services;

public class PatientService : IPatientService
{
    private readonly StudentClinicDbContext _context;
    private readonly string _connectionString;
    private readonly ILogger<PatientService> _logger;

    public PatientService(StudentClinicDbContext context, IConfiguration configuration, ILogger<PatientService> logger)
    {
        _context = context;
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string not found");
        _logger = logger;
    }

    public async Task<List<PatientDto>> GetAllPatientsAsync()
    {
        using var connection = new MySqlConnection(_connectionString);
        var patients = await connection.QueryAsync<PatientDto>(
            "CALL sp_get_all_patients()"
        );
        return patients.ToList();
    }

    public async Task<PatientDto?> GetPatientByIdAsync(int patientId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var patient = await connection.QueryFirstOrDefaultAsync<PatientDto>(
            "CALL sp_get_patient_by_id(@PatientId)",
            new { PatientId = patientId }
        );
        return patient;
    }

    public async Task<PatientDto?> GetPatientByMrnAsync(string mrn)
    {
        using var connection = new MySqlConnection(_connectionString);
        var patient = await connection.QueryFirstOrDefaultAsync<PatientDto>(
            "CALL sp_get_patient_by_mrn(@Mrn)",
            new { Mrn = mrn }
        );
        return patient;
    }

    public async Task<PatientDto> CreatePatientAsync(PatientDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        var patientId = await connection.QuerySingleAsync<int>(
            @"CALL sp_create_patient(@Mrn, @FirstName, @LastName, @Dob, @Sex, @Phone, @Email, 
                @AddressLine1, @AddressLine2, @City, @State, @Zip, 
                @EmergencyContactName, @EmergencyContactPhone)",
            new
            {
                dto.Mrn,
                dto.FirstName,
                dto.LastName,
                dto.Dob,
                dto.Sex,
                dto.Phone,
                dto.Email,
                dto.AddressLine1,
                dto.AddressLine2,
                dto.City,
                dto.State,
                dto.Zip,
                dto.EmergencyContactName,
                dto.EmergencyContactPhone
            }
        );

        dto.PatientId = patientId;
        return dto;
    }

    public async Task<PatientDto?> UpdatePatientAsync(int patientId, PatientDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        await connection.ExecuteAsync(
            @"CALL sp_update_patient(@PatientId, @FirstName, @LastName, @Dob, @Sex, @Phone, @Email, 
                @AddressLine1, @AddressLine2, @City, @State, @Zip, 
                @EmergencyContactName, @EmergencyContactPhone)",
            new
            {
                PatientId = patientId,
                dto.FirstName,
                dto.LastName,
                dto.Dob,
                dto.Sex,
                dto.Phone,
                dto.Email,
                dto.AddressLine1,
                dto.AddressLine2,
                dto.City,
                dto.State,
                dto.Zip,
                dto.EmergencyContactName,
                dto.EmergencyContactPhone
            }
        );

        return await GetPatientByIdAsync(patientId);
    }

    public async Task<bool> DeletePatientAsync(int patientId)
    {
        try
        {
            using var connection = new MySqlConnection(_connectionString);
            await connection.ExecuteAsync(
                "CALL sp_delete_patient(@PatientId)",
                new { PatientId = patientId }
            );
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting patient {patientId}");
            return false;
        }
    }

    public async Task<List<PatientDto>> SearchPatientsAsync(string searchTerm)
    {
        using var connection = new MySqlConnection(_connectionString);
        var patients = await connection.QueryAsync<PatientDto>(
            "CALL sp_search_patients(@SearchTerm)",
            new { SearchTerm = $"%{searchTerm}%" }
        );
        return patients.ToList();
    }
}

public class VisitService : IVisitService
{
    private readonly StudentClinicDbContext _context;
    private readonly string _connectionString;
    private readonly ILogger<VisitService> _logger;

    public VisitService(StudentClinicDbContext context, IConfiguration configuration, ILogger<VisitService> logger)
    {
        _context = context;
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string not found");
        _logger = logger;
    }

    public async Task<List<VisitDto>> GetAllVisitsAsync()
    {
        using var connection = new MySqlConnection(_connectionString);
        var visits = await connection.QueryAsync<VisitDto>(
            "CALL sp_get_all_visits()"
        );
        return visits.ToList();
    }

    public async Task<VisitDto?> GetVisitByIdAsync(int visitId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var visit = await connection.QueryFirstOrDefaultAsync<VisitDto>(
            "CALL sp_get_visit_by_id(@VisitId)",
            new { VisitId = visitId }
        );
        return visit;
    }

    public async Task<List<VisitDto>> GetVisitsByPatientIdAsync(int patientId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var visits = await connection.QueryAsync<VisitDto>(
            "CALL sp_get_visits_by_patient(@PatientId)",
            new { PatientId = patientId }
        );
        return visits.ToList();
    }

    public async Task<VisitDto> CreateVisitAsync(VisitDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        var visitId = await connection.QuerySingleAsync<int>(
            @"CALL sp_create_visit(@PatientId, @ProviderId, @AppointmentId, @CheckInTime, 
                @CheckOutTime, @Status, @ChiefComplaint)",
            new
            {
                dto.PatientId,
                dto.ProviderId,
                dto.AppointmentId,
                dto.CheckInTime,
                dto.CheckOutTime,
                dto.Status,
                dto.ChiefComplaint
            }
        );

        dto.VisitId = visitId;
        return dto;
    }

    public async Task<VisitDto?> UpdateVisitAsync(int visitId, VisitDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        await connection.ExecuteAsync(
            @"CALL sp_update_visit(@VisitId, @CheckInTime, @CheckOutTime, @Status, @ChiefComplaint)",
            new
            {
                VisitId = visitId,
                dto.CheckInTime,
                dto.CheckOutTime,
                dto.Status,
                dto.ChiefComplaint
            }
        );

        return await GetVisitByIdAsync(visitId);
    }

    public async Task<bool> DeleteVisitAsync(int visitId)
    {
        try
        {
            using var connection = new MySqlConnection(_connectionString);
            await connection.ExecuteAsync(
                "CALL sp_delete_visit(@VisitId)",
                new { VisitId = visitId }
            );
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting visit {visitId}");
            return false;
        }
    }
}
