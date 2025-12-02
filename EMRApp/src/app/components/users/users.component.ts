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
