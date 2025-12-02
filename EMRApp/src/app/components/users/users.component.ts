import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { UserService } from '../../services/user.service';
import { User, Role, Department } from '../../models/api-response.model';

@Component({
  selector: 'app-users',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent implements OnInit {
  users: User[] = [];
  filteredUsers: User[] = [];
  searchTerm: string = '';
  isLoading: boolean = false;
  errorMessage: string = '';
  showEditModal: boolean = false;
  selectedUser: Partial<User> = {};

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.isLoading = true;
    this.errorMessage = '';

    this.userService.getAllUsers().subscribe({
      next: (response) => {
        if (response.success) {
          this.users = response.data;
          this.filteredUsers = response.data;
        } else {
          this.errorMessage = response.message || 'Failed to load users';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while loading users';
        this.isLoading = false;
      }
    });
  }

  searchUsers(): void {
    if (!this.searchTerm.trim()) {
      this.filteredUsers = this.users;
      return;
    }

    const term = this.searchTerm.toLowerCase();
    this.filteredUsers = this.users.filter(user =>
      user.firstName.toLowerCase().includes(term) ||
      user.lastName.toLowerCase().includes(term) ||
      user.email.toLowerCase().includes(term) ||
      user.roles?.some(r => r.roleName.toLowerCase().includes(term))
    );
  }

  openEditModal(user: User): void {
    // Create a deep copy to pre-populate the form
    this.selectedUser = {
      userId: user.userId,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      isActive: user.isActive,
      roles: user.roles ? [...user.roles] : [],
      departments: user.departments ? [...user.departments] : []
    };
    this.showEditModal = true;
  }

  closeEditModal(): void {
    this.showEditModal = false;
    this.selectedUser = {};
  }

  updateUser(): void {
    if (!this.selectedUser.userId) return;

    this.isLoading = true;

    // Transform the data to match API UserDto structure
    const updatePayload = {
      username: this.selectedUser.email?.split('@')[0] || this.selectedUser.firstName || '',
      displayName: `${this.selectedUser.firstName || ''} ${this.selectedUser.lastName || ''}`.trim(),
      email: this.selectedUser.email || '',
      isActive: this.selectedUser.isActive ?? true,
      roles: this.selectedUser.roles?.map(r => typeof r === 'string' ? r : r.roleName) || [],
      departments: this.selectedUser.departments?.map(d => typeof d === 'string' ? d : d.name) || []
    };

    this.userService.updateUser(this.selectedUser.userId, updatePayload as any).subscribe({
      next: (response) => {
        if (response.success) {
          this.loadUsers();
          this.closeEditModal();
        } else {
          alert('Failed to update user: ' + response.message);
        }
        this.isLoading = false;
      },
      error: (error) => {
        alert('An error occurred while updating the user');
        this.isLoading = false;
      }
    });
  }

  deleteUser(user: User): void {
    if (confirm(`Are you sure you want to delete user ${user.firstName} ${user.lastName}?`)) {
      this.userService.deleteUser(user.userId).subscribe({
        next: (response) => {
          if (response.success) {
            this.loadUsers();
          } else {
            alert('Failed to delete user: ' + response.message);
          }
        },
        error: (error) => {
          alert('An error occurred while deleting the user');
        }
      });
    }
  }

  getRoleNames(roles?: Role[]): string {
    return roles?.map(r => r.roleName).join(', ') || 'No roles';
  }

  getDepartmentNames(departments?: Department[]): string {
    return departments?.map(d => d.name).join(', ') || 'No departments';
  }

  getStatusBadgeClass(isActive: boolean): string {
    return isActive ? 'badge bg-success' : 'badge bg-danger';
  }
}
