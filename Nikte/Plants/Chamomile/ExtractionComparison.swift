import SwiftUI

// MARK: - 14 · COMPARACIÓN DE EXTRACCIONES

struct ExtractionComparison: View {
    let extraction: String
    var data: ExtractionComparisonData? = nil
    private var contents: (title: String, characteristics: [String], chemistry: String) {
        if let data {
            return (data.title, data.characteristics, data.chemistry)
        }
        switch extraction {
        case "flowers":
            return ("Flores secas", ["Flavonoides y sus glucósidos", "Constituyentes del aceite esencial", "Cambios posibles durante el secado"], "Deshidratación y conservación; no constituye una extracción selectiva.")
        case "steam":
            return ("Aceite esencial", ["Constituyentes relativamente volátiles", "α-Bisabolol", "Camazuleno puede formarse por calor"], "Volatilidad, condensación y separación de fases.")
        case "ethanol":
            return ("Extracto hidroalcohólico", ["Flavonoides con distintas polaridades", "Perfil variable según proporción agua/etanol", "Disolución y filtrado"], "La mezcla de solventes modifica la solubilidad de los compuestos.")
        default:
            return ("Infusión acuosa", ["Compuestos relativamente polares", "Glucósidos como apigenina-7-O-glucósido", "Perfil distinto al aceite esencial"], "El agua caliente facilita disolución y difusión.")
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("QUÉ CONTIENE O FAVORECE")
                .font(.system(size: 11, design: .serif)).tracking(1.3)
                .foregroundStyle(Palette.brown)
            BulletFacts(items: contents.characteristics)
            QuickFact(label: "Principio químico", value: contents.chemistry)
        }
    }
}

struct ExtractionComparisonData {
    let title: String
    let characteristics: [String]
    let chemistry: String
}
