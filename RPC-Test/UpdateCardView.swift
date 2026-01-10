import ScrechKit

struct UpdateCardView: View {
    var model: RPCVM

    var body: some View {
        CardView("Preview & Update", subtitle: "Push updates whenever you're ready") {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Send the latest info to Discord Rich Presence")
                        .subheadline()

                    Text("Tip: update details, then press Send Presence")
                        .footnote()
                        .secondary()
                }

                Spacer()

                Button("Update Presence", systemImage: "arrow.up.circle.fill", action: model.sendPresence)
                    .buttonStyle(.borderedProminent)
                    .disabled(!model.isConnected)
            }
        }
    }
}
