import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/api-response.model';

@Component({
  selector: 'app-patients',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './patients.component.html',
  styleUrls: ['./patients.component.scss']
})
export class PatientsComponent implements OnInit {
  patients: Patient[] = [];
  filteredPatients: Patient[] = [];
  searchTerm: string = '';
  isLoading: boolean = false;
  errorMessage: string = '';

  constructor(private patientService: PatientService) {}

  ngOnInit(): void {
    this.loadPatients();
  }

  loadPatients(): void {
    this.isLoading = true;
    this.errorMessage = '';

    this.patientService.getAllPatients().subscribe({
      next: (response) => {
        if (response.success) {
          this.patients = response.data;
          this.filteredPatients = response.data;
        } else {
          this.errorMessage = response.message || 'Failed to load patients';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while loading patients';
        this.isLoading = false;
      }
    });
  }

  searchPatients(): void {
    if (!this.searchTerm.trim()) {
      this.filteredPatients = this.patients;
      return;
    }

    const term = this.searchTerm.toLowerCase();
    this.filteredPatients = this.patients.filter(patient =>
      patient.firstName.toLowerCase().includes(term) ||
      patient.lastName.toLowerCase().includes(term) ||
      patient.mrn.toLowerCase().includes(term) ||
      patient.email?.toLowerCase().includes(term)
    );
  }

  deletePatient(patient: Patient): void {
    if (confirm(`Are you sure you want to delete patient ${patient.firstName} ${patient.lastName}?`)) {
      this.patientService.deletePatient(patient.patientId).subscribe({
        next: (response) => {
          if (response.success) {
            this.loadPatients();
          } else {
            alert('Failed to delete patient: ' + response.message);
          }
        },
        error: (error) => {
          alert('An error occurred while deleting the patient');
        }
      });
    }
  }

  getAge(dateOfBirth: Date): number {
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();

    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }

    return age;
  }
}
