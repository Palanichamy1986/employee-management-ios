import Foundation

struct UpdateProfileRequest: Codable {
    let name: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case name, phone
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        if let phone = phone {
            try container.encode(phone, forKey: .phone)
        }
    }
}
