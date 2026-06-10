import Foundation

final class SignupUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository = AuthRepository()) {
        self.repository = repository
    }
    
    func execute(request: SignupRequest) async throws -> AuthResponse {
        return try await repository.signup(request: request)
    }
}
