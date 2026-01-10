import ScrechKit

struct AssetsCardView: View {
    @Bindable var model: RPCVM
    
    var body: some View {
        CardView("Assets", subtitle: "Match these keys to the assets uploaded in Discord") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                TextField("Large Image Key", text: $model.largeImageKey)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Large Image Text", text: $model.largeImageText)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Small Image Key", text: $model.smallImageKey)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Small Image Text", text: $model.smallImageText)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
