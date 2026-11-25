import SwiftUI

struct MintMechanismsView: View {
    let profile: MintProfile
    @State private var selectedMechanism = "intestinal_relaxation"
    @State private var selectedStep = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            MechanismPicker(options: profile.section3.items.map { (id: $0.id, title: $0.title) }, selection: $selectedMechanism)

            if let mechanism = profile.section3.items.first(where: { $0.id == selectedMechanism }) {
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
                PlainLanguageCard(text: mechanism.plainLanguage)
            }
        }
        .onChange(of: selectedMechanism) { _, _ in selectedStep = 0 }
    }

    private func names(for ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }

}
