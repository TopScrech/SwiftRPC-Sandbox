import Foundation
import Combine
import SwordRPC

final class RPCVM: ObservableObject {
    @Published var appId = ""
    @Published var details = "Testing SwordRPC"
    @Published var state = "In a test app"
    @Published var largeImageKey = ""
    @Published var largeImageText = ""
    @Published var smallImageKey = ""
    @Published var smallImageText = ""
    @Published private(set) var statusMessage = "Disconnected"
    @Published private(set) var isConnected = false
    
    private var rpc: SwordRPC?
    private var activeAppId: String?
    
    func connect() {
        let trimmed = appId.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            setStatus("Enter an application ID")
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
            setStatus("Connect to Discord first")
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
            setStatus("Presence queued")
        }
    }
    
    private func wireHandlers() {
        rpc?.onConnect { [weak self] _ in
            self?.setConnection(connected: true, message: "Connected")
            self?.queuePresence(announce: false)
        }
        
        rpc?.onDisconnect { [weak self] _, _, _ in
            self?.setConnection(connected: false, message: "Disconnected")
        }
        
        rpc?.onError { [weak self] _, code, message in
            self?.setConnection(connected: false, message: "Error \(code): \(message)")
        }
    }
    
    private func setStatus(_ message: String) {
        statusMessage = message
    }
    
    private func setConnection(connected: Bool, message: String) {
        isConnected = connected
        statusMessage = message
    }
}
