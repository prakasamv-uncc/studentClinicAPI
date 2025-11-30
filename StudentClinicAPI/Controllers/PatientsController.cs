using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Services;

namespace StudentClinicAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PatientsController : ControllerBase
{
    private readonly IPatientService _patientService;
    private readonly ILogger<PatientsController> _logger;

    public PatientsController(IPatientService patientService, ILogger<PatientsController> logger)
    {
        _patientService = patientService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<PatientDto>>>> GetAllPatients()
    {
        try
        {
            var patients = await _patientService.GetAllPatientsAsync();
            return Ok(ApiResponse<List<PatientDto>>.SuccessResult(patients));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all patients");
            return StatusCode(500, ApiResponse<List<PatientDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<PatientDto>>> GetPatientById(int id)
    {
        try
        {
            var patient = await _patientService.GetPatientByIdAsync(id);
            if (patient == null)
            {
                return NotFound(ApiResponse<PatientDto>.ErrorResult("Patient not found"));
            }
            return Ok(ApiResponse<PatientDto>.SuccessResult(patient));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting patient {id}");
            return StatusCode(500, ApiResponse<PatientDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("mrn/{mrn}")]
    public async Task<ActionResult<ApiResponse<PatientDto>>> GetPatientByMrn(string mrn)
    {
        try
        {
            var patient = await _patientService.GetPatientByMrnAsync(mrn);
            if (patient == null)
            {
                return NotFound(ApiResponse<PatientDto>.ErrorResult("Patient not found"));
            }
            return Ok(ApiResponse<PatientDto>.SuccessResult(patient));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting patient by MRN {mrn}");
            return StatusCode(500, ApiResponse<PatientDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<PatientDto>>> CreatePatient([FromBody] PatientDto dto)
    {
        try
        {
            var patient = await _patientService.CreatePatientAsync(dto);
            return CreatedAtAction(nameof(GetPatientById), new { id = patient.PatientId }, 
                ApiResponse<PatientDto>.SuccessResult(patient, "Patient created successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating patient");
            return StatusCode(500, ApiResponse<PatientDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ApiResponse<PatientDto>>> UpdatePatient(int id, [FromBody] PatientDto dto)
    {
        try
        {
            var patient = await _patientService.UpdatePatientAsync(id, dto);
            if (patient == null)
            {
                return NotFound(ApiResponse<PatientDto>.ErrorResult("Patient not found"));
            }
            return Ok(ApiResponse<PatientDto>.SuccessResult(patient, "Patient updated successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error updating patient {id}");
            return StatusCode(500, ApiResponse<PatientDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult<ApiResponse<bool>>> DeletePatient(int id)
    {
        try
        {
            var result = await _patientService.DeletePatientAsync(id);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("Patient not found or could not be deleted"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Patient deleted successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting patient {id}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("search/{searchTerm}")]
    public async Task<ActionResult<ApiResponse<List<PatientDto>>>> SearchPatients(string searchTerm)
    {
        try
        {
            var patients = await _patientService.SearchPatientsAsync(searchTerm);
            return Ok(ApiResponse<List<PatientDto>>.SuccessResult(patients));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error searching patients with term {searchTerm}");
            return StatusCode(500, ApiResponse<List<PatientDto>>.ErrorResult("An error occurred"));
        }
    }
}
