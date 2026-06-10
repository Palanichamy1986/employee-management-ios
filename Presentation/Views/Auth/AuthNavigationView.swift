import SwiftUI

struct AuthNavigationView: View {
    @State private var showLogin = true
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            Group {
                if showLogin {
                    LoginView(showSignup: $showLogin)
                } else {
                    SignupView(showLogin: $showLogin)
                }
            }
        }
    }
}

#Preview {
    AuthNavigationView()
        .environmentObject(AuthService())
}
