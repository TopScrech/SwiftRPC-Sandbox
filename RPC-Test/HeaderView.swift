import ScrechKit

struct HeaderView: View {
    let isConnected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(52)
                
                Image(systemName: "sparkles")
                    .title2(.semibold)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Discord Rich Presence Test")
                    .title2(.semibold)
                
                Text("Connect, preview, and push your activity with a single click")
                    .secondary()
            }
            
            Spacer()
            
            StatusPillView(isConnected: isConnected)
        }
    }
}
