import Foundation

final class LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository = AuthRepository()) {
        self.repository = repository
    }
    
    func execute(request: LoginRequest) async throws -> AuthResponse {
        return try await repository.login(request: request)
    }
}
