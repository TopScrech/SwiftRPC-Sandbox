import ScrechKit

struct PresenceCardView: View {
    @Bindable var model: RPCVM
    
    var body: some View {
        CardView("Presence Text", subtitle: "Define the headline and context strings") {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Details", text: $model.details)
                    .textFieldStyle(.roundedBorder)
                
                TextField("State", text: $model.state)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
