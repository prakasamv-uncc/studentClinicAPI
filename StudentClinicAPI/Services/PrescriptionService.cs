using Microsoft.EntityFrameworkCore;
using Dapper;
using MySqlConnector;
using StudentClinicAPI.Data;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Models;

namespace StudentClinicAPI.Services;

public class PrescriptionService : IPrescriptionService
{
    private readonly StudentClinicDbContext _context;
    private readonly string _connectionString;
    private readonly ILogger<PrescriptionService> _logger;

    public PrescriptionService(StudentClinicDbContext context, IConfiguration configuration, ILogger<PrescriptionService> logger)
    {
        _context = context;
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string not found");
        _logger = logger;
    }

    public async Task<List<PrescriptionDto>> GetAllPrescriptionsAsync()
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescriptions = await connection.QueryAsync<PrescriptionDto>(
            "CALL sp_get_all_prescriptions()"
        );
        return prescriptions.ToList();
    }

    public async Task<PrescriptionDto?> GetPrescriptionByIdAsync(int prescriptionId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescription = await connection.QueryFirstOrDefaultAsync<PrescriptionDto>(
            "CALL sp_get_prescription_by_id(@PrescriptionId)",
            new { PrescriptionId = prescriptionId }
        );
        return prescription;
    }

    public async Task<List<PrescriptionDto>> GetPrescriptionsByVisitIdAsync(int visitId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescriptions = await connection.QueryAsync<PrescriptionDto>(
            "CALL sp_get_prescriptions_by_visit(@VisitId)",
            new { VisitId = visitId }
        );
        return prescriptions.ToList();
    }

    public async Task<List<PrescriptionDto>> GetPrescriptionsByPatientIdAsync(int patientId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescriptions = await connection.QueryAsync<PrescriptionDto>(
            "CALL sp_get_prescriptions_by_patient(@PatientId)",
            new { PatientId = patientId }
        );
        return prescriptions.ToList();
    }

    public async Task<PrescriptionDto> CreatePrescriptionAsync(PrescriptionDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescriptionId = await connection.QuerySingleAsync<int>(
            @"CALL sp_create_prescription(@VisitId, @DrugCode, @DrugName, @Dose, @DoseUnit, 
                @Route, @Frequency, @DurationDays, @Quantity, @Refills, @StartDate, @EndDate, @Status)",
            new
            {
                dto.VisitId,
                dto.DrugCode,
                dto.DrugName,
                dto.Dose,
                dto.DoseUnit,
                dto.Route,
                dto.Frequency,
                dto.DurationDays,
                dto.Quantity,
                dto.Refills,
                dto.StartDate,
                dto.EndDate,
                dto.Status
            }
        );

        dto.PrescriptionId = prescriptionId;
        return dto;
    }

    public async Task<PrescriptionDto?> UpdatePrescriptionAsync(int prescriptionId, PrescriptionDto dto)
    {
        using var connection = new MySqlConnection(_connectionString);
        await connection.ExecuteAsync(
            @"CALL sp_update_prescription(@PrescriptionId, @Dose, @DoseUnit, @Route, @Frequency, 
                @DurationDays, @Quantity, @Refills, @StartDate, @EndDate, @Status)",
            new
            {
                PrescriptionId = prescriptionId,
                dto.Dose,
                dto.DoseUnit,
                dto.Route,
                dto.Frequency,
                dto.DurationDays,
                dto.Quantity,
                dto.Refills,
                dto.StartDate,
                dto.EndDate,
                dto.Status
            }
        );

        return await GetPrescriptionByIdAsync(prescriptionId);
    }

    public async Task<bool> DeletePrescriptionAsync(int prescriptionId)
    {
        try
        {
            using var connection = new MySqlConnection(_connectionString);
            await connection.ExecuteAsync(
                "CALL sp_delete_prescription(@PrescriptionId)",
                new { PrescriptionId = prescriptionId }
            );
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting prescription {prescriptionId}");
            return false;
        }
    }
}

public class PharmacyService : IPharmacyService
{
    private readonly StudentClinicDbContext _context;
    private readonly string _connectionString;
    private readonly ILogger<PharmacyService> _logger;

    public PharmacyService(StudentClinicDbContext context, IConfiguration configuration, ILogger<PharmacyService> logger)
    {
        _context = context;
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string not found");
        _logger = logger;
    }

    public async Task<List<PrescriptionDto>> GetPendingPrescriptionsAsync()
    {
        using var connection = new MySqlConnection(_connectionString);
        var prescriptions = await connection.QueryAsync<PrescriptionDto>(
            "SELECT * FROM v_pharmacy_prescriptions WHERE status = 'Active'"
        );
        return prescriptions.ToList();
    }

    public async Task<bool> DispensePrescriptionAsync(int userId, PharmacyDispenseDto dto)
    {
        try
        {
            using var connection = new MySqlConnection(_connectionString);
            await connection.ExecuteAsync(
                "CALL sp_dispense_prescription(@PrescriptionId, @UserId, @DispensedQty, @Notes)",
                new
                {
                    dto.PrescriptionId,
                    UserId = userId,
                    dto.DispensedQty,
                    dto.Notes
                }
            );
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error dispensing prescription {dto.PrescriptionId}");
            return false;
        }
    }

    public async Task<List<dynamic>> GetDispenseHistoryAsync(int prescriptionId)
    {
        using var connection = new MySqlConnection(_connectionString);
        var history = await connection.QueryAsync(
            @"SELECT pd.*, su.username, su.display_name 
              FROM pharmacy_dispense pd 
              JOIN staff_user su ON pd.dispensed_by_user_id = su.user_id 
              WHERE pd.prescription_id = @PrescriptionId 
              ORDER BY pd.dispensed_at DESC",
            new { PrescriptionId = prescriptionId }
        );
        return history.ToList();
    }
}

public class AuditLogService : IAuditLogService
{
    private readonly StudentClinicDbContext _context;
    private readonly ILogger<AuditLogService> _logger;

    public AuditLogService(StudentClinicDbContext context, ILogger<AuditLogService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<List<AuditLogDto>> GetAuditLogsAsync(string? tableName = null, int? userId = null, DateTime? startDate = null, DateTime? endDate = null)
    {
        var query = _context.AuditLogs.AsQueryable();

        if (!string.IsNullOrEmpty(tableName))
        {
            query = query.Where(a => a.TableName == tableName);
        }

        if (userId.HasValue)
        {
            query = query.Where(a => a.UserId == userId.Value);
        }

        if (startDate.HasValue)
        {
            query = query.Where(a => a.CreatedAt >= startDate.Value);
        }

        if (endDate.HasValue)
        {
            query = query.Where(a => a.CreatedAt <= endDate.Value);
        }

        var logs = await query
            .OrderByDescending(a => a.CreatedAt)
            .Select(a => new AuditLogDto
            {
                AuditId = a.AuditId,
                TableName = a.TableName,
                RecordId = a.RecordId,
                Action = a.Action,
                UserId = a.UserId,
                Username = a.Username,
                OldValues = a.OldValues,
                NewValues = a.NewValues,
                CreatedAt = a.CreatedAt
            })
            .Take(1000)
            .ToListAsync();

        return logs;
    }

    public async Task<AuditLogDto?> GetAuditLogByIdAsync(int auditId)
    {
        var log = await _context.AuditLogs.FindAsync(auditId);
        if (log == null) return null;

        return new AuditLogDto
        {
            AuditId = log.AuditId,
            TableName = log.TableName,
            RecordId = log.RecordId,
            Action = log.Action,
            UserId = log.UserId,
            Username = log.Username,
            OldValues = log.OldValues,
            NewValues = log.NewValues,
            CreatedAt = log.CreatedAt
        };
    }
}
