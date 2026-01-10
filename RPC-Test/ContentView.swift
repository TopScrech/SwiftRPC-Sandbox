import ScrechKit

struct ContentView: View {
    @State private var model = RPCVM()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView(isConnected: model.isConnected)
                ConnectionCardView(model: model)
                PresenceCardView(model: model)
                AssetsCardView(model: model)
                UpdateCardView(model: model)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .controlBackgroundColor)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(minWidth: 620, minHeight: 680)
    }
}

#Preview {
    ContentView()
}
