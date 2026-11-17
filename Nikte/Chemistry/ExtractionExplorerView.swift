import SwiftUI

struct ExtractionExplorerView: View {
    let extraction: String
    var experience: ExtractionExperience? = nil

    @State private var stage = 0

    private var stages: [(String, String, String)] {
        if let experience {
            let symbols = ["leaf_drying": "leaf", "water_extraction": "drop", "steam_distillation": "cloud", "enteric_release": "pills", "solvent_extraction": "flask", "topical_formulation": "hand.raised"]
            let symbol = symbols[experience.visualType] ?? "leaf"
            return experience.steps.sorted { $0.index < $1.index }.map { ($0.title, $0.detail, symbol) }
        }
        switch extraction {
        case "flowers":
            return [
                ("Flores", "Materia vegetal", "leaf"),
                ("Secado", "Pérdida de agua", "sun.max"),
                ("Conservación", "Mezcla de constituyentes", "archivebox")
            ]

        case "steam":
            return [
                ("Flores + vapor", "Compuestos volátiles", "cloud"),
                ("Calor", "Transformación de precursores", "flame"),
                ("Condensación", "Enfriamiento del vapor", "drop"),
                ("Separación", "Aceite esencial", "flask")
            ]

        case "ethanol":
            return [
                ("Flores", "Materia vegetal", "leaf"),
                ("Agua + etanol", "Polaridad del medio", "drop"),
                ("Extracción", "Disolución de compuestos", "arrow.left.arrow.right"),
                ("Filtrado", "Extracto líquido", "flask")
            ]

        default:
            return [
                ("Flores", "Material de partida", "leaf"),
                ("Agua caliente", "Disolvente polar", "drop"),
                ("Difusión", "Compuestos solubles", "arrow.left.arrow.right"),
                ("Infusión", "Preparación acuosa", "cup.and.saucer")
            ]
        }
    }

    // Evita acceder a índices fuera del arreglo.
    private var safeStage: Int {
        guard !stages.isEmpty else { return 0 }
        return min(max(stage, 0), stages.count - 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(experience.map { $0.isExtraction ? "RUTA DE EXTRACCIÓN" : "RUTA DE PROCESAMIENTO O FORMULACIÓN" } ?? "RUTA DE EXTRACCIÓN")
                .font(.system(size: 11, design: .serif))
                .tracking(2)
                .foregroundStyle(Palette.brown)

            if let experience {
                Text(experience.heading)
                    .font(.system(size: 17, design: .serif)).bold()
                    .foregroundStyle(Palette.olive)
                    .fixedSize(horizontal: false, vertical: true)
                Text(experience.processTitle)
                    .font(.system(size: 14, design: .serif))
                    .foregroundStyle(Palette.brown)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !stages.isEmpty {

                // Indicador de progreso
                HStack(spacing: 5) {
                    ForEach(stages.indices, id: \.self) { index in
                        Capsule()
                            .fill(
                                index <= safeStage
                                    ? Palette.olive
                                    : Palette.sage.opacity(0.35)
                            )
                            .frame(height: 5)
                    }
                }

                // Icono de la etapa actual
                Image(systemName: stages[safeStage].2)
                    .font(.system(size: 39, weight: .ultraLight))
                    .foregroundStyle(Palette.olive)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 7)
                    .accessibilityHidden(true)

                // Nombre de la etapa
                Text(stages[safeStage].0)
                    .font(.system(size: 22, design: .serif))
                    .bold()
                    .foregroundStyle(Palette.olive)
                    .fixedSize(horizontal: false, vertical: true)

                // Descripción
                Text(stages[safeStage].1)
                    .font(.system(size: 14))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)

                // Navegación entre etapas
                HStack {

                    Button("Anterior") {
                        withAnimation {
                            stage = max(0, safeStage - 1)
                        }
                    }
                    .disabled(safeStage == 0)

                    Spacer()

                    Text("\(safeStage + 1) de \(stages.count)")
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(Palette.brown)

                    Spacer()

                    Button(
                        safeStage == stages.count - 1
                            ? "Reiniciar"
                            : "Siguiente"
                    ) {
                        withAnimation {
                            if safeStage == stages.count - 1 {
                                stage = 0
                            } else {
                                stage = min(
                                    safeStage + 1,
                                    stages.count - 1
                                )
                            }
                        }
                    }
                }
                .buttonStyle(.bordered)
                .tint(Palette.olive)

            } else {
                Text("No hay etapas disponibles para esta extracción.")
                    .font(.system(size: 14))
                    .foregroundStyle(Palette.ink)
            }
        }
        .padding(14)
        .background(
            Palette.sage.opacity(0.18),
            in: RoundedRectangle(cornerRadius: 14)
        )

        // Reinicia al cambiar el método de extracción.
        .onChange(of: extraction) { _, _ in
            stage = 0
        }
    }
}
