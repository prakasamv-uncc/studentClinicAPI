import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PrescriptionService } from '../../services/prescription.service';
import { Prescription } from '../../models/api-response.model';

@Component({
  selector: 'app-prescriptions',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './prescriptions.component.html',
  styleUrls: ['./prescriptions.component.scss']
})
export class PrescriptionsComponent implements OnInit {
  prescriptions: Prescription[] = [];
  filteredPrescriptions: Prescription[] = [];
  searchTerm: string = '';
  isLoading: boolean = false;
  errorMessage: string = '';

  constructor(private prescriptionService: PrescriptionService) {}

  ngOnInit(): void {
    this.loadPrescriptions();
  }

  loadPrescriptions(): void {
    this.isLoading = true;
    this.prescriptionService.getAllPrescriptions().subscribe({
      next: (response) => {
        if (response.success) {
          this.prescriptions = response.data;
          this.filteredPrescriptions = response.data;
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = 'Error loading prescriptions';
        this.isLoading = false;
      }
    });
  }

  searchPrescriptions(): void {
    if (!this.searchTerm.trim()) {
      this.filteredPrescriptions = this.prescriptions;
      return;
    }

    const term = this.searchTerm.toLowerCase();
    this.filteredPrescriptions = this.prescriptions.filter(rx =>
      rx.drugName.toLowerCase().includes(term) ||
      rx.patientName?.toLowerCase().includes(term) ||
      rx.prescriberName?.toLowerCase().includes(term)
    );
  }

  deletePrescription(rx: Prescription): void {
    if (confirm(`Delete prescription for ${rx.drugName}?`)) {
      this.prescriptionService.deletePrescription(rx.prescriptionId).subscribe({
        next: (response) => {
          if (response.success) {
            this.loadPrescriptions();
          }
        },
        error: (error) => alert('Failed to delete prescription')
      });
    }
  }

  getStatusBadgeClass(status: string): string {
    switch (status.toLowerCase()) {
      case 'active': return 'badge bg-success';
      case 'pending': return 'badge bg-warning';
      case 'dispensed': return 'badge bg-info';
      case 'cancelled': return 'badge bg-danger';
      default: return 'badge bg-secondary';
    }
  }
}
