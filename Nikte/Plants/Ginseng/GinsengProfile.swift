import Foundation

struct GinsengDocument: Decodable {
    let plant: GinsengProfile
    let sources: [MintSource]

    static func load(from bundle: Bundle = .main) throws -> GinsengDocument {
        guard let url = bundle.url(forResource: "Ginseng", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Ginseng", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(GinsengDocument.self, from: Data(contentsOf: url))
    }
}

struct GinsengProfile: Decodable {
    let commonName: String
    let scientificName: String
    let family: String
    let usedParts: [String]
    let summary: String
    let section1: MintSection<MintProperty>
    let section2: MintSection<AloeCompound>
    let section3: RosemaryMechanisms
    let section4: MintSection<MintPreparation>
    let safetyNote: String

    // El explorador de mecanismos utiliza los nombres; no muestra la fórmula del adaptador.
    var mechanismProfile: MintProfile {
        let compounds = section2.items.map { item in
            MintCompound(id: item.id, name: item.name, molecularFormula: item.molecularFormula ?? "",
                         chemicalClass: item.chemicalClass, functionalGroups: item.functionalGroups,
                         description: item.description, distribution: item.distribution, pubchemCID: item.pubchemCID)
        }
        let featured = section3.featuredChemistry
        return MintProfile(commonName: commonName, scientificName: scientificName, family: family,
                           usedParts: usedParts, summary: summary, section1: section1,
                           section2: MintSection(title: section2.title, items: compounds),
                           section3: MintMechanisms(title: section3.title, items: section3.items,
                                                    featuredChemistry: MintFeaturedChemistry(
                                                        title: featured.title, reactionClass: featured.reactionType,
                                                        description: featured.description, educationalValue: featured.equation)),
                           section4: section4, safetyNote: safetyNote)
    }
}
