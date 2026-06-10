import Foundation

final class LogoutUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository = AuthRepository()) {
        self.repository = repository
    }
    
    func execute() async throws {
        return try await repository.logout()
    }
}
