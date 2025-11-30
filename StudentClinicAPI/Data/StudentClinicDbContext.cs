using Microsoft.EntityFrameworkCore;
using StudentClinicAPI.Models;

namespace StudentClinicAPI.Data;

public class StudentClinicDbContext : DbContext
{
    public StudentClinicDbContext(DbContextOptions<StudentClinicDbContext> options)
        : base(options)
    {
    }

    public DbSet<Patient> Patients { get; set; }
    public DbSet<StaffUser> StaffUsers { get; set; }
    public DbSet<UserAuth> UserAuths { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<Permission> Permissions { get; set; }
    public DbSet<RolePermission> RolePermissions { get; set; }
    public DbSet<UserRole> UserRoles { get; set; }
    public DbSet<Department> Departments { get; set; }
    public DbSet<StaffDepartment> StaffDepartments { get; set; }
    public DbSet<Visit> Visits { get; set; }
    public DbSet<Prescription> Prescriptions { get; set; }
    public DbSet<PharmacyDispense> PharmacyDispenses { get; set; }
    public DbSet<AuditLog> AuditLogs { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure composite keys
        modelBuilder.Entity<RolePermission>()
            .HasKey(rp => new { rp.RoleId, rp.PermissionId });

        modelBuilder.Entity<UserRole>()
            .HasKey(ur => new { ur.UserId, ur.RoleId });

        modelBuilder.Entity<StaffDepartment>()
            .HasKey(sd => new { sd.UserId, sd.DepartmentId });

        // Configure unique indexes
        modelBuilder.Entity<Patient>()
            .HasIndex(p => p.Mrn)
            .IsUnique();

        modelBuilder.Entity<StaffUser>()
            .HasIndex(u => u.Username)
            .IsUnique();

        modelBuilder.Entity<UserAuth>()
            .HasIndex(ua => ua.Email)
            .IsUnique();

        modelBuilder.Entity<Role>()
            .HasIndex(r => r.RoleName)
            .IsUnique();

        modelBuilder.Entity<Permission>()
            .HasIndex(p => new { p.Resource, p.Action })
            .IsUnique();

        modelBuilder.Entity<Department>()
            .HasIndex(d => d.Name)
            .IsUnique();

        // Configure indexes for performance
        modelBuilder.Entity<Visit>()
            .HasIndex(v => v.PatientId);

        modelBuilder.Entity<Visit>()
            .HasIndex(v => v.CheckInTime);

        modelBuilder.Entity<Prescription>()
            .HasIndex(p => p.VisitId);

        modelBuilder.Entity<Prescription>()
            .HasIndex(p => p.Status);

        modelBuilder.Entity<AuditLog>()
            .HasIndex(a => a.TableName);

        modelBuilder.Entity<AuditLog>()
            .HasIndex(a => a.UserId);

        modelBuilder.Entity<AuditLog>()
            .HasIndex(a => a.CreatedAt);

        // Configure relationships
        modelBuilder.Entity<UserAuth>()
            .HasOne(ua => ua.StaffUser)
            .WithOne(su => su.UserAuth)
            .HasForeignKey<UserAuth>(ua => ua.UserId);

        modelBuilder.Entity<Visit>()
            .HasOne(v => v.Patient)
            .WithMany(p => p.Visits)
            .HasForeignKey(v => v.PatientId);

        modelBuilder.Entity<Prescription>()
            .HasOne(p => p.Visit)
            .WithMany(v => v.Prescriptions)
            .HasForeignKey(p => p.VisitId);

        modelBuilder.Entity<PharmacyDispense>()
            .HasOne(pd => pd.Prescription)
            .WithMany(p => p.PharmacyDispenses)
            .HasForeignKey(pd => pd.PrescriptionId);
    }
}
