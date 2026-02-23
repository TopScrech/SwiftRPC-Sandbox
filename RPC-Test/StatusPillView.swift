import ScrechKit

struct StatusPillView: View {
    let isConnected: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isConnected ? .green : .gray)
                .frame(8)
            
            Text(isConnected ? "Connected" : "Disconnected")
                .caption(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
