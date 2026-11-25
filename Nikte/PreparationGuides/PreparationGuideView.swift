import SwiftUI

struct PreparationGuideSelectionView: View {
    let requests: [PreparationGuideRequest]

    private var entries: [(guide: PreparationGuide, request: PreparationGuideRequest)]? {
        guard let plantId = requests.first?.plantId,
              let document = try? PreparationGuideDocument.load(forPlantID: plantId) else { return nil }
        return requests.compactMap { request in
            document.guide(for: request).map { (guide: $0, request: request) }
        }
    }

    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(kicker: entries?.first?.guide.plantName.uppercased() ?? "PREPARACIONES", title: "Elige una preparación")
                    if let entries, !entries.isEmpty {
                        ForEach(entries, id: \.guide.id) { guide, request in
                            NavigationLink {
                                PreparationGuideView(request: request)
                            } label: {
                                PaperCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(guide.title).font(.system(size: 18, design: .serif)).bold()
                                            Text(guide.administrationRoute == "oral" ? "Vía oral" : guide.administrationRoute == "bath" ? "Baño · uso externo" : "Uso cutáneo")
                                                .font(.system(size: 13))
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundStyle(Palette.olive)
                                }
                            }.buttonStyle(.plain)
                        }
                    } else {
                        PaperCard { Text("No se pudieron cargar las preparaciones.").foregroundStyle(Palette.ink) }
                    }
                }.padding(20)
            }
        }
        .navigationTitle("Preparaciones")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PreparationGuideView: View {
    let request: PreparationGuideRequest

    private var guide: PreparationGuide? {
        (try? PreparationGuideDocument.load(forPlantID: request.plantId))?.guide(for: request)
    }

    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView {
                if let guide {
                    PreparationGuideContent(guide: guide)
                        .padding(20).padding(.bottom, 45)
                } else {
                    PaperCard {
                        Text("No se pudo cargar la guía de preparación.").foregroundStyle(Palette.ink)
                    }.padding(20)
                }
            }
        }
        .navigationTitle("Guía de preparación")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PreparationGuideContent: View {
    let guide: PreparationGuide
    @State private var selectedChemistryStep = 0

    private var chemistrySymbols: [String] {
        switch guide.plantId {
        case "chamomile":
            guide.preparationId == "infusion"
                ? ["leaf", "bolt", "waveform.path"]
                : ["exclamationmark.circle", "leaf", "waveform.path"]
        case "peppermint": ["exclamationmark.circle", "bolt", "waveform.path"]
        case "zingiber_officinale": ["exclamationmark.circle", "leaf", "waveform.path"]
        case "aloe_vera": ["exclamationmark.circle", "leaf", "waveform.path"]
        case "lavender": ["exclamationmark.circle", "bolt", "waveform.path"]
        case "eucalyptus": ["exclamationmark.circle", "leaf", "waveform.path"]
        case "rosemary": ["exclamationmark.circle", "leaf", "waveform.path"]
        case "turmeric": ["exclamationmark.circle", "leaf", "waveform.path"]
        case "valerian": ["leaf", "bolt", "waveform.path"]
        case "ginseng": ["bolt", "leaf", "waveform.path"]
        default: ["leaf", "drop", "cup.and.saucer"]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageName = guide.imageName {
                Image(imageName)
                    .resizable().scaledToFit().frame(height: 120)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            SectionTitle(kicker: guide.plantName.uppercased(), title: guide.title)
            Text("Malestares documentados")
                .font(.system(size: 13, design: .serif)).foregroundStyle(Palette.brown)
            Text(guide.symptomLabels.joined(separator: " · "))
                .font(.system(size: 17, design: .serif)).foregroundStyle(Palette.olive)
                .fixedSize(horizontal: false, vertical: true)

            PaperCard {
                Text("Ingredientes").font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                ForEach(Array(guide.ingredients.enumerated()), id: \.offset) { _, ingredient in
                    if let amount = ingredient.amount,
                       (guide.plantId == "turmeric" && guide.preparationId == "powdered-rhizome-food") ||
                       (guide.plantId == "ginseng" && amount.count > 40) {
                        VStack(alignment: .leading, spacing: 5) {
                            Label(ingredient.name, systemImage: "leaf").foregroundStyle(Palette.ink)
                            Text(amount).fontWeight(.semibold).foregroundStyle(Palette.olive)
                                .fixedSize(horizontal: false, vertical: true)
                        }.font(.system(size: 14, design: .serif))
                    } else {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "leaf").foregroundStyle(Palette.olive).accessibilityHidden(true)
                        Text(ingredient.name).foregroundStyle(Palette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 8)
                        if let amount = ingredient.amount {
                            Text(amount).fontWeight(.semibold).foregroundStyle(Palette.olive)
                                .multilineTextAlignment(.trailing)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }.font(.system(size: 14, design: .serif))
                    }
                }
            }

            PaperCard {
                Text("Preparación").font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                ForEach(guide.steps.sorted { $0.number < $1.number }) { step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(step.number)").font(.system(size: 14, design: .serif)).bold()
                            .foregroundStyle(Palette.olive).frame(width: 30, height: 30)
                            .background(Palette.sage.opacity(0.4), in: Circle())
                        Text(step.instruction).font(.system(size: 14)).foregroundStyle(Palette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            PaperCard {
                Text("La química detrás").font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                Text(guide.chemistry.explanation).font(.system(size: 14)).foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(["turmeric", "valerian", "ginseng"].contains(guide.plantId) ? 10 : 0)
                    .background(["turmeric", "valerian", "ginseng"].contains(guide.plantId) ? Palette.sage.opacity(0.25) : .clear, in: RoundedRectangle(cornerRadius: 12))
                if guide.plantId == "aloe_vera" {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(guide.preparationId == "commercial-aloe-topical-cream" ? "Crema comercial con aloe · uso tópico" : "Gel interno purificado · uso tópico", systemImage: "drop.fill")
                            .foregroundStyle(Palette.olive)
                        Label("Látex amarillo · no aplicar ni ingerir", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(Palette.brown)
                    }
                    .font(.system(size: 13, design: .serif))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Palette.sage.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                }
                Text(guide.chemistry.title).font(.system(size: 16, design: .serif)).bold().foregroundStyle(Palette.olive)
                ForEach(Array(guide.chemistry.interactiveSteps.enumerated()), id: \.offset) { index, step in
                    if index > 0 {
                        Image(systemName: "arrow.down").foregroundStyle(Palette.olive).frame(maxWidth: .infinity)
                            .accessibilityHidden(true)
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedChemistryStep = index }
                    } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: chemistrySymbols[min(index, chemistrySymbols.count - 1)])
                                .foregroundStyle(Palette.olive).frame(width: 24)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(step.title).font(.system(size: 15, design: .serif)).bold().foregroundStyle(Palette.olive)
                                if selectedChemistryStep == index {
                                    Text(step.description).font(.system(size: 13)).foregroundStyle(Palette.ink)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.sage.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain)
                        .accessibilityHint("Mostrar detalle de esta etapa")
                }
            }

            if guide.display.showSafetyFooter {
                Label {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(guide.targetPopulation.display + ". " + guide.displaySafetyNote)
                        if guide.plantId == "turmeric", guide.preparationId == "powdered-rhizome-food" {
                            Text("No sustituir con suplementos concentrados o con piperina: algunos se han asociado con lesión hepática.")
                        }
                        if guide.medicalReviewStatus == "not_clinically_reviewed" {
                            Text("Guía sin revisión clínica.")
                        }
                    }
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                }
                .font(.system(size: 12)).foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 4)
            }

            if let plant = PlantDetailID(rawValue: guide.plantId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Quieres conocer más sobre esta planta?")
                        .font(.system(size: 17, design: .serif)).bold()
                        .foregroundStyle(Palette.olive)
                        .fixedSize(horizontal: false, vertical: true)
                    NavigationLink {
                        PlantDetailDestination(plant: plant)
                    } label: {
                        HStack(spacing: 8) {
                            Text("Ver ficha técnica")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 15, design: .serif)).bold()
                        .foregroundStyle(Palette.olive)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Palette.sage.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Palette.card, in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Palette.line, lineWidth: 1))
            }
        }
    }
}
