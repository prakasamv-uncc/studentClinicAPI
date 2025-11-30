using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("permission")]
public class Permission
{
    [Key]
    [Column("permission_id")]
    public int PermissionId { get; set; }

    [Required]
    [MaxLength(80)]
    [Column("resource")]
    public string Resource { get; set; } = null!;

    [Required]
    [MaxLength(40)]
    [Column("action")]
    public string Action { get; set; } = null!;

    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
}
