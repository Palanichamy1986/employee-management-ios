import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = HomeViewModel()
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let employee = viewModel.employee {
                    ScrollView {
                        VStack(spacing: 24) {
                            WelcomeHeaderView(employee: employee)
                            
                            VStack(spacing: 16) {
                                InfoCardView(
                                    icon: "envelope.fill",
                                    label: "Email",
                                    value: employee.email,
                                    color: .blue
                                )
                                
                                InfoCardView(
                                    icon: "phone.fill",
                                    label: "Phone",
                                    value: employee.phone,
                                    color: .green
                                )
                                
                                InfoCardView(
                                    icon: "building.fill",
                                    label: "Merchant",
                                    value: employee.merchantName,
                                    color: .purple
                                )
                                
                                HStack(spacing: 12) {
                                    RoleBadgeView(role: employee.role)
                                    
                                    StatusBadgeView(status: employee.status)
                                    
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
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
            .navigationTitle("Dashboard")
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

struct WelcomeHeaderView: View {
    let employee: Employee
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back, \(employee.name)!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(employee.merchantName) • \(employee.role)")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemBlue).opacity(0.1))
        .cornerRadius(12)
    }
}

struct InfoCardView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(color)
                .cornerRadius(8)
            
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
    HomeView()
        .environmentObject(AuthService())
}
