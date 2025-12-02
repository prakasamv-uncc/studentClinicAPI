import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiResponse, AuditLog } from '../models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class AuditService {
  private apiUrl = `${environment.apiUrl}/auditlog`;

  constructor(private http: HttpClient) {}

  getAllAuditLogs(page: number = 1, pageSize: number = 50): Observable<ApiResponse<AuditLog[]>> {
    let params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString());
    return this.http.get<ApiResponse<AuditLog[]>>(this.apiUrl, { params });
  }

  getAuditLogsByTable(tableName: string): Observable<ApiResponse<AuditLog[]>> {
    return this.http.get<ApiResponse<AuditLog[]>>(`${this.apiUrl}/table/${tableName}`);
  }

  getAuditLogsByUser(userId: number): Observable<ApiResponse<AuditLog[]>> {
    return this.http.get<ApiResponse<AuditLog[]>>(`${this.apiUrl}/user/${userId}`);
  }
}
