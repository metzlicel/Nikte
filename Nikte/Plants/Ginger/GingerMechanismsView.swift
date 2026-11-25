import SwiftUI

struct GingerMechanismsView: View {
    let profile: MintProfile
    @State private var selectedMechanism = "nausea_5ht3"
    @State private var selectedStep = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            MechanismPicker(options: profile.section3.items.map { (id: $0.id, title: $0.title) }, selection: $selectedMechanism)

            if let mechanism = profile.section3.items.first(where: { $0.id == selectedMechanism }) {
                QuickFact(label: "Compuestos relacionados", value: names(mechanism.compoundIds))
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
                    QuickFact(label: "Símbolos", value: "ArOH: molécula con grupo fenólico; R•: radical libre; ArO•: radical fenóxico que puede estabilizarse por resonancia; RH: especie que recibió hidrógeno.")
                }
                QuickFact(label: "Explicación científica", value: mechanism.explanation)
                PlainLanguageCard(text: mechanism.plainLanguage)
            }
        }
        .onChange(of: selectedMechanism) { _, _ in selectedStep = 0 }
    }

    private func names(_ ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }
}

struct GingerTransformationView: View {
    let featured: MintFeaturedChemistry
    @State private var selected = "gingerol"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(featured.title).font(.system(size: 20, design: .serif)).bold().foregroundStyle(Palette.olive)
            Text("Compara las estructuras antes y después de la transformación.")
                .font(.system(size: 14, design: .serif)).foregroundStyle(Palette.brown)
            Picker("Estructura", selection: $selected) {
                Text("6-Gingerol").tag("gingerol")
                Text("6-Shogaol").tag("shogaol")
            }.pickerStyle(.segmented)
            Image(selected == "gingerol" ? "ginger_6_gingerol" : "ginger_6_shogaol")
                .resizable().interpolation(.high).scaledToFit()
                .frame(maxWidth: .infinity).frame(height: 200)
                .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
                .accessibilityLabel(selected == "gingerol" ? "Estructura de 6-gingerol, PubChem CID 442793" : "Estructura de 6-shogaol, PubChem CID 5281794")
            QuickFact(label: selected == "gingerol" ? "Antes · 6-Gingerol" : "Después · 6-Shogaol",
                      value: selected == "gingerol"
                      ? "β-hidroxicetona con alcohol secundario y cetona; frecuente en el rizoma fresco."
                      : "Cetona α,β-insaturada: se forma un doble enlace C=C conjugado con el carbonilo tras la pérdida de agua.")
            ReactionStrip(lhs: "C₁₇H₂₆O₄", rhs: "C₁₇H₂₄O₃ + H₂O", note: featured.reactionClass)
            Text(featured.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(featured.educationalValue).font(.system(size: 12, design: .serif)).foregroundStyle(Palette.brown)
        }
        .padding(14).background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 14))
    }
}
