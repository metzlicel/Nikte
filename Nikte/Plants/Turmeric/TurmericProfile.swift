import Foundation

enum TurmericDocument {
    // La química destacada de cúrcuma comparte el esquema multietapa de romero.
    static func load(from bundle: Bundle = .main) throws -> RosemaryDocument {
        guard let url = bundle.url(forResource: "Curcuma", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Curcuma", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(RosemaryDocument.self, from: Data(contentsOf: url))
    }
}
