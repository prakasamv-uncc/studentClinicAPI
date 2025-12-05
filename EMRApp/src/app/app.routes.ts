import { Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { LayoutComponent } from './components/layout/layout.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { PatientsComponent } from './components/patients/patients.component';
import { PatientFormComponent } from './components/patients/patient-form.component';
import { VisitsComponent } from './components/visits/visits.component';
import { PrescriptionsComponent } from './components/prescriptions/prescriptions.component';
import { UsersComponent } from './components/users/users.component';
import { PharmacyComponent } from './components/pharmacy/pharmacy.component';
import { AuditComponent } from './components/audit/audit.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  {
    path: '',
    component: LayoutComponent,
    canActivate: [AuthGuard],
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      { path: 'dashboard', component: DashboardComponent },
      { path: 'patients', component: PatientsComponent },
      { path: 'patients/new', component: PatientFormComponent },
      { path: 'patients/:id', component: PatientFormComponent },
      { path: 'patients/:id/edit', component: PatientFormComponent },
      { path: 'visits', component: VisitsComponent },
      { path: 'prescriptions', component: PrescriptionsComponent },
      { path: 'users', component: UsersComponent },
      { path: 'pharmacy', component: PharmacyComponent },
      { path: 'audit', component: AuditComponent },
      { path: '**', redirectTo: 'dashboard' }
    ]
  }
];
