import SwiftUI

struct LavenderMechanismsView: View {
    let profile: MintProfile
    @State private var selectedMechanism: String
    @State private var selectedStep = 0

    init(profile: MintProfile, initialMechanism: String = "calcium_channels") {
        self.profile = profile
        _selectedMechanism = State(initialValue: initialMechanism)
    }

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
                if let reaction = mechanism.reaction {
                    ReactionStrip(lhs: "ArOH + R•", rhs: "ArO• + RH", note: reaction.note)
                }
                QuickFact(label: "Explicación científica", value: mechanism.explanation)
                PlainLanguageCard(text: mechanism.plainLanguage)
            }
        }.onChange(of: selectedMechanism) { _, _ in selectedStep = 0 }
    }
}

struct LavenderHydrolysisView: View {
    let profile: MintProfile
    @State private var selected = "linalyl_acetate"

    var body: some View {
        let featured = profile.section3.featuredChemistry
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)
            Text("Compara los grupos funcionales y las estructuras.")
                .font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
            Picker("Estructura", selection: $selected) {
                Text("Éster").tag("linalyl_acetate")
                Text("Alcohol").tag("linalool")
            }.pickerStyle(.segmented)
            if let item = profile.section2.items.first(where: { $0.id == selected }) {
                Text(item.name).font(.system(size: 18, design: .serif)).bold().foregroundStyle(Palette.olive)
                Image("lavender_\(item.id)").resizable().interpolation(.high).scaledToFit()
                    .frame(maxWidth: .infinity).frame(height: 190)
                    .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityLabel("Estructura de \(item.name), PubChem CID \(item.pubchemCID ?? 0)")
                QuickFact(label: item.chemicalClass, value: item.functionalGroups.joined(separator: " · "))
                Text(item.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            ReactionStrip(lhs: "C₁₂H₂₀O₂ + H₂O", rhs: "C₁₀H₁₈O + CH₃COOH", note: featured.reactionClass)
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.educationalValue).font(.system(size: 12, design: .serif)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }
}
