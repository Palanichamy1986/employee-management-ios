import Foundation

final class MockOtpProvider: OtpProvider {
    private var mockOtps: [String: String] = [:]
    private let logger = Logger.shared
    
    func sendOtp(phone: String) async throws {
        let otp = String(Int.random(in: 100000...999999))
        mockOtps[phone] = otp
        logger.info("[MOCK OTP] Phone: \(phone), OTP: \(otp)")
    }
    
    func verifyOtp(phone: String, otp: String) async throws -> Bool {
        guard let storedOtp = mockOtps[phone] else {
            return false
        }
        
        let isValid = storedOtp == otp
        if isValid {
            mockOtps.removeValue(forKey: phone)
        }
        return isValid
    }
}
