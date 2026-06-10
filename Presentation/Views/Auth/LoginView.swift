import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var coordinator: AppCoordinator
    @Binding var showSignup: Bool
    
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var loginMethod: LoginMethod = .email
    
    enum LoginMethod {
        case email
        case phone
    }
    
    var isFormValid: Bool {
        let isEmailValid = loginMethod == .email ? !email.isEmpty && email.contains("@") : true
        let isPhoneValid = loginMethod == .phone ? !phone.isEmpty && phone.count >= 10 : true
        return !password.isEmpty && (isEmailValid || isPhoneValid)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                Text("Employee Portal")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign in to your account")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .padding(.bottom, 20)
            
            Picker("Login Method", selection: $loginMethod) {
                Text("Email").tag(LoginMethod.email)
                Text("Phone").tag(LoginMethod.phone)
            }
            .pickerStyle(.segmented)
            
            if loginMethod == .email {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            } else {
                TextField("Phone Number", text: $phone)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
            }
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button(action: login) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(isFormValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!isFormValid || isLoading)
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                Button("Sign up") {
                    showSignup = true
                }
                .foregroundColor(.blue)
                .fontWeight(.semibold)
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .padding(24)
        .background(Color(.systemBackground))
        .alert("Login Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func login() {
        isLoading = true
        
        Task {
            do {
                let request = LoginRequest(
                    email: loginMethod == .email ? email : nil,
                    phone: loginMethod == .phone ? phone : nil,
                    password: password
                )
                try await authService.login(request: request)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView(showSignup: .constant(false))
        .environmentObject(AuthService())
        .environmentObject(AppCoordinator())
}
