# 🚀 Quick Start Guide - Full Stack Application

## Running Both API and Angular App Together

### Step 1: Start the ASP.NET Core API

Open a PowerShell terminal:

```powershell
cd C:\UNCC\ITIS-6120-DBA\Project_2\studentClinicAPI\StudentClinicAPI
dotnet run
```

✅ API will be available at: **http://localhost:5000**

### Step 2: Start the Angular Application

Open **another** PowerShell terminal:

```powershell
cd C:\UNCC\ITIS-6120-DBA\Project_2\studentClinicAPI\EMRApp
npm start
```

✅ Angular app will be available at: **http://localhost:4200**

### Step 3: Access the Application

1. Open your browser and go to: **http://localhost:4200**
2. You'll see the login page
3. Login with demo credentials:
   - **Email**: `doc_amy@example.org`
   - **Password**: `Welcome!2025`
4. Start using the application!

## 🎯 Testing the Complete Flow

### 1. Login
- Use the credentials above
- You'll be redirected to the dashboard

### 2. View Patients
- Click "Patients" in the sidebar
- See the list of all patients
- Use the search bar to filter

### 3. Create New Patient
- Click "Add New Patient" button
- Fill in the patient information
- Click "Create Patient"
- Patient will appear in the list

### 4. View Prescriptions
- Click "Prescriptions" in the sidebar
- See all prescriptions
- Filter by drug name, patient, or prescriber

### 5. Dashboard Statistics
- Return to "Dashboard" in sidebar
- View statistics cards
- Use quick action buttons

## 📱 Test Responsive Design

### Desktop View
- Full sidebar with labels
- Wide tables
- Complete navigation

### Tablet View (resize browser < 992px)
- Collapsible sidebar
- Adjusted tables
- Maintained functionality

### Mobile View (resize browser < 576px)
- Hamburger menu
- Mobile-optimized tables
- Touch-friendly buttons

## 🔧 Configuration Files

### API Configuration
File: `StudentClinicAPI/appsettings.json`
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=127.0.0.1;Port=3306;Database=student_clinic_emr;Uid=root;Pwd=root;"
  },
  "JwtSettings": {
    "SecretKey": "your-secret-key-here",
    "Issuer": "StudentClinicAPI",
    "Audience": "StudentClinicApp",
    "ExpirationMinutes": 60
  }
}
```

### Angular Configuration
File: `EMRApp/src/environments/environment.ts`
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5000/api'
};
```

## 🐛 Common Issues & Solutions

### Issue: API won't start
**Solution**: Check if MySQL is running
```powershell
Get-Service MySQL*
# If not running:
Start-Service MySQL80
```

### Issue: Angular app shows connection error
**Solution**: Verify API is running on port 5000
```powershell
# Test API directly
Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method Post -Body '{"email":"doc_amy@example.org","password":"Welcome!2025"}' -ContentType "application/json"
```

### Issue: CORS errors in browser console
**Solution**: API should have CORS configured. Check `Program.cs` has:
```csharp
app.UseCors("AllowAll");
```

### Issue: 401 Unauthorized errors
**Solution**: 
1. Logout and login again
2. Token may have expired
3. Check JWT settings in appsettings.json

## 📊 Test Data Available

The database is pre-populated with:
- **Patients**: Multiple test patients with full demographics
- **Staff Users**: Doctors, nurses, pharmacists with different roles
- **Departments**: Various clinic departments
- **Roles & Permissions**: Complete RBAC setup

## 🎨 UI Elements to Test

### Navigation
- ✅ Sidebar menu items
- ✅ Top bar logout
- ✅ Mobile hamburger menu

### Forms
- ✅ Patient form validation
- ✅ Required field indicators
- ✅ Date pickers
- ✅ Dropdown selects

### Data Tables
- ✅ Search/filter
- ✅ Action buttons (View, Edit, Delete)
- ✅ Responsive columns

### Dashboard
- ✅ Statistics cards
- ✅ Quick actions
- ✅ User profile

## 🚀 Performance Tips

### For Development
- Keep both terminals open
- Use Chrome DevTools for debugging
- Enable Angular DevTools extension

### For Production
```powershell
# Build Angular app
cd EMRApp
npm run build --configuration production

# Build API
cd ../StudentClinicAPI
dotnet publish -c Release
```

## 📚 Additional Resources

- **API Documentation**: Check Swagger at http://localhost:5000/swagger
- **Angular Docs**: https://angular.dev
- **Bootstrap Components**: https://getbootstrap.com/docs/5.3

## ✨ Features to Explore

1. **Authentication Flow**
   - Login/logout
   - Token expiration
   - Protected routes

2. **Patient Management**
   - Full CRUD operations
   - Search functionality
   - Age calculation

3. **Prescription Tracking**
   - Status management
   - Patient associations
   - Prescriber details

4. **Responsive Design**
   - Test on different screen sizes
   - Mobile navigation
   - Touch-friendly interface

---

## 🎉 You're Ready to Go!

Both applications are running and ready for testing. Enjoy exploring the Student Clinic EMR system!

**Need Help?**
- Check `ANGULAR_APP_SUMMARY.md` for detailed Angular info
- Check `README.md` in project root for API info
- Check `QUICKSTART.md` for API setup details

**Happy Testing! 🚀**
