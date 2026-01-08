import ScrechKit

struct ContentView: View {
    @State private var model = RPCVM()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discord Rich Presence Test")
                .title2(.semibold)
            
            Text("Fill in the fields below to send text to Discord Rich Presence")
                .secondary()
            
            Form {
                Section("Connection") {
                    HStack {
                        Button("Connect", action: model.connect)
                        
                        Text(model.statusMessage)
                            .foregroundStyle(model.isConnected ? Color.green : Color.secondary)
                    }
                }
                
                Section("Presence Text") {
                    TextField("Details", text: $model.details)
                    TextField("State", text: $model.state)
                }
                
                Section("Assets") {
                    TextField("Large Image Key", text: $model.largeImageKey)
                    TextField("Large Image Text", text: $model.largeImageText)
                    TextField("Small Image Key", text: $model.smallImageKey)
                    TextField("Small Image Text", text: $model.smallImageText)
                }
                
                Section {
                    Button("Update Presence", action: model.sendPresence)
                        .disabled(!model.isConnected)
                    
                    Text("Presence updates every ~15 seconds after connecting")
                        .secondary()
                }
            }
        }
        .padding()
        .frame(minWidth: 480, minHeight: 560)
    }
}

#Preview {
    ContentView()
}
