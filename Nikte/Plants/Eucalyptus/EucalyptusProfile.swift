import Foundation

enum EucalyptusDocument {
    static func load(from bundle: Bundle = .main) throws -> MintDocument {
        guard let url = bundle.url(forResource: "Eucalipto", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Eucalipto", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(MintDocument.self, from: Data(contentsOf: url))
    }

    static func structureCID(for compound: MintCompound) -> Int? {
        // Hiperósido: CID verificado por nombre y fórmula molecular en PubChem.
        compound.pubchemCID ?? (compound.id == "hyperoside" ? 5281643 : nil)
    }
}
