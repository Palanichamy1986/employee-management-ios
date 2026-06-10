import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        if authService.isAuthenticated {
            MainTabView()
        } else {
            AuthNavigationView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
        .environmentObject(AppCoordinator())
}
