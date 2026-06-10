import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func withErrorAlert(
        isPresented: Binding<Bool>,
        title: String = "Error",
        message: Binding<String>
    ) -> some View {
        self.alert(title, isPresented: isPresented) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(message.wrappedValue)
        }
    }
}
