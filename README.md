# Employee Management iOS App

A production-ready iOS application for employee authentication and profile management built with SwiftUI and MVVM architecture.

## Features

### Authentication
- Employee Signup with email, phone, password
- Employee Login with email/phone + password
- JWT token-based authentication
- Automatic token refresh on 401 responses
- Secure token storage in Keychain
- Auto-login from saved tokens

### Profile Management
- View employee profile
- Update name and phone number
- Role-based UI adaptation

### RBAC (Role-Based Access Control)
- 5 role levels: OWNER, ADMIN, MANAGER, CASHIER, STAFF
- Role badges with visual indicators
- UI customization based on user role
- Role-restricted screens

### Networking
- URLSession-based API client
- Automatic JWT interceptor
- Centralized endpoint management
- Comprehensive error handling
- Request/response logging

### Security
- Keychain storage for tokens
- UserDefaults for non-sensitive UI state
- Secure password requirements
- HTTP error handling and recovery

### OTP System (Extensible)
- Protocol-based OTP provider
- MockOtpProvider for development
- Factory pattern for provider selection
- Ready for MSG91 and Twilio integration

## Architecture

### Clean Architecture with MVVM

```
App/
├── Presentation/
│   ├── Views/
│   │   ├── Auth/
│   │   ├── Main/
│   │   └── Components/
│   └── ViewModels/
├── Domain/
│   ├── Entities/
│   └── UseCases/
├── Data/
│   ├── DTOs/
│   ├── Repositories/
│   └── Services/
├── Core/
│   ├── Networking/
│   ├── Security/
│   ├── Logging/
│   ├── OTP/
│   └── Extensions/
Services/
and more...
```

## Technology Stack

- **Swift 5.9+**
- **SwiftUI** for UI
- **MVVM** architecture pattern
- **Combine** for reactive programming
- **URLSession** for networking
- **Keychain** for secure storage
- **Swift Concurrency** (async/await)
- **Codable** for JSON serialization

## API Integration

Base URL: `https://api.example.com`

### Auth Endpoints
- `POST /api/v1/auth/signup` - Employee registration
- `POST /api/v1/auth/login` - Employee login
- `POST /api/v1/auth/refresh-token` - Refresh access token
- `POST /api/v1/auth/logout` - Logout

### Profile Endpoints
- `GET /api/v1/profile` - Get employee profile
- `PUT /api/v1/profile` - Update profile

## Data Models

### Employee
```swift
struct Employee {
    let employeeId: String
    let merchantId: String
    let merchantName: String
    let name: String
    let email: String
    let phone: String
    let role: String // OWNER, ADMIN, MANAGER, CASHIER, STAFF
    let status: String // ACTIVE, INACTIVE
    let isEmailVerified: Bool
    let isPhoneVerified: Bool
    let createdAt: String
    let updatedAt: String
}
```

## Setup Instructions

1. **Open in Xcode**
   ```bash
   open EmployeeApp.xcodeproj
   ```

2. **Set Target iOS 17+**
   - Select project → General tab
   - Set Minimum Deployments to iOS 17.0

3. **Configure API Base URL**
   - Edit `Core/Networking/APIClient.swift`
   - Update `baseURL` to your backend endpoint

4. **Build and Run**
   - Select target device/simulator
   - Press Cmd+R

## Usage

### Login
```swift
let request = LoginRequest(
    email: "user@example.com",
    phone: nil,
    password: "Password@123"
)
try await authService.login(request: request)
```

### Signup
```swift
let request = SignupRequest(
    merchantId: "MER001",
    merchantName: "Outlet Studio",
    name: "John Doe",
    email: "john@example.com",
    phone: "+919999999999",
    password: "Password@123",
    role: "MANAGER"
)
try await authService.signup(request: request)
```

### Profile Update
```swift
let request = UpdateProfileRequest(
    name: "Jane Doe",
    phone: "+919999999998"
)
try await profileViewModel.updateProfile(request: request)
```

## OTP Provider Integration

### Using MockOtpProvider (Default)
```swift
let otpProvider = OtpProviderFactory.createProvider(.mock)
try await otpProvider.sendOtp(phone: "+919999999999")
let isValid = try await otpProvider.verifyOtp(phone: "+919999999999", otp: "123456")
```

### Adding New Provider (e.g., Twilio)
1. Create `TwilioOtpProvider: OtpProvider`
2. Implement `sendOtp` and `verifyOtp` methods
3. Add to `OtpProviderFactory`
4. No changes needed to authentication logic

## UI Components

### RoleBadgeView
Displays role with icon and color-coded background

### StatusBadgeView
Shows ACTIVE/INACTIVE status with visual indicators

### EmptyStateView
Customizable empty state with action button

### InfoCardView
Reusable information card with icon and value

## Error Handling

- Centralized `NetworkError` enum
- Automatic token refresh on 401
- User-friendly error messages
- Comprehensive logging for debugging

## Security Features

✅ Keychain storage for tokens
✅ Password validation (uppercase, lowercase, digit, special char)
✅ HTTPS-ready API client
✅ Automatic token refresh
✅ Secure logout with token cleanup
✅ Email and phone validation

## Logging

Structured logging with levels:
- `debug()` - Detailed debugging
- `info()` - General information
- `warning()` - Warning messages
- `error()` - Error messages

## Testing

All components are testable:
- Mock repositories for unit tests
- Mock OTP provider for integration tests
- Dependency injection for easy mocking

## Performance

- Lazy loading of profile data
- Efficient token refresh strategy
- Minimal memory footprint
- Optimized network requests

## Future Enhancements

- Biometric authentication (Face ID/Touch ID)
- Email verification flow
- Phone verification with OTP
- Real OTP provider integration (MSG91, Twilio)
- Offline support with Core Data
- Push notifications
- Analytics integration

## License

MIT

## Support

For issues or questions, please contact the development team.
