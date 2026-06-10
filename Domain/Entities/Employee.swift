import Foundation

struct Employee: Identifiable, Codable {
    let id: String
    let employeeId: String
    let merchantId: String
    let merchantName: String
    let name: String
    let email: String
    let phone: String
    let role: String
    let status: String
    let isEmailVerified: Bool
    let isPhoneVerified: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case employeeId, merchantId, merchantName, name, email, phone, role, status
        case isEmailVerified, isPhoneVerified, createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.employeeId = try container.decode(String.self, forKey: .employeeId)
        self.id = employeeId
        self.merchantId = try container.decode(String.self, forKey: .merchantId)
        self.merchantName = try container.decode(String.self, forKey: .merchantName)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.role = try container.decode(String.self, forKey: .role)
        self.status = try container.decode(String.self, forKey: .status)
        self.isEmailVerified = try container.decode(Bool.self, forKey: .isEmailVerified)
        self.isPhoneVerified = try container.decode(Bool.self, forKey: .isPhoneVerified)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(employeeId, forKey: .employeeId)
        try container.encode(merchantId, forKey: .merchantId)
        try container.encode(merchantName, forKey: .merchantName)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(role, forKey: .role)
        try container.encode(status, forKey: .status)
        try container.encode(isEmailVerified, forKey: .isEmailVerified)
        try container.encode(isPhoneVerified, forKey: .isPhoneVerified)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
