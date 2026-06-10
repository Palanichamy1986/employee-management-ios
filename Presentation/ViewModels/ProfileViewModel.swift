import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var employee: Employee?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isSaving = false
    
    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    
    init(
        getProfileUseCase: GetProfileUseCase = GetProfileUseCase(),
        updateProfileUseCase: UpdateProfileUseCase = UpdateProfileUseCase()
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }
    
    @MainActor
    func loadProfile() async {
        isLoading = true
        errorMessage = ""
        
        do {
            self.employee = try await getProfileUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateProfile(request: UpdateProfileRequest) async throws {
        isSaving = true
        defer { isSaving = false }
        
        let updated = try await updateProfileUseCase.execute(request: request)
        self.employee = updated
    }
}
