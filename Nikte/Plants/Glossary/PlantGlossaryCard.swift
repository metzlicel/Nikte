import SwiftUI

// MARK: - 04 · TARJETAS DEL GLOSARIO

struct PlantGlossaryCard: View {
    let plant: PlantGlossaryItem

    var body: some View {
        VStack(spacing: 14) {

            Spacer(minLength: 0)

            Image(plant.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Spacer(minLength: 0)

            Text(plant.commonName)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Palette.ink)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            Text(plant.scientificName)
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Palette.brown)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, 8)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Palette.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Palette.line, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

