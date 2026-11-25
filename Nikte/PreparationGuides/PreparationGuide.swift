import Foundation

struct PreparationGuideDocument: Codable {
    static let resources = ["chamomile": "ManzanillaPreparationGuides", "peppermint": "MentaPreparationGuides", "zingiber_officinale": "JengibrePreparationGuides", "aloe_vera": "AloeVeraPreparationGuides", "lavender": "LavandaPreparationGuides", "eucalyptus": "EucaliptoPreparationGuides", "rosemary": "RomeroPreparationGuides", "turmeric": "CurcumaPreparationGuides", "valerian": "ValerianaPreparationGuides", "ginseng": "GinsengPreparationGuides"]
    let schemaVersion: String
    let language: String
    let purpose: String
    let lastReviewed: String
    let plantId: String
    let guides: [PreparationGuide]

    static func load(forPlantID plantID: String, from bundle: Bundle = .main) throws -> PreparationGuideDocument {
        guard let name = Self.resources[plantID],
              let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "Plants/Resources/PreparationGuides")
                ?? bundle.url(forResource: name, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        let document = try JSONDecoder().decode(PreparationGuideDocument.self, from: Data(contentsOf: url))
        guard document.plantId == plantID else { throw CocoaError(.fileReadCorruptFile) }
        return document
    }

    func guides(forSymptomID symptomID: String) -> [PreparationGuide] {
        guides.filter { $0.plantId == plantId && $0.symptomIds.contains(symptomID) }
    }

    func guide(for request: PreparationGuideRequest) -> PreparationGuide? {
        guard request.plantId == plantId else { return nil }
        return guides(forSymptomID: request.symptomId).first { $0.preparationId == request.preparationId }
    }
}

struct PreparationGuideRequest: Equatable {
    let plantId: String
    let symptomId: String
    let preparationId: String

}

struct GuideRecommendation: Identifiable {
    let plantId: String
    let plantName: String
    let imageName: String?
    let requests: [PreparationGuideRequest]
    let titles: [String]
    var id: String { plantId }
}

enum GuideRecommendations {
    static func matchingSymptom(for guide: PreparationGuide, ailmentID: String) -> String? {
        SymptomCatalog.entries.first { $0.id == ailmentID }?.symptomIDs.first { guide.symptomIds.contains($0) }
    }

    static func forAilment(_ ailmentID: String, from bundle: Bundle = .main) -> [GuideRecommendation] {
        forAilment(ailmentID, documents: documents(from: bundle))
    }

    static func documents(from bundle: Bundle = .main) -> [PreparationGuideDocument] {
        PreparationGuideDocument.resources.keys.sorted().compactMap { plantID in
            guard let plant = PlantDetailID(rawValue: plantID),
                  glossaryPlants.contains(where: { $0.id == plant }) else { return nil }
            return try? PreparationGuideDocument.load(forPlantID: plantID, from: bundle)
        }
    }

    static func forAilment(_ ailmentID: String, documents: [PreparationGuideDocument]) -> [GuideRecommendation] {
        guard SymptomCatalog.entries.contains(where: { $0.id == ailmentID }) else { return [] }
        return documents.compactMap { document in
            let plantID = document.plantId
            let matches = document.guides.compactMap { guide -> (PreparationGuide, PreparationGuideRequest)? in
                guard guide.plantId == plantID,
                      let symptom = matchingSymptom(for: guide, ailmentID: ailmentID) else { return nil }
                let request = PreparationGuideRequest(plantId: plantID, symptomId: symptom, preparationId: guide.preparationId)
                guard document.guide(for: request)?.id == guide.id else { return nil }
                return (guide, request)
            }
            guard let first = matches.first else { return nil }
            return GuideRecommendation(plantId: plantID, plantName: first.0.plantName, imageName: first.0.imageName,
                                       requests: matches.map { $0.1 }, titles: matches.map { $0.0.title })
        }.sorted { $0.plantName.localizedStandardCompare($1.plantName) == .orderedAscending }
    }
}

struct PreparationGuide: Codable, Identifiable {
    let id: String
    let plantId: String
    let plantName: String
    let scientificName: String
    let symptomIds: [String]
    let symptomLabels: [String]
    let preparationId: String
    let title: String
    let administrationRoute: String
    let ingredients: [GuideIngredient]
    let steps: [GuideStep]
    let chemistry: GuideChemistry
    let displaySafetyNote: String
    let references: [GuideReference]
    let reviewStatus: String
    let medicalReviewStatus: String
    let targetPopulation: GuidePopulation
    let dosage: GuideDosage
    let display: GuideDisplay

    var imageName: String? {
        ["chamomile": "manzanilla_ilustracion", "peppermint": "menta_ilustracion", "zingiber_officinale": "jengibre_ilustracion", "aloe_vera": "aloe_ilustracion", "lavender": "lavanda_ilustracion", "eucalyptus": "eucalipto_ilustracion", "rosemary": "romero_ilustracion", "turmeric": "curcuma_ilustracion", "valerian": "valeriana_ilustracion", "ginseng": "ginseng_ilustracion"][plantId]
    }
}

struct GuidePopulation: Codable {
    let display: String
}

struct GuideIngredient: Codable {
    let name: String
    let amount: String?
}

struct GuideDosage: Codable {
    let population: String
    let herbalMaterial: String?
    let waterVolume: String?
    let steepingMinutes: String?
    let decoctionMinutes: String?
    let frequency: String?
    let note: String
}

struct GuideStep: Codable, Identifiable {
    var id: Int { number }
    let number: Int
    let instruction: String
}

struct GuideChemistry: Codable {
    let title: String
    let explanation: String
    let interactiveSteps: [GuideChemistryStep]
}

struct GuideChemistryStep: Codable {
    let title: String
    let description: String
}

struct GuideDisplay: Codable {
    let sections: [String]
    let showReferences: Bool
    let showDetailedMechanisms: Bool
    let showDosageFrequency: Bool
    let showSafetyFooter: Bool
}

struct GuideReference: Codable, Identifiable {
    let id: String
    let organization: String
    let title: String
    let url: URL
    let supports: [String]
    let sourceType: String
}
