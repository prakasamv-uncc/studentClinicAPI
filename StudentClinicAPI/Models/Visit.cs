using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("visit")]
public class Visit
{
    [Key]
    [Column("visit_id")]
    public int VisitId { get; set; }

    [Column("patient_id")]
    public int PatientId { get; set; }

    [Column("provider_id")]
    public int ProviderId { get; set; }

    [Column("appointment_id")]
    public int? AppointmentId { get; set; }

    [Column("check_in_time")]
    public DateTime? CheckInTime { get; set; }

    [Column("check_out_time")]
    public DateTime? CheckOutTime { get; set; }

    [MaxLength(20)]
    [Column("status")]
    public string Status { get; set; } = "Scheduled";

    [MaxLength(500)]
    [Column("chief_complaint")]
    public string? ChiefComplaint { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("PatientId")]
    public virtual Patient Patient { get; set; } = null!;

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
}
