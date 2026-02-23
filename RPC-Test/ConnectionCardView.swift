import ScrechKit

struct ConnectionCardView: View {
    @Bindable var model: RPCVM
    
    var body: some View {
        CardView("Connection", subtitle: "Point the app at your Discord application") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Application ID")
                            .subheadline(.medium)
                        
                        TextField("Enter application ID", text: $model.appId)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Status")
                            .subheadline(.medium)
                        
                        Text(model.statusMessage)
                            .subheadline()
                            .foregroundStyle(model.isConnected ? .green : .secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                HStack(spacing: 12) {
                    Button("Connect", systemImage: "bolt.horizontal.circle.fill", action: model.connect)
                        .buttonStyle(.borderedProminent)
                    
                    Button("Disconnect", systemImage: "xmark.circle.fill", action: model.disconnect)
                        .buttonStyle(.bordered)
                        .disabled(!model.isConnected)
                    
                    Button("Send Presence", systemImage: "paperplane.fill", action: model.sendPresence)
                        .buttonStyle(.bordered)
                        .disabled(!model.isConnected)
                }
                
                Text("Presence updates every ~15 seconds after connecting")
                    .footnote()
                    .secondary()
            }
        }
    }
}
