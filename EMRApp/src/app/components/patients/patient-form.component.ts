import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute, RouterModule } from '@angular/router';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/api-response.model';

@Component({
  selector: 'app-patient-form',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './patient-form.component.html',
  styleUrls: ['./patient-form.component.scss']
})
export class PatientFormComponent implements OnInit {
  patient: Partial<Patient> = {
    mrn: '',
    firstName: '',
    lastName: '',
    dateOfBirth: new Date(),
    gender: 'M',
    phoneNumber: '',
    email: '',
    addressLine1: '',
    addressLine2: '',
    city: '',
    state: '',
    zipCode: '',
    emergencyContactName: '',
    emergencyContactPhone: ''
  };

  isEditMode: boolean = false;
  isLoading: boolean = false;
  errorMessage: string = '';
  patientId?: number;

  constructor(
    private patientService: PatientService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.patientId = +params['id'];
        this.isEditMode = true;
        this.loadPatient(this.patientId);
      }
    });
  }

  loadPatient(id: number): void {
    this.isLoading = true;
    this.patientService.getPatientById(id).subscribe({
      next: (response) => {
        if (response.success) {
          this.patient = response.data;
          // Convert date to yyyy-MM-dd format for HTML date input
          if (this.patient.dateOfBirth) {
            const date = new Date(this.patient.dateOfBirth);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            this.patient.dateOfBirth = `${year}-${month}-${day}` as any;
          }
        } else {
          this.errorMessage = 'Failed to load patient';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while loading patient';
        this.isLoading = false;
      }
    });
  }

  onSubmit(): void {
    this.isLoading = true;
    this.errorMessage = '';

    const operation = this.isEditMode
      ? this.patientService.updatePatient(this.patientId!, this.patient)
      : this.patientService.createPatient(this.patient);

    operation.subscribe({
      next: (response) => {
        if (response.success) {
          this.router.navigate(['/patients']);
        } else {
          this.errorMessage = response.message || 'Operation failed';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = error.error?.message || 'An error occurred';
        this.isLoading = false;
      }
    });
  }

  cancel(): void {
    this.router.navigate(['/patients']);
  }
}
