import Foundation

struct SignupRequest: Codable {
    let merchantId: String
    let merchantName: String
    let name: String
    let email: String
    let phone: String
    let password: String
    let role: String
}
