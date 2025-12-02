using System.Data;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using StudentClinicAPI.Data;

namespace StudentClinicAPI.Services;

public class StoredProcedureService
{
    private readonly StudentClinicDbContext _db;
    private readonly ILogger<StoredProcedureService> _logger;

    public StoredProcedureService(StudentClinicDbContext db, ILogger<StoredProcedureService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<Dictionary<string, object>?> GetPatientByIdAsync(int patientId)
    {
        using var conn = _db.Database.GetDbConnection();
        await conn.OpenAsync();
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "CALL sp_get_patient_by_id(@p_patient_id);";
        var p = cmd.CreateParameter();
        p.ParameterName = "@p_patient_id";
        p.Value = patientId;
        cmd.Parameters.Add(p);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            var dict = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                dict[reader.GetName(i)] = await reader.IsDBNullAsync(i) ? null : reader.GetValue(i);
            }
            return dict.ToDictionary(kv => kv.Key, kv => kv.Value!);
        }
        return null;
    }

    public async Task<int> CreatePatientAsync(Dictionary<string, object> input)
    {
        using var conn = _db.Database.GetDbConnection();
        await conn.OpenAsync();
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "CALL sp_create_patient(@mrn,@first,@last,@dob,@sex,@phone,@email,@addr1,@addr2,@city,@state,@zip,@ec_name,@ec_phone,@newid);";
        cmd.CommandType = CommandType.Text;

        void AddParam(string name, object? value)
        {
            var param = cmd.CreateParameter();
            param.ParameterName = name;
            param.Value = value ?? DBNull.Value;
            cmd.Parameters.Add(param);
        }

        AddParam("@mrn", input.GetValueOrDefault("mrn"));
        AddParam("@first", input.GetValueOrDefault("first_name"));
        AddParam("@last", input.GetValueOrDefault("last_name"));
        AddParam("@dob", input.GetValueOrDefault("dob"));
        AddParam("@sex", input.GetValueOrDefault("sex"));
        AddParam("@phone", input.GetValueOrDefault("phone"));
        AddParam("@email", input.GetValueOrDefault("email"));
        AddParam("@addr1", input.GetValueOrDefault("address_line1"));
        AddParam("@addr2", input.GetValueOrDefault("address_line2"));
        AddParam("@city", input.GetValueOrDefault("city"));
        AddParam("@state", input.GetValueOrDefault("state"));
        AddParam("@zip", input.GetValueOrDefault("zip"));
        AddParam("@ec_name", input.GetValueOrDefault("emergency_contact_name"));
        AddParam("@ec_phone", input.GetValueOrDefault("emergency_contact_phone"));

        // OUT parameter placeholder
        var outParam = cmd.CreateParameter();
        outParam.ParameterName = "@newid";
        outParam.DbType = DbType.Int32;
        outParam.Direction = ParameterDirection.Output;
        cmd.Parameters.Add(outParam);

        await cmd.ExecuteNonQueryAsync();

        var newid = outParam.Value == DBNull.Value ? 0 : Convert.ToInt32(outParam.Value);
        return newid;
    }

    public async Task<bool> UpdatePatientAsync(int patientId, Dictionary<string, object> input)
    {
        using var conn = _db.Database.GetDbConnection();
        await conn.OpenAsync();
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "CALL sp_update_patient(@pid,@first,@last,@phone,@email);";
        cmd.CommandType = CommandType.Text;

        var p1 = cmd.CreateParameter(); p1.ParameterName = "@pid"; p1.Value = patientId; cmd.Parameters.Add(p1);
        var p2 = cmd.CreateParameter(); p2.ParameterName = "@first"; p2.Value = input.GetValueOrDefault("first_name") ?? DBNull.Value; cmd.Parameters.Add(p2);
        var p3 = cmd.CreateParameter(); p3.ParameterName = "@last"; p3.Value = input.GetValueOrDefault("last_name") ?? DBNull.Value; cmd.Parameters.Add(p3);
        var p4 = cmd.CreateParameter(); p4.ParameterName = "@phone"; p4.Value = input.GetValueOrDefault("phone") ?? DBNull.Value; cmd.Parameters.Add(p4);
        var p5 = cmd.CreateParameter(); p5.ParameterName = "@email"; p5.Value = input.GetValueOrDefault("email") ?? DBNull.Value; cmd.Parameters.Add(p5);

        var res = await cmd.ExecuteNonQueryAsync();
        return res >= 0;
    }

    public async Task<bool> DeletePrescriptionAsync(int prescriptionId, int requestingUserId)
    {
        using var conn = _db.Database.GetDbConnection();
        await conn.OpenAsync();
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "CALL sp_delete_prescription(@pid,@uid);";
        cmd.CommandType = CommandType.Text;

        var p1 = cmd.CreateParameter(); p1.ParameterName = "@pid"; p1.Value = prescriptionId; cmd.Parameters.Add(p1);
        var p2 = cmd.CreateParameter(); p2.ParameterName = "@uid"; p2.Value = requestingUserId; cmd.Parameters.Add(p2);

        var res = await cmd.ExecuteNonQueryAsync();
        return res >= 0;
    }
}
