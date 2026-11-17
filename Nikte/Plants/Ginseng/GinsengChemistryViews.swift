import SwiftUI

struct GinsengPolymerView: View {
    let compound: AloeCompound
    @State private var selectedGroup: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MACROMOLÉCULAS · ESQUEMA")
                .font(.system(size: 11, design: .serif)).tracking(1.5).foregroundStyle(Palette.brown)
            HStack(spacing: 3) {
                Text("…")
                ForEach(0..<3, id: \.self) { index in
                    if index > 0 { Text("—").foregroundStyle(Palette.brown) }
                    Text("Azúcar").font(.system(size: 11, design: .serif)).lineLimit(1).minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, minHeight: 38)
                        .background(Palette.sage.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
                }
                Text("…")
            }.foregroundStyle(Palette.olive)
            Text("Representación conceptual de cadenas de azúcares, no una estructura ni una fórmula molecular única.")
                .font(.system(size: 12)).foregroundStyle(Palette.brown).fixedSize(horizontal: false, vertical: true)
            ForEach(compound.functionalGroups, id: \.self) { group in
                Button {
                    withAnimation { selectedGroup = selectedGroup == group ? nil : group }
                } label: {
                    HStack {
                        Text(group).multilineTextAlignment(.leading)
                        Spacer(minLength: 8)
                        Image(systemName: selectedGroup == group ? "minus.circle" : "plus.circle")
                    }
                    .font(.system(size: 13, design: .serif)).foregroundStyle(Palette.olive)
                    .padding(10).background(Palette.sage.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                }.buttonStyle(.plain)
                if selectedGroup == group {
                    Text(compound.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }.onChange(of: compound.id) { _, _ in selectedGroup = nil }
    }
}

struct GinsengTransformationView: View {
    let profile: GinsengProfile
    @State private var selectedStep = 0
    @State private var selectedCompound = "rb1"

    var body: some View {
        let featured = profile.section3.featuredChemistry
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.reactionType).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.equation).font(.system(size: 14, design: .serif)).foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
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
            Picker("Ginsenósido", selection: $selectedCompound) {
                Text("Rb1").tag("rb1")
                Text("Rd").tag("rd")
                Text("Rg3").tag("rg3")
            }.pickerStyle(.segmented)
            if let compound = profile.section2.items.first(where: { $0.id == selectedCompound }),
               let molecule = compound.smallMolecule {
                Text(compound.name).font(.system(size: 18, design: .serif)).bold().foregroundStyle(Palette.olive)
                FactChip(text: molecule.molecularFormula, symbol: "atom")
                PlantMoleculeView(compound: molecule, imagePrefix: "ginseng", cid: compound.pubchemCID)
                QuickFact(label: "Grupos funcionales", value: compound.functionalGroups.joined(separator: " · "))
                QuickFact(label: "Descripción", value: compound.description)
            }
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct GinsengProcessingComparisonView: View {
    let profile: GinsengProfile
    @State private var selection = "white_root"

    var body: some View {
        DisclosureGroup("Comparar ginseng blanco y rojo") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Raíz procesada", selection: $selection) {
                    Text("Blanco").tag("white_root")
                    Text("Rojo").tag("red_root")
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
                        Label(warning, systemImage: "info.circle").font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Text(profile.section3.featuredChemistry.description)
                    .font(.system(size: 13)).foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(.top, 10)
        }.font(.system(size: 15, design: .serif)).tint(Palette.olive)
    }
}
