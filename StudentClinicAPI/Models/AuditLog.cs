using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StudentClinicAPI.Models;

[Table("audit_log")]
public class AuditLog
{
    [Key]
    [Column("audit_id")]
    public int AuditId { get; set; }

    [Required]
    [MaxLength(50)]
    [Column("table_name")]
    public string TableName { get; set; } = null!;

    [Column("record_id")]
    public int RecordId { get; set; }

    [Required]
    [MaxLength(20)]
    [Column("action")]
    public string Action { get; set; } = null!; // INSERT, UPDATE, DELETE

    [Column("user_id")]
    public int? UserId { get; set; }

    [MaxLength(100)]
    [Column("username")]
    public string? Username { get; set; }

    [Column("old_values")]
    public string? OldValues { get; set; }

    [Column("new_values")]
    public string? NewValues { get; set; }

    [MaxLength(45)]
    [Column("ip_address")]
    public string? IpAddress { get; set; }

    [MaxLength(500)]
    [Column("user_agent")]
    public string? UserAgent { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }
}
