import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^\\+?[1-9]\\d{1,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let hasUppercase = self.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = self.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasDigit = self.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecial = self.rangeOfCharacter(from: CharacterSet(charactersIn: "@$!%*?&")) != nil
        
        return self.count >= 8 && hasUppercase && hasLowercase && hasDigit && hasSpecial
    }
}
