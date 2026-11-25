import SwiftUI

// MARK: - 03 · MODELOS Y CATÁLOGO DE PLANTAS

struct Plant: Identifiable, Hashable {
    let id: String
    let name: String
    let latin: String
    let subtitle: String
}

// MARK: - MODELO DEL GLOSARIO DE PLANTAS

struct PlantGlossaryItem: Identifiable {
    let id: PlantDetailID
    let commonName: String
    let scientificName: String
    let imageName: String
}

enum PlantDetailID: String, CaseIterable {
    case chamomile, peppermint
    case ginger = "zingiber_officinale"
    case aloe = "aloe_vera"
    case lavender, eucalyptus, rosemary, turmeric, valerian, ginseng
}

struct PlantDetailDestination: View {
    let plant: PlantDetailID

    @ViewBuilder var body: some View {
        switch plant {
        case .chamomile: ChamomileDetailView()
        case .peppermint: MintDetailView()
        case .ginger: GingerDetailView()
        case .aloe: AloeDetailView()
        case .lavender: LavenderDetailView()
        case .eucalyptus: EucalyptusDetailView()
        case .rosemary: RosemaryDetailView()
        case .turmeric: TurmericDetailView()
        case .valerian: ValerianDetailView()
        case .ginseng: GinsengDetailView()
        }
    }
}

// MARK: - DATOS DEL GLOSARIO

let glossaryPlants: [PlantGlossaryItem] = [
    PlantGlossaryItem(
        id: .chamomile,
        commonName: "Manzanilla",
        scientificName: "Matricaria chamomilla",
        imageName: "manzanilla_ilustracion"
    ),
    PlantGlossaryItem(
        id: .peppermint,
        commonName: "Menta",
        scientificName: "Mentha piperita",
        imageName: "menta_ilustracion"
    ),
    PlantGlossaryItem(
        id: .ginger,
        commonName: "Jengibre",
        scientificName: "Zingiber officinale",
        imageName: "jengibre_ilustracion"
    ),
    PlantGlossaryItem(
        id: .aloe,
        commonName: "Aloe Vera",
        scientificName: "Aloe barbadensis",
        imageName: "aloe_ilustracion"
    ),
    PlantGlossaryItem(
        id: .lavender,
        commonName: "Lavanda",
        scientificName: "Lavandula angustifolia",
        imageName: "lavanda_ilustracion"
    ),
    PlantGlossaryItem(
        id: .eucalyptus,
        commonName: "Eucalipto",
        scientificName: "Eucalyptus globulus",
        imageName: "eucalipto_ilustracion"
    ),
    PlantGlossaryItem(
        id: .rosemary,
        commonName: "Romero",
        scientificName: "Rosmarinus officinalis",
        imageName: "romero_ilustracion"
    ),
    PlantGlossaryItem(
        id: .turmeric,
        commonName: "Cúrcuma",
        scientificName: "Curcuma longa",
        imageName: "curcuma_ilustracion"
    ),
    PlantGlossaryItem(
        id: .valerian,
        commonName: "Valeriana",
        scientificName: "Valeriana officinalis",
        imageName: "valeriana_ilustracion"
    ),
    PlantGlossaryItem(
        id: .ginseng,
        commonName: "Ginseng",
        scientificName: "Panax ginseng",
        imageName: "ginseng_ilustracion"
    )
]
