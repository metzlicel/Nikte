import SwiftUI

struct LavenderDetailView: View {
    private let document = try? LavenderDocument.load()

    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView {
                if let profile = document?.plant {
                    LavenderProfileView(profile: profile).padding(20).padding(.bottom, 45)
                } else {
                    PaperCard {
                        Text("No se pudo cargar la ficha de lavanda.").foregroundStyle(Palette.ink)
                    }.padding(20)
                }
            }
        }
        .navigationTitle("Ficha de lavanda")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LavenderProfileView: View {
    let profile: MintProfile
    @State private var selectedCompound = "linalool"
    @State private var selectedPreparation = "dried_flowers"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Image("frame").resizable().scaledToFit().frame(height: 220)
                Image("lavanda_ilustracion").resizable().scaledToFit().frame(height: 110).offset(y: 12)
            }.frame(maxWidth: .infinity, alignment: .center).padding(.top, 5)
            SectionTitle(kicker: "FICHA BOTÁNICA · 005", title: profile.commonName)
            Text("\(profile.scientificName) · \(profile.family)")
                .font(.system(size: 17, design: .serif)).italic().foregroundStyle(Palette.brown)
            Text("Partes estudiadas: \(profile.usedParts.joined(separator: "; ")).")
                .foregroundStyle(Palette.ink).fixedSize(horizontal: false, vertical: true)
            Text(profile.summary).font(.system(size: 14)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)

            ExpandableCard(title: "01 · Propiedades", subtitle: profile.section1.title) {
                Text("Toca una propiedad para explorar su química")
                    .font(.system(size: 14, design: .serif)).italic().foregroundStyle(Palette.brown)
                ForEach(profile.section1.items) { property in
                    PropertyCard(property: propertyInfo(property))
                }
            }

            ExpandableCard(title: "02 · Composición química", subtitle: profile.section2.title) {
                Picker("Compuesto", selection: $selectedCompound) {
                    ForEach(profile.section2.items) { Text($0.name).tag($0.id) }
                }.tint(Palette.olive).pickerStyle(.menu)
                if let item = profile.section2.items.first(where: { $0.id == selectedCompound }) {
                    Text(item.name).font(.system(size: 22, design: .serif)).bold().foregroundStyle(Palette.olive)
                    FactChip(text: item.molecularFormula, symbol: "atom")
                    QuickFact(label: "Familia química", value: item.chemicalClass)
                    PlantMoleculeView(compound: item, imagePrefix: "lavender", cid: LavenderDocument.structureCID(for: item))
                    QuickFact(label: "Descripción", value: item.description)
                    QuickFact(label: "Distribución", value: item.distribution)
                }
            }

            ExpandableCard(title: "03 · Reacciones y mecanismos", subtitle: profile.section3.title) {
                LavenderMechanismsView(profile: profile)
                LavenderHydrolysisView(profile: profile)
            }

            ExpandableCard(title: "04 · Extracciones", subtitle: profile.section4.title) {
                Picker("Presentación", selection: $selectedPreparation) {
                    ForEach(profile.section4.items) { Text($0.title).tag($0.id) }
                }.tint(Palette.olive).pickerStyle(.menu)
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
                        Text(preparation.title).font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                        QuickFact(label: "Compuestos destacados", value: names(preparation.highlightCompoundIds))
                    }
                    if let warning = preparation.warning {
                        Label(warning, systemImage: "info.circle").font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
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
        let symbols = ["anxiety": "brain", "stress": "leaf", "sleep": "moon.stars", "pain": "waveform.path.ecg", "antioxidant": "sparkles"]
        let preparations = property.relatedPreparationIds.compactMap { id in
            profile.section4.items.first { $0.id == id }?.title
        }.joined(separator: " · ")
        return PropertyInfo(id: property.id, title: property.title, symbol: symbols[property.id] ?? "leaf",
                            subtitle: "Actividad investigada", compound: names(property.relatedCompoundIds),
                            action: property.description, observations: ["Preparaciones relacionadas: \(preparations)."],
                            caveat: property.evidenceContext)
    }
}
