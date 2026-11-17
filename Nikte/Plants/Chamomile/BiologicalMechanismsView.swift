import SwiftUI

// MARK: - 16 · DIAGRAMAS DE REACCIONES

struct ReactionStrip: View {
    let lhs: String
    let rhs: String
    let note: String
    var body: some View {
        VStack(spacing: 7) {
            HStack(spacing: 8) {
                Text(lhs)
                Image(systemName: "arrow.right")
                Text(rhs)
            }
            .font(.system(size: 14, design: .serif)).bold()
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            Text(note).font(.system(size: 11)).multilineTextAlignment(.center)
        }
        .foregroundStyle(Palette.olive)
        .frame(maxWidth: .infinity)
        .padding(13)
        .background(Palette.sage.opacity(0.23), in: RoundedRectangle(cornerRadius: 12))
    }
}


// MARK: - EXPLORADOR DE MECANISMOS BIOQUÍMICOS

struct BiologicalMechanismsView: View {

    @State private var selectedMechanism = "inflammation"

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Selecciona una propiedad para descubrir cómo actúan sus compuestos.")
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(Palette.brown)

            // MARK: - Dropdown de mecanismos

            Picker("Mecanismo molecular", selection: $selectedMechanism) {

                Text("Antiinflamatorio")
                    .tag("inflammation")

                Text("Relajante")
                    .tag("relaxation")

                Text("Digestivo y antiespasmódico")
                    .tag("digestive")

                Text("Antioxidante")
                    .tag("antioxidant")
            }
            .pickerStyle(.menu)
            .tint(Palette.olive)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Palette.sage.opacity(0.20),
                in: RoundedRectangle(cornerRadius: 14)
            )

            // MARK: - Contenido según selección

            switch selectedMechanism {

            case "inflammation":
                antiInflammatoryView

            case "relaxation":
                relaxationView

            case "digestive":
                digestiveView

            case "antioxidant":
                antioxidantView

            default:
                EmptyView()
            }
        }
    }

    // MARK: - A · MECANISMO ANTIINFLAMATORIO

    private var antiInflammatoryView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo antiinflamatorio",
                symbol: "flame"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "α-Bisabolol, apigenina y otros constituyentes del extracto."
            )

            Text("Ruta molecular simplificada")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Estímulo inflamatorio",
                detail: "Activa señales intracelulares."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Activación de NF-κB",
                detail: "Regula genes asociados con inflamación."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Modulación por fitoquímicos",
                detail: "α-Bisabolol y extractos pueden reducir la activación de esta vía en modelos experimentales."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Menor expresión de mediadores",
                detail: "Cambios observados en COX-2, iNOS y ciertas citocinas."
            )

            explanation(
                "Algunas moléculas de la manzanilla pueden disminuir señales celulares que favorecen la inflamación."
            )

            evidenceNote(
                "Resultados observados principalmente en modelos celulares y animales."
            )
        }
    }

    // MARK: - B · MECANISMO RELAJANTE

    private var relaxationView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo relajante",
                symbol: "moon.stars"
            )

            QuickFact(
                label: "Compuesto relacionado",
                value: "Apigenina"
            )

            Text("Interacción con el sistema GABA-A")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Apigenina",
                detail: "Flavonoide presente en la manzanilla."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Interacción con GABA-A",
                detail: "Se ha investigado su unión a un sitio asociado a receptores GABA-A."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Posible modulación neuronal",
                detail: "GABA-A participa en la inhibición de la actividad neuronal mediante canales de Cl⁻."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Actividad relajante propuesta",
                detail: "Mecanismo investigado para posibles efectos ansiolíticos."
            )

            explanation(
                "La apigenina puede interactuar con proteínas neuronales relacionadas con la regulación de la excitabilidad del sistema nervioso."
            )

            evidenceNote(
                "No debe interpretarse que la apigenina abre directamente el canal GABA-A ni que actúa igual que una benzodiacepina."
            )
        }
    }

    // MARK: - C · MECANISMO DIGESTIVO

    private var digestiveView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo digestivo y antiespasmódico",
                symbol: "waveform.path.ecg"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "Flavonoides, como la apigenina, y componentes del aceite esencial."
            )

            Text("Modelo fisiológico simplificado")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Aumento de Ca²⁺ intracelular",
                detail: "El calcio participa en la regulación de la contracción muscular."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Contracción del músculo liso",
                detail: "Participa en los movimientos del sistema digestivo."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Posible modulación",
                detail: "Algunos fitoquímicos pueden modificar estas rutas en modelos experimentales."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Relajación muscular",
                detail: "Actividad antiespasmódica estudiada experimentalmente."
            )

            explanation(
                "Algunos compuestos de la manzanilla podrían modificar mecanismos que regulan las contracciones musculares del sistema digestivo."
            )

            evidenceNote(
                "No está demostrado que la apigenina bloquee directamente los canales de calcio del intestino humano."
            )
        }
    }

    // MARK: - D · MECANISMO ANTIOXIDANTE

    private var antioxidantView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo antioxidante",
                symbol: "sparkles"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "Apigenina y otros flavonoides fenólicos."
            )

            Text("Transferencia de hidrógeno")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            ReactionStrip(
                lhs: "ArOH + R•",
                rhs: "ArO• + RH",
                note: "Reacción general de transferencia de hidrógeno"
            )

            Text("¿Qué representa cada símbolo?")
                .font(.system(size: 17, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            QuickFact(
                label: "ArOH",
                value: "Compuesto fenólico."
            )

            QuickFact(
                label: "R•",
                value: "Radical libre."
            )

            QuickFact(
                label: "ArO•",
                value: "Radical fenóxico que puede estabilizarse por resonancia."
            )

            QuickFact(
                label: "RH",
                value: "Producto de la transferencia de hidrógeno."
            )

            explanation(
                "Los grupos fenólicos de algunos flavonoides pueden participar en reacciones de oxidación-reducción y estabilizar radicales."
            )

            evidenceNote(
                "La actividad antioxidante experimental no demuestra que beber manzanilla reduzca el daño oxidativo en humanos."
            )
        }
    }

    // MARK: - COMPONENTES VISUALES COMPARTIDOS

    private func mechanismTitle(
        _ title: String,
        symbol: String
    ) -> some View {

        HStack(spacing: 10) {

            Image(systemName: symbol)
                .font(.system(size: 25))
                .foregroundStyle(Palette.olive)
                .frame(width: 42, height: 42)
                .background(
                    Palette.sage.opacity(0.25),
                    in: RoundedRectangle(cornerRadius: 12)
                )

            Text(title)
                .font(.system(size: 21, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)
        }
    }

    private func pathwayStep(
        number: String,
        title: String,
        detail: String
    ) -> some View {

        HStack(alignment: .top, spacing: 12) {

            Text(number)
                .font(.system(size: 15, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)
                .frame(width: 32, height: 32)
                .background(
                    Palette.sage.opacity(0.35),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(.system(size: 17, design: .serif))
                    .bold()
                    .foregroundStyle(Palette.olive)

                Text(detail)
                    .font(.system(size: 14))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.sage.opacity(0.16),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }

    private func pathwayArrow() -> some View {

        Image(systemName: "arrow.down")
            .font(.system(size: 18))
            .foregroundStyle(Palette.olive)
            .frame(maxWidth: .infinity)
    }

    private func explanation(_ text: String) -> some View {

        VStack(alignment: .leading, spacing: 7) {

            Label(
                "En palabras sencillas",
                systemImage: "lightbulb"
            )
            .font(.system(size: 16, design: .serif))
            .bold()
            .foregroundStyle(Palette.olive)

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Palette.ink)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.sage.opacity(0.22),
            in: RoundedRectangle(cornerRadius: 14)
        )
    }

    private func evidenceNote(_ text: String) -> some View {

        HStack(alignment: .top, spacing: 8) {

            Image(systemName: "info.circle")
                .foregroundStyle(Palette.brown)

            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 5)
    }
}
