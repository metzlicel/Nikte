import Foundation

// El recurso conserva también las referencias bibliográficas como metadatos internos.
struct MintDocument: Decodable {
    let plant: MintProfile
    let sources: [MintSource]

    static func load(from bundle: Bundle = .main) throws -> MintDocument {
        guard let url = bundle.url(forResource: "Menta", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Menta", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(MintDocument.self, from: Data(contentsOf: url))
    }
}

struct MintSource: Decodable {
    let id: String
    let organization: String
    let title: String
    let url: URL
}

struct MintProfile: Decodable {
    let commonName: String
    let scientificName: String
    let family: String
    let usedParts: [String]
    let summary: String
    let section1: MintSection<MintProperty>
    let section2: MintSection<MintCompound>
    let section3: MintMechanisms
    let section4: MintSection<MintPreparation>
    let safetyNote: String
}

struct MintSection<Item: Decodable>: Decodable {
    let title: String
    let items: [Item]
}

struct MintProperty: Decodable, Identifiable {
    let id: String
    let title: String
    let description: String
    let evidenceContext: String
    let relatedCompoundIds: [String]
    let relatedPreparationIds: [String]
}

struct MintCompound: Decodable, Identifiable {
    let id: String
    let name: String
    let molecularFormula: String
    let chemicalClass: String
    let functionalGroups: [String]
    let description: String
    let distribution: String
    let pubchemCID: Int?

    var compound: Compound {
        Compound(id: id, name: name, formula: molecularFormula, family: chemicalClass,
                 mechanism: description, extraction: distribution)
    }

    // CID consultados por nombre en PubChem para los dos registros sin CID en el recurso.
    var structureCID: Int? {
        pubchemCID ?? ["menthone": 26447, "eriocitrin": 83489][id]
    }
}

struct MintMechanisms: Decodable {
    let title: String
    let items: [MintMechanism]
    let featuredChemistry: MintFeaturedChemistry
}

struct MintMechanism: Decodable, Identifiable {
    let id: String
    let title: String
    let compoundIds: [String]
    let explanation: String
    let steps: [MintStep]
    let plainLanguage: String
    let reaction: MintReaction?
}

struct MintStep: Decodable {
    let title: String
    let detail: String
}

struct MintReaction: Decodable {
    let note: String
}

struct MintFeaturedChemistry: Decodable {
    let title: String
    let reactionClass: String
    let description: String
    let educationalValue: String
}

struct MintPreparation: Decodable, Identifiable {
    let id: String
    let title: String
    let extractionMethod: String
    let description: String
    let highlightCompoundIds: [String]
    let warning: String?
    let extractionExperience: ExtractionExperience?
}

struct ExtractionExperience: Decodable {
    let heading: String
    let processTitle: String
    let steps: [ExtractionStep]
    let chemicalPrinciples: [String]
    let focusCompoundIds: [String]
    let visualType: String
    let comparisonNote: String
    let isExtraction: Bool
    let sourceIds: [String]
}

struct ExtractionStep: Decodable {
    let index: Int
    let title: String
    let detail: String
}
