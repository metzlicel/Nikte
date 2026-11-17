import SwiftUI

struct MintMechanismsView: View {
    let profile: MintProfile
    @State private var selectedMechanism = "intestinal_relaxation"
    @State private var selectedStep = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Selecciona un mecanismo y toca cada etapa para explorarla.")
                .font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
            Picker("Mecanismo molecular", selection: $selectedMechanism) {
                ForEach(profile.section3.items) { item in Text(item.title).tag(item.id) }
            }
            .pickerStyle(.menu).tint(Palette.olive)

            if let mechanism = profile.section3.items.first(where: { $0.id == selectedMechanism }) {
                Text(mechanism.title).font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                QuickFact(label: "Compuestos relacionados", value: names(for: mechanism.compoundIds))
                ForEach(Array(mechanism.steps.enumerated()), id: \.offset) { index, step in
                    if index > 0 {
                        Image(systemName: "arrow.down").foregroundStyle(Palette.olive).frame(maxWidth: .infinity)
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedStep = index }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Text(String(format: "%02d", index + 1))
                                .font(.system(size: 15, design: .serif)).bold()
                                .frame(width: 32, height: 32)
                                .background(Palette.sage.opacity(0.35), in: Circle())
                            VStack(alignment: .leading, spacing: 5) {
                                Text(step.title).font(.system(size: 17, design: .serif)).bold()
                                if selectedStep == index {
                                    Text(step.detail).font(.system(size: 14)).foregroundStyle(Palette.ink)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            Spacer(minLength: 0)
                            Image(systemName: selectedStep == index ? "minus.circle" : "plus.circle")
                        }
                        .foregroundStyle(Palette.olive)
                        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Mostrar detalle de esta etapa")
                }
                if let reaction = mechanism.reaction {
                    ReactionStrip(lhs: "ArOH + R•", rhs: "ArO• + RH", note: reaction.note)
                    QuickFact(label: "Símbolos", value: "ArOH: compuesto fenólico; R•: radical libre; ArO•: radical fenóxico; RH: producto de transferencia de hidrógeno.")
                }
                QuickFact(label: "Explicación científica", value: mechanism.explanation)
                QuickFact(label: "En palabras sencillas", value: mechanism.plainLanguage)
                if let evidence = evidence(for: mechanism.id) {
                    Label(evidence, systemImage: "info.circle")
                        .font(.system(size: 12)).foregroundStyle(Palette.brown)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            let featured = profile.section3.featuredChemistry
            Text(featured.title).font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
            ReactionStrip(lhs: "C₁₀H₁₈O + 2[H]", rhs: "C₁₀H₂₀O", note: featured.reactionClass)
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
            Text(featured.educationalValue).font(.system(size: 12, design: .serif)).foregroundStyle(Palette.brown)
        }
        .onChange(of: selectedMechanism) { _, _ in selectedStep = 0 }
    }

    private func names(for ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }

    private func evidence(for id: String) -> String? {
        let propertyID = ["intestinal_relaxation": "digestive", "trpm8_cooling": "cooling_analgesic", "membrane_antimicrobial": "antimicrobial", "phenolic_antioxidant": "antioxidant"][id]
        return profile.section1.items.first { $0.id == propertyID }?.evidenceContext
    }
}
