import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { AuditService } from '../../services/audit.service';
import { AuditLog } from '../../models/api-response.model';

@Component({
  selector: 'app-audit',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './audit.component.html',
  styleUrls: ['./audit.component.scss']
})
export class AuditComponent implements OnInit {
  auditLogs: AuditLog[] = [];
  filteredLogs: AuditLog[] = [];
  isLoading: boolean = false;
  errorMessage: string = '';

  filterTable: string = '';
  filterOperation: string = '';
  searchTerm: string = '';

  currentPage: number = 1;
  pageSize: number = 50;

  availableTables = [
    'All',
    'patient',
    'visit',
    'prescription',
    'pharmacy_dispense',
    'staff_user',
    'user_auth'
  ];

  availableOperations = [
    'All',
    'INSERT',
    'UPDATE',
    'DELETE'
  ];

  constructor(private auditService: AuditService) {}

  ngOnInit(): void {
    this.loadAuditLogs();
  }

  loadAuditLogs(): void {
    this.isLoading = true;
    this.errorMessage = '';

    this.auditService.getAllAuditLogs(this.currentPage, this.pageSize).subscribe({
      next: (response) => {
        if (response.success) {
          this.auditLogs = response.data;
          this.applyFilters();
        } else {
          this.errorMessage = response.message || 'Failed to load audit logs';
        }
        this.isLoading = false;
      },
      error: (error) => {
        this.errorMessage = 'An error occurred while loading audit logs';
        this.isLoading = false;
      }
    });
  }

  applyFilters(): void {
    let filtered = [...this.auditLogs];

    // Filter by table
    if (this.filterTable && this.filterTable !== 'All') {
      filtered = filtered.filter(log => log.tableName === this.filterTable);
    }

    // Filter by operation
    if (this.filterOperation && this.filterOperation !== 'All') {
      filtered = filtered.filter(log => log.operation === this.filterOperation);
    }

    // Search filter
    if (this.searchTerm.trim()) {
      const term = this.searchTerm.toLowerCase();
      filtered = filtered.filter(log =>
        log.tableName.toLowerCase().includes(term) ||
        log.operation.toLowerCase().includes(term) ||
        log.recordId.toLowerCase().includes(term) ||
        log.changedByName?.toLowerCase().includes(term)
      );
    }

    this.filteredLogs = filtered;
  }

  getOperationBadgeClass(operation: string): string {
    switch (operation) {
      case 'INSERT':
        return 'badge bg-success';
      case 'UPDATE':
        return 'badge bg-warning text-dark';
      case 'DELETE':
        return 'badge bg-danger';
      default:
        return 'badge bg-secondary';
    }
  }

  viewDetails(log: AuditLog): void {
    // You can implement a modal to show old/new values
    const message = `
Audit Log Details:

Table: ${log.tableName}
Operation: ${log.operation}
Record ID: ${log.recordId}
Changed By: ${log.changedByName || 'Unknown'} (ID: ${log.changedBy})
Changed At: ${new Date(log.changedAt).toLocaleString()}

Old Values:
${log.oldValues || 'N/A'}

New Values:
${log.newValues || 'N/A'}
    `;
    alert(message);
  }

  loadNextPage(): void {
    this.currentPage++;
    this.loadAuditLogs();
  }

  loadPreviousPage(): void {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.loadAuditLogs();
    }
  }
}
