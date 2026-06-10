import SwiftUI

struct RoleBadgeView: View {
    let role: String
    
    var roleColor: Color {
        switch role {
        case "OWNER":
            return .red
        case "ADMIN":
            return .orange
        case "MANAGER":
            return .blue
        case "CASHIER":
            return .green
        case "STAFF":
            return .gray
        default:
            return .gray
        }
    }
    
    var roleIcon: String {
        switch role {
        case "OWNER":
            return "crown.fill"
        case "ADMIN":
            return "shield.fill"
        case "MANAGER":
            return "briefcase.fill"
        case "CASHIER":
            return "creditcard.fill"
        case "STAFF":
            return "person.fill"
        default:
            return "person.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: roleIcon)
                .font(.system(size: 12))
            
            Text(role)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(roleColor.opacity(0.2))
        .foregroundColor(roleColor)
        .cornerRadius(6)
    }
}

#Preview {
    VStack(spacing: 12) {
        RoleBadgeView(role: "OWNER")
        RoleBadgeView(role: "ADMIN")
        RoleBadgeView(role: "MANAGER")
        RoleBadgeView(role: "CASHIER")
        RoleBadgeView(role: "STAFF")
    }
    .padding()
}
