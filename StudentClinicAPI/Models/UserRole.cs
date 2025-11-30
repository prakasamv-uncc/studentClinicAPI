using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("user_role")]
public class UserRole
{
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("role_id")]
    public int RoleId { get; set; }

    [ForeignKey("UserId")]
    public virtual StaffUser StaffUser { get; set; } = null!;

    [ForeignKey("RoleId")]
    public virtual Role Role { get; set; } = null!;
}
