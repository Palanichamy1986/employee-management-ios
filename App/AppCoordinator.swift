import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    
    func navigateTo(_ destination: AppDestination) {
        navigationPath.append(destination)
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func showError(_ title: String, _ message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

enum AppDestination: Hashable {
    case login
    case signup
    case home
    case profile
    case editProfile
    case roleDetails
    case settings
}
