import Foundation

protocol OtpProvider: AnyObject {
    func sendOtp(phone: String) async throws
    func verifyOtp(phone: String, otp: String) async throws -> Bool
}
