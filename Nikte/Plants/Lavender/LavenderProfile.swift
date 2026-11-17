import Foundation

enum LavenderDocument {
    static func load(from bundle: Bundle = .main) throws -> MintDocument {
        guard let url = bundle.url(forResource: "Lavanda", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Lavanda", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(MintDocument.self, from: Data(contentsOf: url))
    }

    static func structureCID(for compound: MintCompound) -> Int? {
        // PubChem identifica el terpinen-4-ol como CID 11230.
        compound.pubchemCID ?? (compound.id == "terpinen4ol" ? 11230 : nil)
    }
}
