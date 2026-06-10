import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var coordinator: AppCoordinator
    @Binding var showLogin: Bool
    
    @State private var merchantId = ""
    @State private var merchantName = ""
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var selectedRole = "MANAGER"
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let roles = ["OWNER", "ADMIN", "MANAGER", "CASHIER", "STAFF"]
    
    var isFormValid: Bool {
        !merchantId.isEmpty && !merchantName.isEmpty && !name.isEmpty &&
        !email.isEmpty && email.contains("@") &&
        !phone.isEmpty && phone.count >= 10 &&
        !password.isEmpty && password.count >= 8
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "person.badge.plus.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Register as an employee")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.bottom, 12)
                
                TextField("Merchant ID", text: $merchantId)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                
                TextField("Merchant Name", text: $merchantName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Full Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                TextField("Phone Number", text: $phone)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Picker("Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role).tag(role)
                    }
                }
                .pickerStyle(.segmented)
                
                Button(action: signup) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isFormValid ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!isFormValid || isLoading)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button("Sign in") {
                        showLogin = true
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(24)
        }
        .background(Color(.systemBackground))
        .alert("Signup Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func signup() {
        isLoading = true
        
        Task {
            do {
                let request = SignupRequest(
                    merchantId: merchantId,
                    merchantName: merchantName,
                    name: name,
                    email: email,
                    phone: phone,
                    password: password,
                    role: selectedRole
                )
                try await authService.signup(request: request)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    SignupView(showLogin: .constant(true))
        .environmentObject(AuthService())
        .environmentObject(AppCoordinator())
}
