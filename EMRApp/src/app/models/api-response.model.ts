export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  errors?: string[];
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  userId: number;
  email: string;
  username: string;
  roles: string[];
  permissions?: Permission[];
}

export interface RegisterRequest {
  username: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
}

export interface RegisterFormData extends RegisterRequest {
  confirmPassword: string;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
}

export interface User {
  userId: number;
  email: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
  isActive: boolean;
  roles: Role[];
  departments: Department[];
}

export interface Role {
  roleId: number;
  roleName: string;
  description?: string;
}

export interface Permission {
  permissionId: number;
  permissionName: string;
  description?: string;
}

export interface Department {
  departmentId: number;
  name: string;
  staffCount?: number;
}

export interface UpdateUserDto {
  userId: number;
  username: string;
  displayName: string;
  email: string;
  isActive: boolean;
  roles: string[];
  departments: string[];
}

export interface Patient {
  patientId: number;
  mrn: string;
  firstName: string;
  lastName: string;
  dateOfBirth: Date;
  gender: string;
  phoneNumber?: string;
  email?: string;
  addressLine1?: string;
  addressLine2?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  emergencyContactName?: string;
  emergencyContactPhone?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface Visit {
  visitId: number;
  patientId: number;
  patientName?: string;
  visitDate: Date;
  visitType: string;
  chiefComplaint?: string;
  diagnosis?: string;
  treatmentPlan?: string;
  vitalSigns?: string;
  providerId: number;
  providerName?: string;
  status?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface Prescription {
  prescriptionId: number;
  patientId: number;
  patientName?: string;
  visitId?: number;
  prescriberId: number;
  prescriberName?: string;
  drugName: string;
  dosage: string;
  frequency: string;
  duration: string;
  quantity: number;
  refillsAllowed: number;
  instructions?: string;
  prescribedDate: Date;
  status: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface PharmacyDispense {
  dispenseId: number;
  prescriptionId: number;
  prescriptionDetails?: Prescription;
  pharmacistId: number;
  pharmacistName?: string;
  quantityDispensed: number;
  dispenseDate: Date;
  notes?: string;
}

export interface AuditLog {
  auditId: number;
  tableName: string;
  operation: string;
  recordId: string;
  changedBy: number;
  changedByName?: string;
  changedAt: Date;
  oldValues?: string;
  newValues?: string;
}
