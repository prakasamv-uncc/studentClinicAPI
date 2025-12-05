import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { RegisterFormData } from '../../models/api-response.model';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent {
  registerData: RegisterFormData = {
    username: '',
    email: '',
    password: '',
    confirmPassword: '',
    firstName: '',
    lastName: '',
    phoneNumber: ''
  };
  errorMessage: string = '';
  successMessage: string = '';
  isLoading: boolean = false;
  passwordStrength: string = '';

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  onSubmit(): void {
    this.errorMessage = '';
    this.successMessage = '';

    // Validation
    if (!this.validateForm()) {
      return;
    }

    this.isLoading = true;

    // Create request without confirmPassword (not needed by API)
    const registerRequest = {
      username: this.registerData.username,
      email: this.registerData.email,
      password: this.registerData.password,
      firstName: this.registerData.firstName,
      lastName: this.registerData.lastName,
      phoneNumber: this.registerData.phoneNumber
    };

    this.authService.register(registerRequest).subscribe({
      next: (response) => {
        if (response.success) {
          this.successMessage = 'Registration successful! Redirecting to login...';
          setTimeout(() => {
            this.router.navigate(['/login'], {
              queryParams: { registered: 'true', email: this.registerData.email }
            });
          }, 2000);
        } else {
          this.errorMessage = response.message || 'Registration failed';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = error.error?.message || 'An error occurred during registration';
        if (error.error?.errors && Array.isArray(error.error.errors)) {
          this.errorMessage += '\n' + error.error.errors.join('\n');
        }
        this.isLoading = false;
      }
    });
  }

  validateForm(): boolean {
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(this.registerData.email)) {
      this.errorMessage = 'Please enter a valid email address';
      return false;
    }

    // Password validation
    if (this.registerData.password.length < 8) {
      this.errorMessage = 'Password must be at least 8 characters long';
      return false;
    }

    // Password strength check
    if (!this.hasPasswordStrength(this.registerData.password)) {
      this.errorMessage = 'Password must contain uppercase, lowercase, number, and special character';
      return false;
    }

    // Password match validation
    if (this.registerData.password !== this.registerData.confirmPassword) {
      this.errorMessage = 'Passwords do not match';
      return false;
    }

    // Username validation
    if (!this.registerData.username.trim()) {
      this.errorMessage = 'Username is required';
      return false;
    }

    if (this.registerData.username.length < 3) {
      this.errorMessage = 'Username must be at least 3 characters long';
      return false;
    }

    if (!/^[a-zA-Z0-9_]+$/.test(this.registerData.username)) {
      this.errorMessage = 'Username can only contain letters, numbers, and underscores';
      return false;
    }

    // Name validation
    if (!this.registerData.firstName.trim()) {
      this.errorMessage = 'First name is required';
      return false;
    }

    if (!this.registerData.lastName.trim()) {
      this.errorMessage = 'Last name is required';
      return false;
    }

    // Phone validation (optional but if provided must be valid)
    if (this.registerData.phoneNumber && this.registerData.phoneNumber.trim()) {
      const phoneRegex = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
      if (!phoneRegex.test(this.registerData.phoneNumber.replace(/\s/g, ''))) {
        this.errorMessage = 'Please enter a valid phone number (e.g., 555-123-4567)';
        return false;
      }
    }

    return true;
  }

  hasPasswordStrength(password: string): boolean {
    const hasUpperCase = /[A-Z]/.test(password);
    const hasLowerCase = /[a-z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
    return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
  }

  checkPasswordStrength(): void {
    const password = this.registerData.password;
    if (!password) {
      this.passwordStrength = '';
      return;
    }

    let strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;

    if (strength <= 2) {
      this.passwordStrength = 'weak';
    } else if (strength <= 4) {
      this.passwordStrength = 'medium';
    } else {
      this.passwordStrength = 'strong';
    }
  }

  getPasswordStrengthClass(): string {
    switch (this.passwordStrength) {
      case 'weak': return 'text-danger';
      case 'medium': return 'text-warning';
      case 'strong': return 'text-success';
      default: return '';
    }
  }
}
