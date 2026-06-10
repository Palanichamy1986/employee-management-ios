import Foundation

final class ProfileRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func getProfile() async throws -> Employee {
        return try await apiClient.request(
            endpoint: .getProfile,
            method: .get,
            responseType: EmployeeResponse.self
        ).data
    }
    
    func updateProfile(request: UpdateProfileRequest) async throws -> Employee {
        return try await apiClient.request(
            endpoint: .updateProfile,
            method: .put,
            body: request,
            responseType: EmployeeResponse.self
        ).data
    }
}

struct EmployeeResponse: Decodable {
    let data: Employee
}
