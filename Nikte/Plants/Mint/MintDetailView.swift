import SwiftUI

struct MintDetailView: View {
    private let document = try? MintDocument.load()

    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView {
                if let profile = document?.plant {
                    MintProfileView(profile: profile)
                        .padding(20)
                        .padding(.bottom, 45)
                } else {
                    PaperCard {
                        Text("No se pudo cargar la ficha de menta.")
                            .foregroundStyle(Palette.ink)
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Ficha de menta")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MintProfileView: View {
    let profile: MintProfile
    @State private var selectedCompound = "menthol"
    @State private var selectedPreparation = "leaves"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Image("frame")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                Image("menta_ilustracion")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 110)
                    .offset(y: 12)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 5)
            SectionTitle(kicker: "FICHA BOTÁNICA · 002", title: profile.commonName)
            Text("\(profile.scientificName) · \(profile.family)")
                .font(.system(size: 17, design: .serif)).italic().foregroundStyle(Palette.brown)
            Text("Partes estudiadas: \(profile.usedParts.joined(separator: ", ")).")
                .foregroundStyle(Palette.ink)
            Text(profile.summary)
                .font(.system(size: 14)).foregroundStyle(Palette.ink)

            ExpandableCard(title: "01 · Propiedades", subtitle: profile.section1.title) {
                Text("Toca una propiedad para explorar su química")
                    .font(.system(size: 14, design: .serif)).italic().foregroundStyle(Palette.brown)
                ForEach(profile.section1.items) { property in
                    PropertyCard(property: propertyInfo(property))
                }
            }

            ExpandableCard(title: "02 · Composición química", subtitle: profile.section2.title) {
                Picker("Compuesto", selection: $selectedCompound) {
                    ForEach(profile.section2.items) { item in Text(item.name).tag(item.id) }
                }.tint(Palette.olive).pickerStyle(.menu)
                if let item = profile.section2.items.first(where: { $0.id == selectedCompound }) {
                    let compound = item.compound
                    Text(compound.name).font(.system(size: 22, design: .serif)).bold().foregroundStyle(Palette.olive)
                    FactChip(text: compound.formula, symbol: "atom")
                    QuickFact(label: "Familia química", value: compound.family)
                    PlantMoleculeView(compound: item, imagePrefix: "mint", cid: item.structureCID)
                    QuickFact(label: "Actividad investigada", value: compound.mechanism)
                    QuickFact(label: "Distribución", value: compound.extraction)
                }
            }

            ExpandableCard(title: "03 · Reacciones y mecanismos", subtitle: profile.section3.title) {
                MintMechanismsView(profile: profile)
            }

            ExpandableCard(title: "04 · Extracciones", subtitle: profile.section4.title) {
                Picker("Presentación", selection: $selectedPreparation) {
                    ForEach(profile.section4.items) { item in Text(item.title).tag(item.id) }
                }.tint(Palette.olive).pickerStyle(.menu)
                if let preparation = profile.section4.items.first(where: { $0.id == selectedPreparation }) {
                    QuickFact(label: "Método", value: preparation.extractionMethod)
                    Text(preparation.description).font(.system(size: 14)).foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    if let experience = preparation.extractionExperience {
                        ExtractionExplorerView(extraction: preparation.id, experience: experience)
                        ExtractionComparison(
                            extraction: preparation.id,
                            data: ExtractionComparisonData(
                                title: preparation.title,
                                characteristics: preparation.highlightCompoundIds.compactMap { id in
                                    profile.section2.items.first { $0.id == id }?.name
                                },
                                chemistry: experience.chemicalPrinciples.joined(separator: " · ")
                            )
                        )
                        QuickFact(label: "Compuestos de interés", value: names(for: experience.focusCompoundIds))
                        QuickFact(label: "Comparación", value: experience.comparisonNote)
                    } else {
                        Text(preparation.title).font(.system(size: 21, design: .serif)).bold().foregroundStyle(Palette.olive)
                        QuickFact(label: "Compuestos destacados", value: names(for: preparation.highlightCompoundIds))
                    }
                    if let warning = preparation.warning {
                        Label(warning, systemImage: "info.circle")
                            .font(.system(size: 12)).foregroundStyle(Palette.brown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            PaperCard {
                Text("Nota de seguridad").font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
                Text(profile.safetyNote).font(.system(size: 14)).foregroundStyle(Palette.ink)
            }
        }
    }

    private func names(for ids: [String]) -> String {
        ids.compactMap { id in profile.section2.items.first { $0.id == id }?.name }.joined(separator: " · ")
    }

    private func propertyInfo(_ property: MintProperty) -> PropertyInfo {
        let symbols = ["digestive": "waveform.path.ecg", "cooling_analgesic": "snowflake", "antimicrobial": "shield", "antioxidant": "sparkles"]
        return PropertyInfo(id: property.id, title: property.title, symbol: symbols[property.id] ?? "leaf",
                            subtitle: "Actividad investigada", compound: names(for: property.relatedCompoundIds),
                            action: property.description, observations: [], caveat: property.evidenceContext)
    }
}

struct PlantMoleculeView: View {
    let compound: MintCompound
    let imagePrefix: String
    let cid: Int?
    @State private var selectedGroup: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ATLAS MOLECULAR").font(.system(size: 11, design: .serif)).tracking(2).foregroundStyle(Palette.brown)
            if let cid {
                Image("\(imagePrefix)_\(compound.id)")
                    .resizable().interpolation(.high).scaledToFit()
                    .frame(maxWidth: .infinity).frame(height: 220)
                    .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityLabel("Estructura molecular de \(compound.name), PubChem CID \(cid)")
                Text("Estructura 2D: PubChem CID \(cid). La representación corresponde al registro indicado; no necesariamente muestra todos los estereoisómeros presentes en la planta.")
                    .font(.system(size: 11)).foregroundStyle(Palette.brown)
            } else {
                Text("Estructura no disponible.").font(.system(size: 13)).foregroundStyle(Palette.brown)
            }
            Text("Grupos funcionales: selecciona uno para consultar la descripción de la molécula.")
                .font(.system(size: 13)).foregroundStyle(Palette.ink)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(compound.functionalGroups, id: \.self) { group in
                        Button(group) { selectedGroup = group }
                            .font(.system(size: 12, design: .serif))
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .foregroundStyle(selectedGroup == group ? Palette.paper : Palette.olive)
                            .background(selectedGroup == group ? Palette.olive : Palette.sage.opacity(0.28), in: Capsule())
                    }
                }
            }
            if let selectedGroup {
                QuickFact(label: selectedGroup, value: compound.description)
            }
        }
        .onChange(of: compound.id) { _, _ in selectedGroup = nil }
    }
}
