using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("pharmacy_dispense")]
public class PharmacyDispense
{
    [Key]
    [Column("dispense_id")]
    public int DispenseId { get; set; }

    [Column("prescription_id")]
    public int PrescriptionId { get; set; }

    [Column("dispensed_by_user_id")]
    public int DispensedByUserId { get; set; }

    [Column("dispensed_qty")]
    public decimal DispensedQty { get; set; }

    [Column("dispensed_at")]
    public DateTime DispensedAt { get; set; }

    [MaxLength(200)]
    [Column("notes")]
    public string? Notes { get; set; }

    [ForeignKey("PrescriptionId")]
    public virtual Prescription Prescription { get; set; } = null!;
}
