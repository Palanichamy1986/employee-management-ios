import Foundation

final class UpdateProfileUseCase {
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func execute(request: UpdateProfileRequest) async throws -> Employee {
        return try await repository.updateProfile(request: request)
    }
}
