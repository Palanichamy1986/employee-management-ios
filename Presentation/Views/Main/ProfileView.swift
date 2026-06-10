import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEditSheet = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let employee = viewModel.employee {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 12) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.blue)
                                
                                Text(employee.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                RoleBadgeView(role: employee.role)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(24)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ProfileDetailRow(
                                    icon: "envelope.fill",
                                    label: "Email",
                                    value: employee.email
                                )
                                
                                Divider()
                                
                                ProfileDetailRow(
                                    icon: "phone.fill",
                                    label: "Phone",
                                    value: employee.phone
                                )
                                
                                Divider()
                                
                                ProfileDetailRow(
                                    icon: "building.fill",
                                    label: "Merchant",
                                    value: employee.merchantName
                                )
                                
                                Divider()
                                
                                ProfileDetailRow(
                                    icon: "checkmark.circle.fill",
                                    label: "Status",
                                    value: employee.status
                                )
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            Button(action: { showEditSheet = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    EmptyStateView(
                        icon: "person.crop.circle.badge.exclamationmark",
                        title: "Unable to load profile",
                        message: "Please try again",
                        action: { Task { await viewModel.loadProfile() } }
                    )
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditSheet) {
                EditProfileView(viewModel: viewModel)
            }
            .onAppear {
                Task {
                    await viewModel.loadProfile()
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

struct ProfileDetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService())
}
