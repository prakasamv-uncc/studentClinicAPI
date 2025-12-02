import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiResponse, Prescription } from '../models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class PrescriptionService {
  private apiUrl = `${environment.apiUrl}/prescriptions`;

  constructor(private http: HttpClient) {}

  getAllPrescriptions(): Observable<ApiResponse<Prescription[]>> {
    return this.http.get<ApiResponse<Prescription[]>>(this.apiUrl);
  }

  getPrescriptionById(id: number): Observable<ApiResponse<Prescription>> {
    return this.http.get<ApiResponse<Prescription>>(`${this.apiUrl}/${id}`);
  }

  getPrescriptionsByPatient(patientId: number): Observable<ApiResponse<Prescription[]>> {
    return this.http.get<ApiResponse<Prescription[]>>(`${this.apiUrl}/patient/${patientId}`);
  }

  createPrescription(prescription: Partial<Prescription>): Observable<ApiResponse<Prescription>> {
    return this.http.post<ApiResponse<Prescription>>(this.apiUrl, prescription);
  }

  updatePrescription(id: number, prescription: Partial<Prescription>): Observable<ApiResponse<Prescription>> {
    return this.http.put<ApiResponse<Prescription>>(`${this.apiUrl}/${id}`, prescription);
  }

  deletePrescription(id: number): Observable<ApiResponse<boolean>> {
    return this.http.delete<ApiResponse<boolean>>(`${this.apiUrl}/${id}`);
  }
}
