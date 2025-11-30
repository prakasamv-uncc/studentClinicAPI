using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("patient")]
public class Patient
{
    [Key]
    [Column("patient_id")]
    public int PatientId { get; set; }

    [Required]
    [MaxLength(20)]
    [Column("mrn")]
    public string Mrn { get; set; } = null!;

    [Required]
    [MaxLength(60)]
    [Column("first_name")]
    public string FirstName { get; set; } = null!;

    [Required]
    [MaxLength(60)]
    [Column("last_name")]
    public string LastName { get; set; } = null!;

    [Column("dob")]
    public DateTime Dob { get; set; }

    [Required]
    [MaxLength(1)]
    [Column("sex")]
    public string Sex { get; set; } = null!;

    [MaxLength(20)]
    [Column("phone")]
    public string? Phone { get; set; }

    [MaxLength(150)]
    [Column("email")]
    public string? Email { get; set; }

    [MaxLength(100)]
    [Column("address_line1")]
    public string? AddressLine1 { get; set; }

    [MaxLength(100)]
    [Column("address_line2")]
    public string? AddressLine2 { get; set; }

    [MaxLength(50)]
    [Column("city")]
    public string? City { get; set; }

    [MaxLength(20)]
    [Column("state")]
    public string? State { get; set; }

    [MaxLength(10)]
    [Column("zip")]
    public string? Zip { get; set; }

    [MaxLength(100)]
    [Column("emergency_contact_name")]
    public string? EmergencyContactName { get; set; }

    [MaxLength(20)]
    [Column("emergency_contact_phone")]
    public string? EmergencyContactPhone { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<Visit> Visits { get; set; } = new List<Visit>();
}
