import SwiftUI

// Diagramas para divulgación: cada marca permite explorar un grupo funcional.
// Los PNG de las moléculas son estructuras 2D dibujadas con RDKit.
private struct AtomPoint: Identifiable {
    let id: String
    let x: CGFloat
    let y: CGFloat
    let explanation: String
}

private struct MoleculeDrawing {
    let image: String
    let annotations: [AtomPoint]
}

private let drawings: [String: MoleculeDrawing] = [
    "apigenin": MoleculeDrawing(image: "apigenin", annotations: [
        AtomPoint(id: "Carbonilo", x: 0.661, y: 0.809, explanation: "El grupo C=O (carbonilo) forma parte de la estructura de la flavona. Contribuye a su distribución electrónica y a sus interacciones intermoleculares."),
        AtomPoint(id: "Hidroxilo fenólico", x: 0.277, y: 0.587, explanation: "Los grupos –OH fenólicos pueden donar enlaces de hidrógeno y participar en transferencias de H en ensayos de actividad antioxidante."),
        AtomPoint(id: "Anillo aromático", x: 0.386, y: 0.347, explanation: "El sistema aromático conjugado de la flavona influye en su absorción de luz y en las interacciones de la molécula con otras estructuras.")
    ]),
    "glucoside": MoleculeDrawing(image: "glucoside", annotations: [
        AtomPoint(id: "Enlace O-glucosídico", x: 0.523, y: 0.414, explanation: "El enlace de oxígeno conecta la unidad de glucosa con la apigenina. Su ruptura por hidrólisis puede liberar la aglicona."),
        AtomPoint(id: "Unidad de glucosa", x: 0.695, y: 0.517, explanation: "La glucosa incorpora varios grupos –OH y modifica la polaridad frente a la apigenina no glucosilada."),
        AtomPoint(id: "Carbonilo", x: 0.454, y: 0.753, explanation: "La región carbonilo de la flavona permanece en la estructura después de la glucosilación.")
    ]),
    "bisabolol": MoleculeDrawing(image: "bisabolol", annotations: [
        AtomPoint(id: "Grupo alcohol", x: 0.568, y: 0.255, explanation: "El –OH caracteriza al α-bisabolol como alcohol sesquiterpénico, aunque el resto de su estructura es mayormente apolar."),
        AtomPoint(id: "Doble enlace", x: 0.291, y: 0.386, explanation: "Los enlaces C=C pertenecen al esqueleto insaturado del terpeno."),
        AtomPoint(id: "Cadena terpénica", x: 0.710, y: 0.653, explanation: "La porción hidrocarbonada favorece la afinidad por fases lipofílicas y ayuda a explicar su presencia en el aceite esencial.")
    ])
]

struct MolecularDiagramView: View {
    let compoundID: String
    @State private var selected: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ATLAS MOLECULAR INTERACTIVO")
                .font(.system(size: 11, design: .serif)).tracking(2)
                .foregroundStyle(Palette.brown)
            if let drawing = drawings[compoundID] {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    ZStack(alignment: .topLeading) {
                        Image(drawing.image)
                            .resizable()
                            .interpolation(.high)
                            .scaledToFit()
                            .frame(width: width, height: height)
                            .background(Color.white)
                            .accessibilityLabel("Diagrama estructural de \(compoundID)")

                        ForEach(drawing.annotations) { atom in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selected = atom.id
                                }
                            } label: {
                                Circle()
                                    .fill(selected == atom.id ? Palette.olive.opacity(0.42) : Palette.sage.opacity(0.32))
                                    .frame(width: 32, height: 32)
                                    .overlay(Circle().stroke(Palette.olive, lineWidth: selected == atom.id ? 2.5 : 1.2))
                                    .overlay(Image(systemName: "plus").font(.system(size: 10, weight: .bold)).foregroundStyle(Palette.olive))
                            }
                            .buttonStyle(.plain)
                            .position(x: width * atom.x, y: height * atom.y)
                            .accessibilityLabel("Explorar \(atom.id)")
                        }
                    }
                    .frame(width: width, height: height)
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14))
               
                if let active = drawing.annotations.first(where: { $0.id == selected }) {
                    info(active.id, active.explanation)
                } else {
                    info("Selecciona un punto", "Cada marcador señala una región de interés de la molécula.")
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        ForEach(drawing.annotations) { atom in
                            Button(atom.id) { withAnimation { selected = atom.id } }
                                .font(.system(size: 12, design: .serif))
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .foregroundStyle(selected == atom.id ? Palette.paper : Palette.olive)
                                .background(selected == atom.id ? Palette.olive : Palette.sage.opacity(0.28), in: Capsule())
                        }
                    }
                }
            } else {
                info("Esquema de transformación", compoundID == "matricin"
                     ? "La matricina es un precursor presente en las flores. Durante la destilación puede transformarse en camazuleno. Se muestra el proceso químico en la sección 03; no se presenta aquí una estructura molecular sin validarla."
                     : "El camazuleno puede formarse durante la destilación. Su aparición no implica que la misma cantidad esté presente en la flor o en una infusión. Consulta el diagrama de reacción en la sección 03.")
            }
        }
        .onChange(of: compoundID) { _, _ in selected = nil }
    }

    private func info(_ name: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name).font(.system(size: 16, design: .serif)).bold()
            Text(detail).font(.system(size: 13)).fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(Palette.ink)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Palette.sage.opacity(0.19), in: RoundedRectangle(cornerRadius: 12))
    }
}

