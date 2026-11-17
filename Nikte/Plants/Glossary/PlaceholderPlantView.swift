import SwiftUI

// MARK: - VISTA TEMPORAL DE FICHA EN DESARROLLO

struct PlaceholderPlantView: View {
    let plant: PlantGlossaryItem

    var body: some View {
        ZStack {
            BotanicalBackground()
                .allowsHitTesting(false)

            VStack(spacing: 16) {

                Image(plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)

                Text(plant.commonName)
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundStyle(Palette.olive)

                Text(plant.scientificName)
                    .font(.system(size: 18, design: .serif))
                    .italic()
                    .foregroundStyle(Palette.brown)

                Text("Ficha en desarrollo")
                    .font(.system(size: 16))
                    .foregroundStyle(Palette.ink.opacity(0.8))
            }
            .padding(30)
        }
    }
}

