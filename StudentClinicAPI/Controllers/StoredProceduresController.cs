using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StudentClinicAPI.Services;

namespace StudentClinicAPI.Controllers;

[ApiController]
public class StoredProceduresController : ControllerBase
{
    private readonly StoredProcedureService _sp;
    private readonly PermissionService _perm;

    public StoredProceduresController(StoredProcedureService sp, PermissionService perm)
    {
        _sp = sp;
        _perm = perm;
    }

    [HttpGet("/api/sp/patients/{id}")]
    public async Task<IActionResult> GetPatient(int id)
    {
        var uidClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(uidClaim, out var userId)) return Unauthorized();

        var ok = await _perm.CheckPermissionAsync(userId, "patient", "SELECT");
        if (!ok) return Forbid();

        var result = await _sp.GetPatientByIdAsync(id);
        if (result == null) return NotFound();
        return Ok(result);
    }

    [HttpPost("/api/sp/patients")]
    public async Task<IActionResult> CreatePatient([FromBody] Dictionary<string, object> body)
    {
        var uidClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(uidClaim, out var userId)) return Unauthorized();

        var ok = await _perm.CheckPermissionAsync(userId, "patient", "INSERT");
        if (!ok) return Forbid();

        var newid = await _sp.CreatePatientAsync(body);
        return CreatedAtAction(nameof(GetPatient), new { id = newid }, new { patient_id = newid });
    }

    [HttpPut("/api/sp/patients/{id}")]
    public async Task<IActionResult> UpdatePatient(int id, [FromBody] Dictionary<string, object> body)
    {
        var uidClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(uidClaim, out var userId)) return Unauthorized();

        var ok = await _perm.CheckPermissionAsync(userId, "patient", "UPDATE");
        if (!ok) return Forbid();

        var res = await _sp.UpdatePatientAsync(id, body);
        if (!res) return StatusCode(500);
        return NoContent();
    }

    [HttpDelete("/api/sp/prescriptions/{id}")]
    public async Task<IActionResult> DeletePrescription(int id)
    {
        var uidClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(uidClaim, out var userId)) return Unauthorized();

        // Allow if user has prescription DELETE permission
        var ok = await _perm.CheckPermissionAsync(userId, "prescription", "DELETE");
        if (!ok)
        {
            // fallback: allow role-based doctors to delete (example)
            var rolesOk = await _perm.CheckPermissionAsync(userId, "admin", "MANAGE_USERS"); // quick role-like check
            if (!rolesOk) return Forbid();
        }

        var res = await _sp.DeletePrescriptionAsync(id, userId);
        if (!res) return StatusCode(500);
        return NoContent();
    }
}
