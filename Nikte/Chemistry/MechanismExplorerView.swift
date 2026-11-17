import SwiftUI

struct MechanismExplorerView: View {
    @State private var selected = 0
    private let mechanisms: [(title: String, input: String, action: String, result: String, note: String)] = [
        ("Transformación térmica", "Matricina (flor)", "Destilación y calor", "Camazuleno (aceite)", "Transformación química global; no es una ecuación estequiométrica balanceada."),
        ("Señalización inflamatoria", "Apigenina", "Modulación de NF-κB", "Cambios en mediadores", "Interacción bioquímica observada en modelos experimentales; no implica una conversión química de apigenina en NF-κB."),
        ("Actividad antioxidante", "ArOH + R•", "Transferencia de H", "ArO• + RH", "Ecuación genérica de donación de hidrógeno; no demuestra por sí sola un beneficio clínico.")
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("EXPLORADOR DE MECANISMOS")
                .font(.system(size: 11, design: .serif)).tracking(2)
                .foregroundStyle(Palette.brown)
            Picker("Mecanismo", selection: $selected) {
                ForEach(mechanisms.indices, id: \.self) { i in Text(mechanisms[i].title).tag(i) }
            }
            .pickerStyle(.menu)
            .tint(Palette.olive)
            let item = mechanisms[selected]
            VStack(spacing: 8) {
                flowNode(item.input, icon: "leaf")
                Image(systemName: "arrow.down").foregroundStyle(Palette.olive)
                flowNode(item.action, icon: "flame")
                Image(systemName: "arrow.down").foregroundStyle(Palette.olive)
                flowNode(item.result, icon: "atom")
            }
            Text(item.note).font(.system(size: 13)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(13)
        .background(Palette.sage.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
    }

    private func flowNode(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 15, design: .serif)).bold()
            .foregroundStyle(Palette.olive)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(Palette.paper, in: RoundedRectangle(cornerRadius: 9))
            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Palette.brown.opacity(0.32)))
    }
}

