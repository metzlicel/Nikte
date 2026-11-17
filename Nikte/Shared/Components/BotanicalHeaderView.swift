import SwiftUI

// MARK: =============================================
// MARK: - 05.4 · ENCABEZADO BOTÁNICO COMPARTIDO
// MARK: =============================================

struct BotanicalHeaderView: View {

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // Fondo rayado vintage
                Image("nikte_vintage_wallpaper")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()

                // Logo de Nikté
                Image("nikte_plant_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width * 0.82
                    )
                    .offset(y: 35)
                    .accessibilityHidden(true)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .frame(height: 240)
        .accessibilityLabel("Nikté")
    }
}
