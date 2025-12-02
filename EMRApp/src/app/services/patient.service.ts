import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiResponse, Patient } from '../models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class PatientService {
  private apiUrl = `${environment.apiUrl}/patients`;

  constructor(private http: HttpClient) {}

  getAllPatients(searchTerm?: string): Observable<ApiResponse<Patient[]>> {
    let params = new HttpParams();
    if (searchTerm) {
      params = params.set('searchTerm', searchTerm);
    }
    return this.http.get<ApiResponse<Patient[]>>(this.apiUrl, { params });
  }

  getPatientById(id: number): Observable<ApiResponse<Patient>> {
    return this.http.get<ApiResponse<Patient>>(`${this.apiUrl}/${id}`);
  }

  createPatient(patient: Partial<Patient>): Observable<ApiResponse<Patient>> {
    return this.http.post<ApiResponse<Patient>>(this.apiUrl, patient);
  }

  updatePatient(id: number, patient: Partial<Patient>): Observable<ApiResponse<Patient>> {
    return this.http.put<ApiResponse<Patient>>(`${this.apiUrl}/${id}`, patient);
  }

  deletePatient(id: number): Observable<ApiResponse<boolean>> {
    return this.http.delete<ApiResponse<boolean>>(`${this.apiUrl}/${id}`);
  }

  searchPatients(searchTerm: string): Observable<ApiResponse<Patient[]>> {
    return this.http.get<ApiResponse<Patient[]>>(`${this.apiUrl}/search/${searchTerm}`);
  }
}
