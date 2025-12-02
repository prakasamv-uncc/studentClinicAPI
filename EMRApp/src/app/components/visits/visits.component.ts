import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { VisitService } from '../../services/visit.service';
import { PatientService } from '../../services/patient.service';
import { Visit, Patient } from '../../models/api-response.model';

@Component({
  selector: 'app-visits',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './visits.component.html',
  styleUrls: ['./visits.component.scss']
})
export class VisitsComponent implements OnInit {
  visits: Visit[] = [];
  patients: Patient[] = [];
  filteredVisits: Visit[] = [];
  searchTerm: string = '';
  loading: boolean = false;
  error: string = '';
  showModal: boolean = false;
  isEditMode: boolean = false;

  currentVisit: Partial<Visit> = {
    visitType: 'Check-up',
    status: 'Scheduled'
  };

  visitTypes = ['Check-up', 'Follow-up', 'Emergency', 'Consultation', 'Procedure'];

  constructor(
    private visitService: VisitService,
    private patientService: PatientService
  ) {}

  ngOnInit(): void {
    this.loadVisits();
    this.loadPatients();
  }

  loadVisits(): void {
    this.loading = true;
    this.error = '';
    this.visitService.getAllVisits().subscribe({
      next: (response) => {
        if (response.success && response.data) {
          this.visits = response.data;
          this.filteredVisits = this.visits;
        }
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Failed to load visits';
        this.loading = false;
        console.error('Error loading visits:', err);
      }
    });
  }

  loadPatients(): void {
    this.patientService.getAllPatients().subscribe({
      next: (response) => {
        if (response.success && response.data) {
          this.patients = response.data;
        }
      },
      error: (err) => {
        console.error('Error loading patients:', err);
      }
    });
  }

  filterVisits(): void {
    if (!this.searchTerm.trim()) {
      this.filteredVisits = this.visits;
      return;
    }

    const term = this.searchTerm.toLowerCase();
    this.filteredVisits = this.visits.filter(visit =>
      visit.patientName?.toLowerCase().includes(term) ||
      visit.providerName?.toLowerCase().includes(term) ||
      visit.visitType?.toLowerCase().includes(term) ||
      visit.chiefComplaint?.toLowerCase().includes(term) ||
      visit.diagnosis?.toLowerCase().includes(term)
    );
  }

  openCreateModal(): void {
    this.isEditMode = false;
    this.currentVisit = {
      visitType: 'Check-up',
      visitDate: new Date(),
      status: 'Scheduled'
    };
    this.showModal = true;
  }

  openEditModal(visit: Visit): void {
    this.isEditMode = true;
    this.currentVisit = { ...visit };
    this.showModal = true;
  }

  closeModal(): void {
    this.showModal = false;
    this.currentVisit = {
      visitType: 'Check-up',
      status: 'Scheduled'
    };
  }

  saveVisit(): void {
    if (!this.currentVisit.patientId || !this.currentVisit.providerId) {
      alert('Please select patient and provider');
      return;
    }

    this.loading = true;

    if (this.isEditMode && this.currentVisit.visitId) {
      this.visitService.updateVisit(this.currentVisit.visitId, this.currentVisit).subscribe({
        next: (response) => {
          if (response.success) {
            this.loadVisits();
            this.closeModal();
          }
          this.loading = false;
        },
        error: (err) => {
          alert('Failed to update visit');
          this.loading = false;
          console.error('Error updating visit:', err);
        }
      });
    } else {
      this.visitService.createVisit(this.currentVisit).subscribe({
        next: (response) => {
          if (response.success) {
            this.loadVisits();
            this.closeModal();
          }
          this.loading = false;
        },
        error: (err) => {
          alert('Failed to create visit');
          this.loading = false;
          console.error('Error creating visit:', err);
        }
      });
    }
  }

  deleteVisit(id: number): void {
    if (!confirm('Are you sure you want to delete this visit?')) {
      return;
    }

    this.visitService.deleteVisit(id).subscribe({
      next: (response) => {
        if (response.success) {
          this.loadVisits();
        }
      },
      error: (err) => {
        alert('Failed to delete visit');
        console.error('Error deleting visit:', err);
      }
    });
  }

  getStatusClass(status?: string): string {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return 'badge bg-info';
      case 'in-progress':
        return 'badge bg-primary';
      case 'completed':
        return 'badge bg-success';
      case 'cancelled':
        return 'badge bg-danger';
      default:
        return 'badge bg-secondary';
    }
  }

  formatDate(date: any): string {
    if (!date) return 'N/A';
    return new Date(date).toLocaleDateString();
  }

  formatDateTime(date: any): string {
    if (!date) return 'N/A';
    return new Date(date).toLocaleString();
  }
}
