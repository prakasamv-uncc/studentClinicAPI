using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("department")]
public class Department
{
    [Key]
    [Column("department_id")]
    public int DepartmentId { get; set; }

    [Required]
    [MaxLength(120)]
    [Column("name")]
    public string Name { get; set; } = null!;

    public virtual ICollection<StaffDepartment> StaffDepartments { get; set; } = new List<StaffDepartment>();
}
