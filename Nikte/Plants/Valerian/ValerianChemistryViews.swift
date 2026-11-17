import SwiftUI

struct ValerianDegradationView: View {
    let profile: RosemaryProfile
    @State private var selectedStep = 0

    var body: some View {
        let featured = profile.section3.featuredChemistry
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.reactionType).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
            if let valtrate = profile.section2.items.first(where: { $0.id == "valtrate" }) {
                PlantMoleculeView(compound: valtrate, imagePrefix: "valerian", cid: valtrate.pubchemCID)
                QuickFact(label: "Grupos funcionales", value: valtrate.functionalGroups.joined(separator: " · "))
            }
            ForEach(Array(featured.interactiveSteps.sorted { $0.index < $1.index }.enumerated()), id: \.offset) { index, step in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedStep = index }
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(step.index)").bold().frame(width: 30, height: 30)
                            .background(Palette.sage.opacity(0.35), in: Circle())
                        VStack(alignment: .leading, spacing: 5) {
                            Text(step.title).bold().fixedSize(horizontal: false, vertical: true)
                            if selectedStep == index {
                                Text(step.detail).font(.system(size: 14)).foregroundStyle(Palette.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        Spacer(minLength: 0)
                        Image(systemName: selectedStep == index ? "minus.circle" : "plus.circle")
                    }
                    .font(.system(size: 15, design: .serif)).foregroundStyle(Palette.olive)
                    .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Palette.sage.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(.plain)
            }
            Text(featured.equation).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            QuickFact(label: "Productos de degradación", value: featured.products.joined(separator: " · "))
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct ValerianComparisonView: View {
    let profile: RosemaryProfile
    @State private var selection = "infusion"
    private let comparisonIDs = ["infusion", "hydroalcoholic", "ethanolic_dry", "essential_oil"]

    var body: some View {
        DisclosureGroup("Comparar preparaciones") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Preparación comparada", selection: $selection) {
                    ForEach(comparisonIDs, id: \.self) { id in
                        if let item = profile.section4.items.first(where: { $0.id == id }) {
                            Text(item.title).tag(id)
                        }
                    }
                }.pickerStyle(.menu).tint(Palette.olive)
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
                        Label(warning, systemImage: "info.circle").font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }.padding(.top, 10)
        }.font(.system(size: 15, design: .serif)).tint(Palette.olive)
    }
}
