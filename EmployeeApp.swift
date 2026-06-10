import SwiftUI

@main
struct EmployeeApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
                    .environmentObject(authService)
                    .environmentObject(coordinator)
            } else {
                AuthNavigationView()
                    .environmentObject(authService)
                    .environmentObject(coordinator)
            }
        }
    }
}
