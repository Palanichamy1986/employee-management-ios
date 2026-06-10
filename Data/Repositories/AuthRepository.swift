import Foundation

final class AuthRepository {
    private let apiClient: APIClient
    private let keychainManager: KeychainManager
    
    init(
        apiClient: APIClient = APIClient.shared,
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.apiClient = apiClient
        self.keychainManager = keychainManager
    }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        let response = try await apiClient.request(
            endpoint: .login,
            method: .post,
            body: request,
            responseType: AuthResponse.self
        )
        
        try keychainManager.saveAccessToken(response.accessToken)
        try keychainManager.saveRefreshToken(response.refreshToken)
        
        return response
    }
    
    func signup(request: SignupRequest) async throws -> AuthResponse {
        let response = try await apiClient.request(
            endpoint: .signup,
            method: .post,
            body: request,
            responseType: AuthResponse.self
        )
        
        try keychainManager.saveAccessToken(response.accessToken)
        try keychainManager.saveRefreshToken(response.refreshToken)
        
        return response
    }
    
    func logout() async throws {
        try await apiClient.request(
            endpoint: .logout,
            method: .post,
            responseType: EmptyResponse.self
        )
        
        try keychainManager.deleteAccessToken()
        try keychainManager.deleteRefreshToken()
    }
    
    func refreshToken() async throws -> String {
        guard let refreshToken = try keychainManager.getRefreshToken() else {
            throw NetworkError.unauthorized
        }
        
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let response = try await apiClient.request(
            endpoint: .refreshToken,
            method: .post,
            body: request,
            responseType: TokenResponse.self
        )
        
        try keychainManager.saveAccessToken(response.accessToken)
        return response.accessToken
    }
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct TokenResponse: Decodable {
    let accessToken: String
    let expiresIn: String
}

struct EmptyResponse: Decodable {}
