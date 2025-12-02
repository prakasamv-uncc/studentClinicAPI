import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { LoginResponse } from '../../models/api-response.model';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  currentUser: LoginResponse | null = null;
  stats = {
    patients: 0,
    visits: 0,
    prescriptions: 0,
    pending: 0
  };

  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    this.authService.currentUser$.subscribe(user => {
      this.currentUser = user;
    });

    // In a real app, load statistics from API
    this.loadStatistics();
  }

  loadStatistics(): void {
    // Mock data - replace with actual API calls
    this.stats = {
      patients: 45,
      visits: 128,
      prescriptions: 89,
      pending: 12
    };
  }
}
