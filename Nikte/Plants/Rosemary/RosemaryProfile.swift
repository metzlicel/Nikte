import Foundation

struct RosemaryDocument: Decodable {
    let plant: RosemaryProfile
    let sources: [MintSource]

    static func load(from bundle: Bundle = .main) throws -> RosemaryDocument {
        guard let url = bundle.url(forResource: "Romero", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Romero", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(RosemaryDocument.self, from: Data(contentsOf: url))
    }

    static func structureCID(for compound: MintCompound) -> Int? {
        let verified = ["carnosic_acid": 65126, "carnosol": 442009, "rosmarinic_acid": 5281792]
        return compound.pubchemCID ?? verified[compound.id]
    }
}

struct RosemaryProfile: Decodable {
    let commonName: String
    let scientificName: String
    let family: String
    let usedParts: [String]
    let summary: String
    let section1: MintSection<MintProperty>
    let section2: MintSection<MintCompound>
    let section3: RosemaryMechanisms
    let section4: MintSection<MintPreparation>
    let safetyNote: String

    // Adaptador para reutilizar el explorador de mecanismos ya existente.
    var mechanismProfile: MintProfile {
        let featured = section3.featuredChemistry
        return MintProfile(commonName: commonName, scientificName: scientificName, family: family,
                           usedParts: usedParts, summary: summary, section1: section1, section2: section2,
                           section3: MintMechanisms(title: section3.title, items: section3.items,
                                                    featuredChemistry: MintFeaturedChemistry(
                                                        title: featured.title, reactionClass: featured.reactionType,
                                                        description: featured.description, educationalValue: featured.equation)),
                           section4: section4, safetyNote: safetyNote)
    }
}

struct RosemaryMechanisms: Decodable {
    let title: String
    let items: [MintMechanism]
    let featuredChemistry: RosemaryOxidation
}

struct RosemaryOxidation: Decodable {
    let title: String
    let reactionType: String
    let reactants: [String]
    let products: [String]
    let equation: String
    let description: String
    let interactiveSteps: [ExtractionStep]
    let compoundIds: [String]
    let sourceIds: [String]
}
