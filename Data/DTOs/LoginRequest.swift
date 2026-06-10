import Foundation

struct LoginRequest: Encodable {
    let email: String?
    let phone: String?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email, phone, password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let email = email {
            try container.encode(email, forKey: .email)
        }
        if let phone = phone {
            try container.encode(phone, forKey: .phone)
        }
        try container.encode(password, forKey: .password)
    }
}
