import Foundation

struct AuthResponse: Decodable {
    let employee: Employee
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case employee
        case accessToken
        case refreshToken
    }
}
