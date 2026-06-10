import Foundation

final class OtpProviderFactory {
    static func createProvider(_ type: OtpProviderType) -> OtpProvider {
        switch type {
        case .mock:
            return MockOtpProvider()
        case .twilio:
            fatalError("Twilio OTP provider not yet implemented")
        case .msg91:
            fatalError("MSG91 OTP provider not yet implemented")
        }
    }
}

enum OtpProviderType {
    case mock
    case twilio
    case msg91
}
