import SwiftUI

// MARK: - 06 · TAB BAR (INICIO / PLANTAS / MALESTARES)

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Inicio", systemImage: "house") }
            NavigationStack { PlantGlossaryView() }
                .tabItem { Label("Plantas", systemImage: "leaf") }
            NavigationStack { AilmentView() }
                .tabItem { Label("Malestares", systemImage: "magnifyingglass") }
        }
        .tint(Palette.olive)
    }
}

