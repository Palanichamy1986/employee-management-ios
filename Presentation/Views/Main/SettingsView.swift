import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showLogoutAlert = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Form {
                    Section(header: Text("Account")) {
                        NavigationLink(destination: AccountSettingsView()) {
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.blue)
                                Text("Account Settings")
                            }
                        }
                    }
                    
                    Section(header: Text("Security")) {
                        Toggle("Biometric Login", isOn: .constant(false))
                    }
                    
                    Section(header: Text("App")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                VStack(spacing: 12) {
                    Button(role: .destructive, action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Logout")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(16)
                
                Spacer()
            }
            .navigationTitle("Settings")
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) { logout() }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private func logout() {
        isLoading = true
        Task {
            await authService.logout()
            isLoading = false
        }
    }
}

struct AccountSettingsView: View {
    var body: some View {
        VStack {
            Text("Account Settings")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthService())
}
