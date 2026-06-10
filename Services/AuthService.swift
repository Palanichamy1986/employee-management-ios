import SwiftUI
import Combine

final class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentEmployee: Employee?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let loginUseCase: LoginUseCase
    private let signupUseCase: SignupUseCase
    private let logoutUseCase: LogoutUseCase
    private let getProfileUseCase: GetProfileUseCase
    private let keychainManager: KeychainManager
    private let logger = Logger.shared
    
    init(
        loginUseCase: LoginUseCase = LoginUseCase(),
        signupUseCase: SignupUseCase = SignupUseCase(),
        logoutUseCase: LogoutUseCase = LogoutUseCase(),
        getProfileUseCase: GetProfileUseCase = GetProfileUseCase(),
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.loginUseCase = loginUseCase
        self.signupUseCase = signupUseCase
        self.logoutUseCase = logoutUseCase
        self.getProfileUseCase = getProfileUseCase
        self.keychainManager = keychainManager
        
        checkAuthenticationStatus()
    }
    
    @MainActor
    func login(request: LoginRequest) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await loginUseCase.execute(request: request)
            self.currentEmployee = response.employee
            self.isAuthenticated = true
            logger.info("Login successful")
        } catch {
            logger.error("Login failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func signup(request: SignupRequest) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await signupUseCase.execute(request: request)
            self.currentEmployee = response.employee
            self.isAuthenticated = true
            logger.info("Signup successful")
        } catch {
            logger.error("Signup failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func logout() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await logoutUseCase.execute()
            self.currentEmployee = nil
            self.isAuthenticated = false
            logger.info("Logout successful")
        } catch {
            logger.error("Logout failed: \(error.localizedDescription)")
        }
    }
    
    private func checkAuthenticationStatus() {
        do {
            if let _ = try keychainManager.getAccessToken() {
                self.isAuthenticated = true
                logger.info("User authenticated from keychain")
            }
        } catch {
            logger.error("Authentication check failed: \(error.localizedDescription)")
            self.isAuthenticated = false
        }
    }
}
