# Student Clinic EMR API - Test Script
# PowerShell script to test API endpoints

# Configuration
$baseUrl = "http://localhost:5000"
$skipCert = @{}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Student Clinic EMR API Test Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Login
Write-Host "Test 1: User Login" -ForegroundColor Yellow
Write-Host "Logging in as doc_amy@example.org..." -ForegroundColor Gray

$loginBody = @{
    email = "doc_amy@example.org"
    password = "Welcome!2025"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json" @skipCert
    
    if ($loginResponse.success) {
        Write-Host "✓ Login successful!" -ForegroundColor Green
        Write-Host "  User: $($loginResponse.data.username)" -ForegroundColor Gray
        Write-Host "  Roles: $($loginResponse.data.roles -join ', ')" -ForegroundColor Gray
        
        $token = $loginResponse.data.token
        $headers = @{
            Authorization = "Bearer $token"
            Accept = "application/json"
        }
    } else {
        Write-Host "✗ Login failed!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Get Current User
Write-Host "Test 2: Get Current User Info" -ForegroundColor Yellow

try {
    $meResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/me" -Method Get -Headers $headers @skipCert
    
    if ($meResponse.success) {
        Write-Host "✓ User info retrieved!" -ForegroundColor Green
        Write-Host "  Display Name: $($meResponse.data.displayName)" -ForegroundColor Gray
        Write-Host "  Email: $($meResponse.data.email)" -ForegroundColor Gray
        Write-Host "  Departments: $($meResponse.data.departments -join ', ')" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 3: Get All Patients
Write-Host "Test 3: Get All Patients" -ForegroundColor Yellow

try {
    $patientsResponse = Invoke-RestMethod -Uri "$baseUrl/api/patients" -Method Get -Headers $headers @skipCert
    
    if ($patientsResponse.success) {
        $patientCount = $patientsResponse.data.Count
        Write-Host "✓ Retrieved $patientCount patients" -ForegroundColor Green
        
        if ($patientCount -gt 0) {
            Write-Host "  Sample patient:" -ForegroundColor Gray
            $patient = $patientsResponse.data[0]
            Write-Host "    - MRN: $($patient.mrn)" -ForegroundColor Gray
            Write-Host "    - Name: $($patient.firstName) $($patient.lastName)" -ForegroundColor Gray
            Write-Host "    - DOB: $($patient.dob)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 4: Search Patients
Write-Host "Test 4: Search Patients" -ForegroundColor Yellow

try {
    $searchResponse = Invoke-RestMethod -Uri "$baseUrl/api/patients/search/Kim" -Method Get -Headers $headers @skipCert
    
    if ($searchResponse.success) {
        Write-Host "✓ Search completed - found $($searchResponse.data.Count) results" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 5: Get All Visits
Write-Host "Test 5: Get All Visits" -ForegroundColor Yellow

try {
    $visitsResponse = Invoke-RestMethod -Uri "$baseUrl/api/visits" -Method Get -Headers $headers @skipCert
    
    if ($visitsResponse.success) {
        Write-Host "✓ Retrieved $($visitsResponse.data.Count) visits" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 6: Get All Prescriptions
Write-Host "Test 6: Get All Prescriptions" -ForegroundColor Yellow

try {
    $rxResponse = Invoke-RestMethod -Uri "$baseUrl/api/prescriptions" -Method Get -Headers $headers @skipCert
    
    if ($rxResponse.success) {
        Write-Host "✓ Retrieved $($rxResponse.data.Count) prescriptions" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 7: Get Pending Prescriptions (Pharmacy)
Write-Host "Test 7: Get Pending Prescriptions" -ForegroundColor Yellow

try {
    $pendingResponse = Invoke-RestMethod -Uri "$baseUrl/api/pharmacy/pending" -Method Get -Headers $headers @skipCert
    
    if ($pendingResponse.success) {
        Write-Host "✓ Retrieved $($pendingResponse.data.Count) pending prescriptions" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 8: Get All Departments
Write-Host "Test 8: Get All Departments" -ForegroundColor Yellow

try {
    $deptsResponse = Invoke-RestMethod -Uri "$baseUrl/api/departments" -Method Get -Headers $headers @skipCert
    
    if ($deptsResponse.success) {
        Write-Host "✓ Retrieved $($deptsResponse.data.Count) departments" -ForegroundColor Green
        Write-Host "  Departments:" -ForegroundColor Gray
        foreach ($dept in $deptsResponse.data) {
            Write-Host "    - $($dept.name) ($($dept.staffCount) staff)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 9: Get All Users
Write-Host "Test 9: Get All Users" -ForegroundColor Yellow

try {
    $usersResponse = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get -Headers $headers @skipCert
    
    if ($usersResponse.success) {
        Write-Host "✓ Retrieved $($usersResponse.data.Count) users" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 10: Get Audit Logs
Write-Host "Test 10: Get Audit Logs" -ForegroundColor Yellow

try {
    $auditResponse = Invoke-RestMethod -Uri "$baseUrl/api/auditlog" -Method Get -Headers $headers @skipCert
    
    if ($auditResponse.success) {
        Write-Host "✓ Retrieved $($auditResponse.data.Count) audit log entries" -ForegroundColor Green
        
        if ($auditResponse.data.Count -gt 0) {
            Write-Host "  Recent activity:" -ForegroundColor Gray
            $recent = $auditResponse.data | Select-Object -First 3
            foreach ($log in $recent) {
                Write-Host "    - $($log.action) on $($log.tableName) by $($log.username)" -ForegroundColor Gray
            }
        }
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All Tests Completed!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open Swagger UI at: $baseUrl/swagger" -ForegroundColor Gray
Write-Host "2. Use the token to authorize in Swagger" -ForegroundColor Gray
Write-Host "3. Test POST/PUT/DELETE operations interactively" -ForegroundColor Gray
Write-Host ""
Write-Host "Your JWT Token:" -ForegroundColor Yellow
Write-Host $token -ForegroundColor Gray
