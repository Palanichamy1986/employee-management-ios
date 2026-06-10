import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(message)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Button(action: action) {
                Text("Try Again")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 8)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    EmptyStateView(
        icon: "exclamationmark.circle.fill",
        title: "Something went wrong",
        message: "Please try again",
        action: { }
    )
}
