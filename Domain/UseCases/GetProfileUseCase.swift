import Foundation

final class GetProfileUseCase {
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> Employee {
        return try await repository.getProfile()
    }
}
