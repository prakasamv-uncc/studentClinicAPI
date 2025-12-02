import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiResponse, PharmacyDispense, Prescription } from '../models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class PharmacyService {
  private apiUrl = `${environment.apiUrl}/pharmacy`;

  constructor(private http: HttpClient) {}

  getPendingPrescriptions(): Observable<ApiResponse<Prescription[]>> {
    return this.http.get<ApiResponse<Prescription[]>>(`${this.apiUrl}/pending`);
  }

  dispensePrescription(dispense: Partial<PharmacyDispense>): Observable<ApiResponse<PharmacyDispense>> {
    return this.http.post<ApiResponse<PharmacyDispense>>(`${this.apiUrl}/dispense`, dispense);
  }

  getDispenseHistory(patientId?: number): Observable<ApiResponse<PharmacyDispense[]>> {
    const url = patientId
      ? `${this.apiUrl}/history/${patientId}`
      : `${this.apiUrl}/history`;
    return this.http.get<ApiResponse<PharmacyDispense[]>>(url);
  }
}
