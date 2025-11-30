using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StudentClinicAPI.DTOs;
using StudentClinicAPI.Services;

namespace StudentClinicAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class VisitsController : ControllerBase
{
    private readonly IVisitService _visitService;
    private readonly ILogger<VisitsController> _logger;

    public VisitsController(IVisitService visitService, ILogger<VisitsController> logger)
    {
        _visitService = visitService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<VisitDto>>>> GetAllVisits()
    {
        try
        {
            var visits = await _visitService.GetAllVisitsAsync();
            return Ok(ApiResponse<List<VisitDto>>.SuccessResult(visits));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all visits");
            return StatusCode(500, ApiResponse<List<VisitDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<VisitDto>>> GetVisitById(int id)
    {
        try
        {
            var visit = await _visitService.GetVisitByIdAsync(id);
            if (visit == null)
            {
                return NotFound(ApiResponse<VisitDto>.ErrorResult("Visit not found"));
            }
            return Ok(ApiResponse<VisitDto>.SuccessResult(visit));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting visit {id}");
            return StatusCode(500, ApiResponse<VisitDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpGet("patient/{patientId}")]
    public async Task<ActionResult<ApiResponse<List<VisitDto>>>> GetVisitsByPatientId(int patientId)
    {
        try
        {
            var visits = await _visitService.GetVisitsByPatientIdAsync(patientId);
            return Ok(ApiResponse<List<VisitDto>>.SuccessResult(visits));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting visits for patient {patientId}");
            return StatusCode(500, ApiResponse<List<VisitDto>>.ErrorResult("An error occurred"));
        }
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<VisitDto>>> CreateVisit([FromBody] VisitDto dto)
    {
        try
        {
            var visit = await _visitService.CreateVisitAsync(dto);
            return CreatedAtAction(nameof(GetVisitById), new { id = visit.VisitId }, 
                ApiResponse<VisitDto>.SuccessResult(visit, "Visit created successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating visit");
            return StatusCode(500, ApiResponse<VisitDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ApiResponse<VisitDto>>> UpdateVisit(int id, [FromBody] VisitDto dto)
    {
        try
        {
            var visit = await _visitService.UpdateVisitAsync(id, dto);
            if (visit == null)
            {
                return NotFound(ApiResponse<VisitDto>.ErrorResult("Visit not found"));
            }
            return Ok(ApiResponse<VisitDto>.SuccessResult(visit, "Visit updated successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error updating visit {id}");
            return StatusCode(500, ApiResponse<VisitDto>.ErrorResult("An error occurred"));
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult<ApiResponse<bool>>> DeleteVisit(int id)
    {
        try
        {
            var result = await _visitService.DeleteVisitAsync(id);
            if (!result)
            {
                return NotFound(ApiResponse<bool>.ErrorResult("Visit not found or could not be deleted"));
            }
            return Ok(ApiResponse<bool>.SuccessResult(true, "Visit deleted successfully"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error deleting visit {id}");
            return StatusCode(500, ApiResponse<bool>.ErrorResult("An error occurred"));
        }
    }
}
