import SwiftUI

struct AloePolymerView: View {
    let compound: AloeCompound
    @State private var selectedGroup: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CADENA DE POLISACÁRIDO · ESQUEMA")
                .font(.system(size: 11, design: .serif)).tracking(1.5).foregroundStyle(Palette.brown)
            HStack(spacing: 3) {
                Text("…")
                ForEach(0..<3, id: \.self) { index in
                    if index > 0 {
                        Text("—").foregroundStyle(Palette.brown)
                    }
                    Text(compound.id == "acemannan" ? "Manosa" : "Azúcar")
                        .font(.system(size: 11, design: .serif))
                        .minimumScaleFactor(0.7).lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 38)
                        .background(Palette.sage.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
                }
                Text("…")
            }.foregroundStyle(Palette.olive)
            Text(compound.id == "acemannan" ? "Unidades de manosa unidas por enlaces glucosídicos β(1→4)." : "Unidades de glucosa y manosa unidas por enlaces glucosídicos; secuencia y longitud variables.")
                .font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("Representación conceptual, no estructura molecular única ni fórmula fija del polímero natural.")
                .font(.system(size: 12)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
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
        }
        .onChange(of: compound.id) { _, _ in selectedGroup = nil }
    }
}

struct AloeMechanismsView: View {
    let profile: AloeProfile
    @State private var selectedMechanism = "water_hbond"
    @State private var selectedStep = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MechanismPicker(options: profile.section3.items.map { (id: $0.id, title: $0.title) }, selection: $selectedMechanism)
            if let mechanism = profile.section3.items.first(where: { $0.id == selectedMechanism }) {
                QuickFact(label: "Compuestos relacionados", value: mechanism.compoundIds.compactMap { id in
                    profile.section2.items.first { $0.id == id }?.name
                }.joined(separator: " · "))
                ForEach(Array(mechanism.steps.enumerated()), id: \.offset) { index, step in
                    if index > 0 {
                        Image(systemName: "arrow.down").foregroundStyle(Palette.olive).frame(maxWidth: .infinity)
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedStep = index }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Text(String(format: "%02d", index + 1)).font(.system(size: 15, design: .serif)).bold()
                                .frame(width: 32, height: 32).background(Palette.sage.opacity(0.35), in: Circle())
                            VStack(alignment: .leading, spacing: 5) {
                                Text(step.title).font(.system(size: 17, design: .serif)).bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                if selectedStep == index {
                                    Text(step.detail).font(.system(size: 14)).foregroundStyle(Palette.ink)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            Spacer(minLength: 0)
                            Image(systemName: selectedStep == index ? "minus.circle" : "plus.circle")
                        }
                        .foregroundStyle(Palette.olive).padding(12).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain)
                }
                QuickFact(label: "Explicación científica", value: mechanism.explanation)
                PlainLanguageCard(text: mechanism.plainLanguage)
            }
        }.onChange(of: selectedMechanism) { _, _ in selectedStep = 0 }
    }
}

struct AloeLayersView: View {
    let profile: AloeProfile
    @State private var selection = "gel"

    var body: some View {
        let featured = profile.section3.featuredChemistry
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            Text("Esquema de un corte de hoja: selecciona una zona.")
                .font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
            ZStack {
                RoundedRectangle(cornerRadius: 75).fill(Palette.olive.opacity(0.75))
                RoundedRectangle(cornerRadius: 65).fill(Color.yellow.opacity(0.65)).padding(14)
                RoundedRectangle(cornerRadius: 55).fill(Palette.card).padding(28)
                Text("GEL INTERNO").font(.system(size: 11, design: .serif)).tracking(1).foregroundStyle(Palette.olive)
            }
            .frame(maxWidth: .infinity).frame(height: 150)
            .accessibilityLabel("Esquema de hoja: corteza exterior, zona subepidérmica con látex y gel interno")
            ForEach([("cortex", "Corteza"), ("latex", "Zona subepidérmica · látex amarillo"), ("gel", "Gel interno")], id: \.0) { id, title in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selection = id }
                } label: {
                    HStack {
                        Image(systemName: selection == id ? "checkmark.circle.fill" : "circle")
                        Text(title).multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .font(.system(size: 14, design: .serif)).foregroundStyle(Palette.olive)
                    .padding(10).background(Palette.sage.opacity(selection == id ? 0.4 : 0.15), in: RoundedRectangle(cornerRadius: 10))
                }.buttonStyle(.plain)
            }
            if selection == "gel", let gel = profile.section4.items.first(where: { $0.id == "inner_gel" }) {
                QuickFact(label: gel.title, value: gel.description)
                QuickFact(label: "Compuestos relacionados", value: names(gel.highlightCompoundIds))
                if let warning = gel.warning { safety(warning) }
            } else if selection == "latex", let latex = profile.section4.items.first(where: { $0.id == "yellow_latex" }) {
                QuickFact(label: latex.title, value: latex.description)
                QuickFact(label: "Compuestos relacionados", value: names(latex.highlightCompoundIds))
                if let warning = latex.warning { safety(warning) }
            } else if let leaf = profile.section4.items.first(where: { $0.id == "whole_leaf" }) {
                QuickFact(label: leaf.title, value: leaf.description)
                if let warning = leaf.warning { safety(warning) }
            }
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.reactionClass).font(.system(size: 12)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }

    private func safety(_ text: String) -> some View {
        Label(text, systemImage: "exclamationmark.triangle")
            .font(.system(size: 12)).foregroundStyle(Palette.brown)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func names(_ ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }
}
