import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: ProfileViewModel
    
    @State private var name = ""
    @State private var phone = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var isFormValid: Bool {
        !name.isEmpty && name.count >= 2 &&
        !phone.isEmpty && phone.count >= 10
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Phone", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                }
                .padding(16)
                
                Button(action: updateProfile) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!isFormValid || isLoading)
                .padding(16)
                
                Spacer()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let employee = viewModel.employee {
                    name = employee.name
                    phone = employee.phone
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func updateProfile() {
        isLoading = true
        
        Task {
            do {
                let request = UpdateProfileRequest(name: name, phone: phone)
                try await viewModel.updateProfile(request: request)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel())
}
