import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var employee: Employee?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let profileUseCase: GetProfileUseCase
    
    init(profileUseCase: GetProfileUseCase = GetProfileUseCase()) {
        self.profileUseCase = profileUseCase
    }
    
    @MainActor
    func loadProfile() async {
        isLoading = true
        errorMessage = ""
        
        do {
            self.employee = try await profileUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
