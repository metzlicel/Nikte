import SwiftUI

// MARK: - 13 · PROPIEDADES EN TARJETAS INTERACTIVAS

struct PropertyInfo: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let subtitle: String
    let compound: String
    let action: String
    let observations: [String]
    let caveat: String
}

private let chamomileProperties: [PropertyInfo] = [
    .init(id: "digestiva", title: "Digestiva", symbol: "waveform.path.ecg", subtitle: "Espasmos intestinales", compound: "Flavonoides y otros componentes", action: "Se estudia si pueden modificar la contracción del músculo liso intestinal.", observations: ["Posible participación de señales asociadas al calcio.", "Los resultados experimentales no garantizan alivio clínico de cualquier cólico."], caveat: "Actividad antiespasmódica: evidencia principalmente experimental."),
    .init(id: "inflamacion", title: "Antiinflamatoria", symbol: "flame", subtitle: "Mediadores de inflamación", compound: "Apigenina · α-bisabolol", action: "En modelos de laboratorio pueden modular señales inflamatorias.", observations: ["Se investigan rutas como NF-κB.", "Pueden variar mediadores asociados con COX-2 e iNOS."], caveat: "No implica que una infusión alcance las concentraciones de los ensayos."),
    .init(id: "relajacion", title: "Relajante", symbol: "moon.stars", subtitle: "Señalización nerviosa", compound: "Apigenina", action: "Se investiga su interacción con el sistema de receptores GABA-A.", observations: ["GABA-A participa en la neurotransmisión inhibitoria.", "Interacción molecular no equivale a eficacia comprobada contra el insomnio."], caveat: "No hay que confundir una hipótesis mecanística con un efecto clínico demostrado."),
    .init(id: "antioxidante", title: "Antioxidante", symbol: "sparkles", subtitle: "Reacciones de transferencia", compound: "Flavonoides fenólicos", action: "Sus grupos –OH pueden transferir hidrógeno o electrones en ensayos químicos.", observations: ["Ejemplo general: ArOH + R• → ArO• + RH.", "Un ensayo antioxidante no prueba por sí solo un beneficio en el organismo."], caveat: "La reacción mostrada es ilustrativa, no específica de una dosis de manzanilla.")
]

struct PropertyCard: View {
    let property: PropertyInfo
    @State private var isOpen = false
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) { isOpen.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: property.symbol)
                        .font(.system(size: 23))
                        .frame(width: 43, height: 43)
                        .foregroundStyle(Palette.olive)
                        .background(Palette.sage.opacity(0.22), in: RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(property.title)
                            .font(.system(size: 21, design: .serif)).bold()
                        Text(property.subtitle)
                            .font(.system(size: 12))
                    }
                    Spacer(minLength: 4)
                    Image(systemName: isOpen ? "minus.circle" : "plus.circle")
                        .font(.system(size: 20))
                }
                .foregroundStyle(Palette.olive)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(isOpen ? "Ocultar mecanismo" : "Mostrar mecanismo y compuestos")
            if isOpen {
                Rectangle().fill(Palette.sage.opacity(0.8)).frame(height: 1)
                Text("¿CÓMO PODRÍA ACTUAR?")
                    .font(.system(size: 11, design: .serif)).tracking(1.5)
                    .foregroundStyle(Palette.brown)
                Text(property.action)
                    .font(.system(size: 15))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
                QuickFact(label: "Compuestos relacionados", value: property.compound)
                BulletFacts(items: property.observations)
                HStack(alignment: .top, spacing: 7) {
                    Image(systemName: "info.circle")
                    Text(property.caveat)
                }
                .font(.system(size: 12))
                .foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Palette.card.opacity(0.85), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Palette.sage.opacity(0.75), lineWidth: 1))
    }
}

struct PropertyGallery: View {
    let items: [PropertyInfo]

    init(items: [PropertyInfo]? = nil) {
        self.items = items ?? chamomileProperties
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items) { item in
                PropertyCard(property: item)
            }
        }
    }
}
