using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("prescription")]
public class Prescription
{
    [Key]
    [Column("prescription_id")]
    public int PrescriptionId { get; set; }

    [Column("visit_id")]
    public int VisitId { get; set; }

    [Required]
    [MaxLength(20)]
    [Column("drug_code")]
    public string DrugCode { get; set; } = null!;

    [MaxLength(200)]
    [Column("drug_name")]
    public string? DrugName { get; set; }

    [MaxLength(50)]
    [Column("dose")]
    public string? Dose { get; set; }

    [MaxLength(20)]
    [Column("dose_unit")]
    public string? DoseUnit { get; set; }

    [MaxLength(50)]
    [Column("route")]
    public string? Route { get; set; }

    [MaxLength(100)]
    [Column("frequency")]
    public string? Frequency { get; set; }

    [Column("duration_days")]
    public int? DurationDays { get; set; }

    [Column("quantity")]
    public decimal? Quantity { get; set; }

    [Column("refills")]
    public int? Refills { get; set; }

    [Column("start_date")]
    public DateTime? StartDate { get; set; }

    [Column("end_date")]
    public DateTime? EndDate { get; set; }

    [MaxLength(20)]
    [Column("status")]
    public string Status { get; set; } = "Active";

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("VisitId")]
    public virtual Visit Visit { get; set; } = null!;

    public virtual ICollection<PharmacyDispense> PharmacyDispenses { get; set; } = new List<PharmacyDispense>();
}
