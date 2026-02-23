import Foundation
import Combine
import SwordRPC
import Socket

@Observable
final class RPCVM {
    var appId = "1367291003089715251"
    var details = "Sandbox"
    var state = "Sandboxing"
    var largeImageKey = ""
    var largeImageText = ""
    var smallImageKey = ""
    var smallImageText = ""
    private(set) var statusMessage = "Disconnected"
    private(set) var isConnected = false
    
    private var rpc: SwordRPC?
    private var activeAppId: String?
    private var retiredRPCs: [SwordRPC] = []
    
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

    func disconnect() {
        guard let rpc else {
            setConnection(connected: false, message: "Disconnected")
            return
        }

        guard closeSocket(in: rpc) else {
            setStatus("Disconnect unsupported by current package API")
            return
        }

        retiredRPCs.append(rpc)
        self.rpc = nil
        activeAppId = nil
        setConnection(connected: false, message: "Disconnected")
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

    private func closeSocket(in rpc: SwordRPC) -> Bool {
        guard let socket = reflectedSocket(in: rpc) else {
            return false
        }

        socket.close()
        return true
    }

    private func reflectedSocket(in rpc: SwordRPC) -> Socket? {
        let rpcMirror = Mirror(reflecting: rpc)

        for child in rpcMirror.children where child.label == "socket" {
            if let socket = child.value as? Socket {
                return socket
            }

            let optionalMirror = Mirror(reflecting: child.value)

            guard optionalMirror.displayStyle == .optional else {
                continue
            }

            if let socket = optionalMirror.children.first?.value as? Socket {
                return socket
            }
        }

        return nil
    }
    
    private func setStatus(_ message: String) {
        statusMessage = message
    }
    
    private func setConnection(connected: Bool, message: String) {
        isConnected = connected
        statusMessage = message
    }
}
