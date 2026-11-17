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
    let id = UUID()
    let commonName: String
    let scientificName: String
    let imageName: String
}

// MARK: - DATOS DEL GLOSARIO

let glossaryPlants: [PlantGlossaryItem] = [
    PlantGlossaryItem(
        commonName: "Manzanilla",
        scientificName: "Matricaria chamomilla",
        imageName: "manzanilla_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Menta",
        scientificName: "Mentha piperita",
        imageName: "menta_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Jengibre",
        scientificName: "Zingiber officinale",
        imageName: "jengibre_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Aloe Vera",
        scientificName: "Aloe barbadensis",
        imageName: "aloe_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Lavanda",
        scientificName: "Lavandula angustifolia",
        imageName: "lavanda_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Eucalipto",
        scientificName: "Eucalyptus globulus",
        imageName: "eucalipto_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Romero",
        scientificName: "Rosmarinus officinalis",
        imageName: "romero_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Cúrcuma",
        scientificName: "Curcuma longa",
        imageName: "curcuma_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Valeriana",
        scientificName: "Valeriana officinalis",
        imageName: "valeriana_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Ginseng",
        scientificName: "Panax ginseng",
        imageName: "ginseng_ilustracion"
    )
]

