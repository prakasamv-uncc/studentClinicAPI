import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiResponse, Visit } from '../models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class VisitService {
  private apiUrl = `${environment.apiUrl}/visits`;

  constructor(private http: HttpClient) {}

  getAllVisits(): Observable<ApiResponse<Visit[]>> {
    return this.http.get<ApiResponse<Visit[]>>(this.apiUrl);
  }

  getVisitById(id: number): Observable<ApiResponse<Visit>> {
    return this.http.get<ApiResponse<Visit>>(`${this.apiUrl}/${id}`);
  }

  getVisitsByPatient(patientId: number): Observable<ApiResponse<Visit[]>> {
    return this.http.get<ApiResponse<Visit[]>>(`${this.apiUrl}/patient/${patientId}`);
  }

  createVisit(visit: Partial<Visit>): Observable<ApiResponse<Visit>> {
    return this.http.post<ApiResponse<Visit>>(this.apiUrl, visit);
  }

  updateVisit(id: number, visit: Partial<Visit>): Observable<ApiResponse<Visit>> {
    return this.http.put<ApiResponse<Visit>>(`${this.apiUrl}/${id}`, visit);
  }

  deleteVisit(id: number): Observable<ApiResponse<boolean>> {
    return this.http.delete<ApiResponse<boolean>>(`${this.apiUrl}/${id}`);
  }
}
