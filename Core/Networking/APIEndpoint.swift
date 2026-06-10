import Foundation

enum APIEndpoint {
    case login
    case signup
    case logout
    case refreshToken
    case getProfile
    case updateProfile
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .signup:
            return "/api/v1/auth/signup"
        case .logout:
            return "/api/v1/auth/logout"
        case .refreshToken:
            return "/api/v1/auth/refresh-token"
        case .getProfile:
            return "/api/v1/profile"
        case .updateProfile:
            return "/api/v1/profile"
        }
    }
}
