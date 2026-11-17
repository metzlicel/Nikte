import SwiftUI


struct AilmentIllustrationView: View {
    var body: some View {
        Image("malestares_ilustracion")
            .resizable()
            .scaledToFit()
            .frame(height: 170)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .accessibilityHidden(true)
    }
}


// MARK: =============================================
// MARK: - 09.10 · TARJETAS DE PLANTAS
// MARK: =============================================

struct AilmentPlantCard: View {

    let plant: PlantGlossaryItem
    let description: String

    var body: some View {

        HStack(alignment: .center, spacing: 15) {

            Image(plant.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 275)

            VStack(alignment: .leading, spacing: 6) {

                Text(plant.commonName)
                    .font(.system(
                        size: 23,
                        weight: .medium,
                        design: .serif
                    ))
                    .foregroundStyle(Palette.ink)

                Text(plant.scientificName)
                    .font(.system(size: 13, design: .serif))
                    .italic()
                    .foregroundStyle(Palette.brown)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Palette.olive)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    Palette.brown.opacity(0.7),
                    lineWidth: 1.2
                )
        )
        .shadow(
            color: Palette.brown.opacity(0.05),
            radius: 5,
            y: 3
        )
    }
}


// MARK: =============================================
// MARK: - 09.11 · LAYOUT DE ETIQUETAS
// MARK: =============================================

// Distribuye las etiquetas en varias filas,
// según el ancho disponible en el iPhone.

struct AilmentFlowLayout: Layout {

    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let width = proposal.width ?? 350

        let sizes = subviews.map {
            $0.sizeThatFits(.unspecified)
        }

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for size in sizes {

            if x > 0 && x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(
            width: width,
            height: y + rowHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(.unspecified)

            if x > bounds.minX &&
                x + size.width > bounds.maxX {

                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height
                )
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}


