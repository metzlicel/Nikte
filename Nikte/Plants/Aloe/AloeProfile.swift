import Foundation

struct AloeDocument: Decodable {
    let plant: AloeProfile
    let sources: [MintSource]

    static func load(from bundle: Bundle = .main) throws -> AloeDocument {
        guard let url = bundle.url(forResource: "AloeVera", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "AloeVera", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(AloeDocument.self, from: Data(contentsOf: url))
    }
}

struct AloeProfile: Decodable {
    let commonName: String
    let scientificName: String
    let family: String
    let usedParts: [String]
    let summary: String
    let section1: MintSection<MintProperty>
    let section2: MintSection<AloeCompound>
    let section3: MintMechanisms
    let section4: MintSection<MintPreparation>
    let safetyNote: String
}

struct AloeCompound: Decodable, Identifiable {
    let id: String
    let name: String
    let molecularFormula: String?
    let chemicalClass: String
    let functionalGroups: [String]
    let description: String
    let distribution: String
    let pubchemCID: Int?

    // D-manosa, consultada en PubChem; los polímeros no utilizan estructura 2D única.
    var structureCID: Int? {
        guard molecularFormula != nil else { return nil }
        return pubchemCID ?? (id == "mannose" ? 18950 : nil)
    }

    var smallMolecule: MintCompound? {
        guard let molecularFormula else { return nil }
        return MintCompound(id: id, name: name, molecularFormula: molecularFormula,
                            chemicalClass: chemicalClass, functionalGroups: functionalGroups,
                            description: description, distribution: distribution, pubchemCID: pubchemCID)
    }
}
