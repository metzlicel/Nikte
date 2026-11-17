import Foundation

enum ValerianDocument {
    // Las secciones y la química multietapa comparten el esquema ya usado por romero.
    static func load(from bundle: Bundle = .main) throws -> RosemaryDocument {
        guard let url = bundle.url(forResource: "Valeriana", withExtension: "json", subdirectory: "Plants/Resources")
                ?? bundle.url(forResource: "Valeriana", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(RosemaryDocument.self, from: Data(contentsOf: url))
    }
}
