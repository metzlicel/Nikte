import Foundation

// El jengibre comparte el esquema de las secciones y metadatos de la ficha de menta.
enum GingerDocument {
    static func load(from bundle: Bundle = .main) throws -> MintDocument {
        guard let url = bundle.url(forResource: "Jengibre", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Jengibre", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(MintDocument.self, from: Data(contentsOf: url))
    }

    static func structureCID(for compound: MintCompound) -> Int? {
        // El CID 168114 de 8-gingerol se consultó por nombre y fórmula en PubChem.
        compound.pubchemCID ?? (compound.id == "8_gingerol" ? 168114 : nil)
    }
}
