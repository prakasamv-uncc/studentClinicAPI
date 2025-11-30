using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("staff_department")]
public class StaffDepartment
{
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("department_id")]
    public int DepartmentId { get; set; }

    [ForeignKey("UserId")]
    public virtual StaffUser StaffUser { get; set; } = null!;

    [ForeignKey("DepartmentId")]
    public virtual Department Department { get; set; } = null!;
}
