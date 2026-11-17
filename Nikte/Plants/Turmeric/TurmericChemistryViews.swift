import SwiftUI

struct TurmericTautomerView: View {
    let featured: RosemaryOxidation
    @State private var selectedForm = "keto"
    @State private var selectedStep = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.reactionType).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
            Picker("Forma de curcumina", selection: $selectedForm) {
                Text("Forma ceto").tag("keto")
                Text("Forma enol").tag("enol")
            }.pickerStyle(.segmented)
            Text("ESQUEMA DEL FRAGMENTO β-DICARBONILO")
                .font(.system(size: 10, design: .serif)).tracking(1).foregroundStyle(Palette.brown)
            Text(selectedForm == "keto" ? "R–C(=O)–CH₂–C(=O)–R" : "R–C(OH)=CH–C(=O)–R")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .minimumScaleFactor(0.55).lineLimit(1)
                .foregroundStyle(Palette.olive).frame(maxWidth: .infinity).padding(14)
                .background(Palette.card, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel(selectedForm == "keto" ? "Forma ceto: dos carbonilos y un carbono central" : "Forma enol: un hidroxilo enólico y un doble enlace")
            Text(featured.equation).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(Array(featured.interactiveSteps.sorted { $0.index < $1.index }.enumerated()), id: \.offset) { index, step in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedStep = index
                        if index == 0 { selectedForm = "keto" }
                        if index == 2 { selectedForm = "enol" }
                    }
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(step.index)").bold().frame(width: 30, height: 30)
                            .background(Palette.sage.opacity(0.35), in: Circle())
                        VStack(alignment: .leading, spacing: 5) {
                            Text(step.title).bold()
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
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct TurmericSolubilityView: View {
    let profile: RosemaryProfile
    @State private var selection = "infusion"
    private let comparisonIDs = ["infusion", "cooking_fat", "hydroalcoholic"]

    var body: some View {
        DisclosureGroup("Comparar agua, grasa y etanol") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Medio de preparación", selection: $selection) {
                    Text("Agua").tag("infusion")
                    Text("Grasa").tag("cooking_fat")
                    Text("Agua y etanol").tag("hydroalcoholic")
                }.pickerStyle(.menu).tint(Palette.olive)
                if comparisonIDs.contains(selection),
                   let preparation = profile.section4.items.first(where: { $0.id == selection }),
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
                if let mechanism = profile.section3.items.first(where: { $0.id == "bioavailability" }) {
                    QuickFact(label: mechanism.title, value: mechanism.explanation)
                }
            }.padding(.top, 10)
        }.font(.system(size: 15, design: .serif)).tint(Palette.olive)
    }
}
