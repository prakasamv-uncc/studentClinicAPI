import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PharmacyService } from '../../services/pharmacy.service';
import { Prescription, PharmacyDispense } from '../../models/api-response.model';

@Component({
  selector: 'app-pharmacy',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './pharmacy.component.html',
  styleUrls: ['./pharmacy.component.scss']
})
export class PharmacyComponent implements OnInit {
  pendingPrescriptions: Prescription[] = [];
  dispenseHistory: PharmacyDispense[] = [];
  isLoadingPending: boolean = false;
  isLoadingHistory: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';

  showDispenseForm: boolean = false;
  selectedPrescription?: Prescription;
  dispenseData: Partial<PharmacyDispense> = {
    quantityDispensed: 0,
    notes: ''
  };

  constructor(private pharmacyService: PharmacyService) {}

  ngOnInit(): void {
    this.loadPendingPrescriptions();
    this.loadDispenseHistory();
  }

  loadPendingPrescriptions(): void {
    this.isLoadingPending = true;
    this.errorMessage = '';

    this.pharmacyService.getPendingPrescriptions().subscribe({
      next: (response) => {
        if (response.success) {
          this.pendingPrescriptions = response.data;
        } else {
          this.errorMessage = response.message || 'Failed to load pending prescriptions';
        }
        this.isLoadingPending = false;
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while loading pending prescriptions';
        this.isLoadingPending = false;
      }
    });
  }

  loadDispenseHistory(): void {
    this.isLoadingHistory = true;

    this.pharmacyService.getDispenseHistory().subscribe({
      next: (response) => {
        if (response.success) {
          this.dispenseHistory = response.data;
        }
        this.isLoadingHistory = false;
      },
      error: (error) => {
        this.isLoadingHistory = false;
      }
    });
  }

  openDispenseForm(prescription: Prescription): void {
    this.selectedPrescription = prescription;
    this.dispenseData = {
      prescriptionId: prescription.prescriptionId,
      quantityDispensed: prescription.quantity,
      notes: ''
    };
    this.showDispenseForm = true;
    this.successMessage = '';
    this.errorMessage = '';
  }

  cancelDispense(): void {
    this.showDispenseForm = false;
    this.selectedPrescription = undefined;
    this.dispenseData = { quantityDispensed: 0, notes: '' };
  }

  submitDispense(): void {
    if (!this.dispenseData.quantityDispensed || this.dispenseData.quantityDispensed <= 0) {
      this.errorMessage = 'Please enter a valid quantity';
      return;
    }

    this.pharmacyService.dispensePrescription(this.dispenseData).subscribe({
      next: (response) => {
        if (response.success) {
          this.successMessage = 'Prescription dispensed successfully';
          this.showDispenseForm = false;
          this.selectedPrescription = undefined;
          this.loadPendingPrescriptions();
          this.loadDispenseHistory();

          setTimeout(() => {
            this.successMessage = '';
          }, 3000);
        } else {
          this.errorMessage = response.message || 'Failed to dispense prescription';
        }
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while dispensing prescription';
      }
    });
  }
}
