import SwiftUI

struct StatusBadgeView: View {
    let status: String
    
    var statusColor: Color {
        status == "ACTIVE" ? .green : .red
    }
    
    var statusIcon: String {
        status == "ACTIVE" ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: statusIcon)
                .font(.system(size: 12))
            
            Text(status)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor.opacity(0.2))
        .foregroundColor(statusColor)
        .cornerRadius(6)
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadgeView(status: "ACTIVE")
        StatusBadgeView(status: "INACTIVE")
    }
    .padding()
}
