import SwiftUI

struct EucalyptusComparisonView: View {
    let profile: MintProfile
    @State private var selection = "infusion"

    var body: some View {
        DisclosureGroup("Comparar infusión y aceite esencial") {
            VStack(alignment: .leading, spacing: 12) {
                Text(profile.section3.featuredChemistry.title)
                    .font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
                    .fixedSize(horizontal: false, vertical: true)
                Picker("Preparación comparada", selection: $selection) {
                    Text("Infusión").tag("infusion")
                    Text("Aceite esencial").tag("essential_oil")
                }.pickerStyle(.segmented)
                if let preparation = profile.section4.items.first(where: { $0.id == selection }),
                   let experience = preparation.extractionExperience {
                    QuickFact(label: preparation.title, value: preparation.description)
                    ExtractionExplorerView(extraction: preparation.id, experience: experience)
                    QuickFact(label: "Principios fisicoquímicos", value: experience.chemicalPrinciples.joined(separator: " · "))
                    QuickFact(label: "Compuestos relacionados", value: preparation.highlightCompoundIds.compactMap { id in
                        profile.section2.items.first { $0.id == id }?.name
                    }.joined(separator: " · "))
                    QuickFact(label: "Comparación", value: experience.comparisonNote)
                    if let warning = preparation.warning {
                        Label(warning, systemImage: "info.circle")
                            .font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Text(profile.section3.featuredChemistry.description)
                    .font(.system(size: 13)).foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(profile.section3.featuredChemistry.reactionClass)
                    .font(.system(size: 12)).foregroundStyle(Palette.brown)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(.top, 10)
        }
        .font(.system(size: 15, design: .serif)).tint(Palette.olive)
    }
}
