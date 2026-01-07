import SwiftUI
import SwordRPC
import Combine

struct ContentView: View {
    @StateObject private var model = RPCViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discord Rich Presence Test")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Fill in the fields below to send text to Discord Rich Presence.")
                .foregroundStyle(.secondary)
            
            Form {
                Section("Connection") {
                    TextField("Application ID", text: $model.appId)
                    HStack {
                        Button("Connect") {
                            model.connect()
                        }
                        .disabled(model.appId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
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
                    Button("Update Presence") {
                        model.sendPresence()
                    }
                    .disabled(!model.isConnected)
                    
                    Text("Presence updates every ~15 seconds after connecting.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(minWidth: 480, minHeight: 560)
    }
}

final class RPCViewModel: ObservableObject {
    @Published var appId = ""
    @Published var details = "Testing SwordRPC"
    @Published var state = "In a test app"
    @Published var largeImageKey = ""
    @Published var largeImageText = ""
    @Published var smallImageKey = ""
    @Published var smallImageText = ""
    @Published var statusMessage = "Disconnected"
    @Published var isConnected = false
    
    private var rpc: SwordRPC?
    private var activeAppId: String?
    
    func connect() {
        let trimmed = appId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            setStatus("Enter an application ID.")
            return
        }
        
        if rpc == nil || activeAppId != trimmed {
            rpc = SwordRPC(appId: trimmed)
            activeAppId = trimmed
            wireHandlers()
        }
        
        setStatus("Connecting...")
        rpc?.connect()
    }
    
    func sendPresence() {
        queuePresence(announce: true)
    }
    
    private func queuePresence(announce: Bool) {
        guard let rpc else {
            setStatus("Connect to Discord first.")
            return
        }
        
        var presence = RichPresence()
        presence.details = details
        presence.state = state
        presence.assets.largeImage = largeImageKey.isEmpty ? nil : largeImageKey
        presence.assets.largeText = largeImageText.isEmpty ? nil : largeImageText
        presence.assets.smallImage = smallImageKey.isEmpty ? nil : smallImageKey
        presence.assets.smallText = smallImageText.isEmpty ? nil : smallImageText
        
        rpc.setPresence(presence)
        if announce {
            setStatus("Presence queued.")
        }
    }
    
    private func wireHandlers() {
        rpc?.onConnect { [weak self] _ in
            self?.setConnection(connected: true, message: "Connected.")
            self?.queuePresence(announce: false)
        }
        
        rpc?.onDisconnect { [weak self] _, _, _ in
            self?.setConnection(connected: false, message: "Disconnected.")
        }
        
        rpc?.onError { [weak self] _, code, message in
            self?.setConnection(connected: false, message: "Error \(code): \(message)")
        }
    }
    
    private func setStatus(_ message: String) {
        DispatchQueue.main.async {
            self.statusMessage = message
        }
    }
    
    private func setConnection(connected: Bool, message: String) {
        DispatchQueue.main.async {
            self.isConnected = connected
            self.statusMessage = message
        }
    }
}

#Preview {
    ContentView()
}
