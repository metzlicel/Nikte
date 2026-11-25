import SwiftUI

struct ValerianDetailView: View {
    private let document = try? ValerianDocument.load()

    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView {
                if let profile = document?.plant {
                    ValerianProfileView(profile: profile).padding(20).padding(.bottom, 45)
                } else {
                    PaperCard {
                        Text("No se pudo cargar la ficha de valeriana.").foregroundStyle(Palette.ink)
                    }.padding(20)
                }
            }
        }
        .navigationTitle("Ficha de valeriana")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ValerianProfileView: View {
    let profile: RosemaryProfile
    @State private var selectedCompound = "valerenic_acid"
    @State private var selectedPreparation = "fresh_root"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Image("frame").resizable().scaledToFit().frame(height: 220)
                Image("valeriana_ilustracion").resizable().scaledToFit().frame(height: 110).offset(y: 12)
            }.frame(maxWidth: .infinity, alignment: .center).padding(.top, 5)
            SectionTitle(kicker: "FICHA BOTÁNICA · 009", title: profile.commonName)
            Text("\(profile.scientificName) · \(profile.family)")
                .font(.system(size: 17, design: .serif)).italic().foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
            Text("Partes estudiadas: \(profile.usedParts.joined(separator: "; ")).")
                .foregroundStyle(Palette.ink).fixedSize(horizontal: false, vertical: true)
            Text(profile.summary).font(.system(size: 14)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)

            ExpandableCard(title: "01 · Propiedades", subtitle: "Actividad investigada y uso tradicional") {
                PropertyGallery(items: profile.section1.items.map { propertyInfo($0) })
            }

            ExpandableCard(title: "02 · Composición química", subtitle: "Conoce los compuestos") {
                MechanismPicker(options: profile.section2.items.map { (id: $0.id, title: $0.name) }, selection: $selectedCompound, label: "Compuesto")
                if let item = profile.section2.items.first(where: { $0.id == selectedCompound }) {
                    FactChip(text: item.molecularFormula, symbol: "atom")
                    QuickFact(label: "Familia química", value: item.chemicalClass)
                    PlantMoleculeView(compound: item, imagePrefix: "valerian", cid: item.pubchemCID)
                    QuickFact(label: "Descripción", value: item.description)
                    QuickFact(label: "Distribución", value: item.distribution)
                }
            }

            ExpandableCard(title: "03 · Reacciones y mecanismos", subtitle: "Actividad molecular investigada") {
                LavenderMechanismsView(profile: profile.mechanismProfile, initialMechanism: "gaba_a")
            }

            ExpandableCard(title: "04 · Extracciones", subtitle: "Procesos y presentaciones") {
                MechanismPicker(options: profile.section4.items.map { (id: $0.id, title: $0.title) }, selection: $selectedPreparation, label: "Presentación")
                if let preparation = profile.section4.items.first(where: { $0.id == selectedPreparation }) {
                    QuickFact(label: "Método", value: preparation.extractionMethod)
                    Text(preparation.description).font(.system(size: 14)).foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    if let experience = preparation.extractionExperience {
                        ExtractionExplorerView(extraction: preparation.id, experience: experience)
                        ExtractionComparison(extraction: preparation.id, data: ExtractionComparisonData(
                            title: preparation.title,
                            characteristics: preparation.highlightCompoundIds.compactMap { id in
                                profile.section2.items.first { $0.id == id }?.name
                            },
                            chemistry: experience.chemicalPrinciples.joined(separator: " · ")
                        ))
                        QuickFact(label: "Compuestos de interés", value: names(experience.focusCompoundIds))
                        QuickFact(label: "Comparación", value: experience.comparisonNote)
                    } else {
                        QuickFact(label: "Compuestos destacados", value: names(preparation.highlightCompoundIds))
                    }
                    if let warning = preparation.warning {
                        Label(warning, systemImage: "info.circle").font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                ValerianComparisonView(profile: profile)
            }
            PaperCard {
                Text("Nota de seguridad").font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
                Text(profile.safetyNote).font(.system(size: 14)).foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func names(_ ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }

    private func propertyInfo(_ property: MintProperty) -> PropertyInfo {
        let symbols = ["mild_tension": "leaf", "sleep": "moon.stars", "gaba": "brain", "aroma": "wind"]
        let preparations = property.relatedPreparationIds.compactMap { id in
            profile.section4.items.first { $0.id == id }?.title
        }.joined(separator: " · ")
        return PropertyInfo(id: property.id, title: property.title, symbol: symbols[property.id] ?? "leaf",
                            subtitle: "Actividad investigada", compound: names(property.relatedCompoundIds),
                            action: property.description, observations: ["Preparaciones relacionadas: \(preparations)."],
                            caveat: property.evidenceContext)
    }
}
