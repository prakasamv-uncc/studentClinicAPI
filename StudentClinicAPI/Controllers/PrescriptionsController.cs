using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Services;
using System.Security.Claims;

namespace StudentClinicAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PrescriptionsController : ControllerBase
{
    private readonly IPrescriptionService _prescriptionService;
    private readonly ILogger<PrescriptionsController> _logger;

    public PrescriptionsController(IPrescriptionService prescriptionService, ILogger<PrescriptionsController> logger)
    {
        _prescriptionService = prescriptionService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<PrescriptionDto>>>> GetAllPrescriptions()
    {
        try
        {
            var prescriptions = await _prescriptionService.GetAllPrescriptionsAsync();
            return Ok(ApiResponse<List<PrescriptionDto>>.SuccessResult(prescriptions));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all prescriptions");
            return StatusCode(500, ApiResponse<List<PrescriptionDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<PrescriptionDto>>> GetPrescriptionById(int id)
    {
        try
        {
            var prescription = await _prescriptionService.GetPrescriptionByIdAsync(id);
            if (prescription == null)
            {
                return NotFound(ApiResponse<PrescriptionDto>.ErrorResult("Prescription not found"));
            }
            return Ok(ApiResponse<PrescriptionDto>.SuccessResult(prescription));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting prescription {id}");
            return StatusCode(500, ApiResponse<PrescriptionDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("visit/{visitId}")]
    public async Task<ActionResult<ApiResponse<List<PrescriptionDto>>>> GetPrescriptionsByVisitId(int visitId)
    {
        try
        {
            var prescriptions = await _prescriptionService.GetPrescriptionsByVisitIdAsync(visitId);
            return Ok(ApiResponse<List<PrescriptionDto>>.SuccessResult(prescriptions));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting prescriptions for visit {visitId}");
            return StatusCode(500, ApiResponse<List<PrescriptionDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("patient/{patientId}")]
    public async Task<ActionResult<ApiResponse<List<PrescriptionDto>>>> GetPrescriptionsByPatientId(int patientId)
    {
        try
        {
            var prescriptions = await _prescriptionService.GetPrescriptionsByPatientIdAsync(patientId);
            return Ok(ApiResponse<List<PrescriptionDto>>.SuccessResult(prescriptions));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting prescriptions for patient {patientId}");
            return StatusCode(500, ApiResponse<List<PrescriptionDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<PrescriptionDto>>> CreatePrescription([FromBody] PrescriptionDto dto)
    {
        try
        {
            var prescription = await _prescriptionService.CreatePrescriptionAsync(dto);
            return CreatedAtAction(nameof(GetPrescriptionById), new { id = prescription.PrescriptionId }, 
                ApiResponse<PrescriptionDto>.SuccessResult(prescription, "Prescription created successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating prescription");
            return StatusCode(500, ApiResponse<PrescriptionDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ApiResponse<PrescriptionDto>>> UpdatePrescription(int id, [FromBody] PrescriptionDto dto)
    {
        try
        {
            var prescription = await _prescriptionService.UpdatePrescriptionAsync(id, dto);
            if (prescription == null)
            {
                return NotFound(ApiResponse<PrescriptionDto>.ErrorResult("Prescription not found"));
            }
            return Ok(ApiResponse<PrescriptionDto>.SuccessResult(prescription, "Prescription updated successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error updating prescription {id}");
            return StatusCode(500, ApiResponse<PrescriptionDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult<ApiResponse<bool>>> DeletePrescription(int id)
    {
        try
        {
            var result = await _prescriptionService.DeletePrescriptionAsync(id);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("Prescription not found or could not be deleted"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Prescription deleted successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting prescription {id}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }
}

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PharmacyController : ControllerBase
{
    private readonly IPharmacyService _pharmacyService;
    private readonly ILogger<PharmacyController> _logger;

    public PharmacyController(IPharmacyService pharmacyService, ILogger<PharmacyController> logger)
    {
        _pharmacyService = pharmacyService;
        _logger = logger;
    }

    [HttpGet("pending")]
    public async Task<ActionResult<ApiResponse<List<PrescriptionDto>>>> GetPendingPrescriptions()
    {
        try
        {
            var prescriptions = await _pharmacyService.GetPendingPrescriptionsAsync();
            return Ok(ApiResponse<List<PrescriptionDto>>.SuccessResult(prescriptions));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting pending prescriptions");
            return StatusCode(500, ApiResponse<List<PrescriptionDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost("dispense")]
    public async Task<ActionResult<ApiResponse<bool>>> DispensePrescription([FromBody] PharmacyDispenseDto dto)
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userIdClaim == null)
            {
                return Unauthorized(ApiResponse<bool>.ErrorResult("User not authenticated"));
            }

            var userId = int.Parse(userIdClaim);
            var result = await _pharmacyService.DispensePrescriptionAsync(userId, dto);

            if (!result)
            {
                return BadRequest(ApiResponse<bool>.ErrorResult("Failed to dispense prescription"));
            }

            return Ok(ApiResponse<bool>.SuccessResult(true, "Prescription dispensed successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error dispensing prescription");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("dispense-history/{prescriptionId}")]
    public async Task<ActionResult<ApiResponse<List<dynamic>>>> GetDispenseHistory(int prescriptionId)
    {
        try
        {
            var history = await _pharmacyService.GetDispenseHistoryAsync(prescriptionId);
            return Ok(ApiResponse<List<dynamic>>.SuccessResult(history));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting dispense history for prescription {prescriptionId}");
            return StatusCode(500, ApiResponse<List<dynamic>>.ErrorResult("An error occurred"));
        }
    }
}
