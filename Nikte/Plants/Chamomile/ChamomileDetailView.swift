import SwiftUI

// MARK: - 15 · FICHA TÉCNICA DE MANZANILLA

struct ChamomileDetailView: View {
    @State private var selectedCompound = "apigenin"
    @State private var extraction = "infusion"
    @State private var selectedMechanism = "heat"
    
    private let extractions = [
        ("flowers", "Flores secas"),
        ("infusion", "Infusión acuosa"),
        ("steam", "Aceite esencial"),
        ("ethanol", "Extracto hidroalcohólico")
    ]
    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    ZStack {
                        Image("frame")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                        Image("manzanilla_ilustracion")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 110)
                            .offset(y: 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 5)
                    SectionTitle(kicker: "FICHA BOTÁNICA · 001", title: "Manzanilla")
                    Text("Matricaria chamomilla L. · Asteraceae")
                        .font(.system(size: 17, design: .serif)).italic().foregroundStyle(Palette.brown)
                    Text("Parte estudiada: capítulos florales (flores).")
                        .foregroundStyle(Palette.ink)
                    ExpandableCard(title: "01 · Composición química", subtitle: "Conoce los compuestos activos") {
                        Text("Explora las moléculas y toca sus grupos funcionales.")
                            .font(.system(size: 14, design: .serif))
                            .foregroundStyle(Palette.brown)
                        Picker("Compuesto", selection: $selectedCompound) {
                            ForEach(compounds) { compound in Text(compound.name).tag(compound.id) }
                        }.tint(Palette.olive).pickerStyle(.menu)
                        if let compound = compounds.first(where: { $0.id == selectedCompound }) {
                            Text(compound.name)
                                .font(.system(size: 22, design: .serif)).bold()
                                .foregroundStyle(Palette.olive)
                            FactChip(text: compound.formula, symbol: "atom")
                            QuickFact(label: "Familia química", value: compound.family)
                            MolecularDiagramView(compoundID: selectedCompound)
                            QuickFact(label: "Actividad investigada", value: compound.mechanism)
                            QuickFact(label: "Extracción", value: compound.extraction)
                        }
                    }
                    ExpandableCard(title: "02 · Propiedades", subtitle: "Actividad biológica investigada") {
                        PropertyGallery()
                    }

                    ExpandableCard(
                        title: "03 · Reacciones y mecanismos",
                        subtitle: "Cómo funcionan los compuestos en el organismo"
                    ) {
                        BiologicalMechanismsView()
                    }
                    ExpandableCard(title: "04 · Extracciones", subtitle: "Cómo cambia la composición") {
                        Picker("Presentación", selection: $extraction) {
                            ForEach(extractions.indices, id: \.self) { index in
                                Text(extractions[index].1).tag(extractions[index].0)
                            }
                        }.tint(Palette.olive).pickerStyle(.menu)
                        ExtractionExplorerView(extraction: extraction)
                        ExtractionComparison(extraction: extraction)
                    }
                    PaperCard {
                        Text("Nota de seguridad").font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
                        Text("Contenido educativo. Las personas con alergia a plantas de la familia Asteraceae deben tener precaución. Los extractos concentrados y aceites esenciales no son equivalentes a una infusión ni deben ingerirse por analogía.")
                            .font(.system(size: 14)).foregroundStyle(Palette.ink)
                    }
                    Text("Fuentes de consulta: revisión fitoquímica de Matricaria chamomilla, PMC9822300. Los mecanismos resumidos incluyen hallazgos experimentales y no implican eficacia terapéutica demostrada.")
                        .font(.system(size: 12, design: .serif)).foregroundStyle(Palette.brown)
                }.padding(20)
                 .padding(.bottom, 45)
            }
            .scrollDisabled(false)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Ficha de manzanilla")
        .navigationBarTitleDisplayMode(.inline)
    }
}
