import Foundation

struct PreparationGuideDocument: Codable {
    let schemaVersion: String
    let language: String
    let purpose: String
    let lastReviewed: String
    let plantId: String
    let guides: [PreparationGuide]

    static func load(forPlantID plantID: String, from bundle: Bundle = .main) throws -> PreparationGuideDocument {
        let resources = ["chamomile": "ManzanillaPreparationGuides", "peppermint": "MentaPreparationGuides", "zingiber_officinale": "JengibrePreparationGuides", "aloe_vera": "AloeVeraPreparationGuides", "lavender": "LavandaPreparationGuides", "eucalyptus": "EucaliptoPreparationGuides", "rosemary": "RomeroPreparationGuides", "turmeric": "CurcumaPreparationGuides", "valerian": "ValerianaPreparationGuides", "ginseng": "GinsengPreparationGuides"]
        guard let name = resources[plantID],
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

    static func forAilment(plantMatchID: String, ailmentID: String) -> Self? {
        if plantMatchID == "menta" {
            let symptoms = [
                "sindrome_intestino_irritable": ("irritable-bowel-syndrome", "enteric-coated-peppermint-oil"),
                "dolor_abdominal_sii": ("ibs-abdominal-pain", "enteric-coated-peppermint-oil"),
                "espasmos_intestinales_sii": ("ibs-intestinal-spasms", "enteric-coated-peppermint-oil"),
                "cefalea_tensional_leve": ("mild-tension-headache", "commercial-10-percent-peppermint-topical")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "peppermint", symptomId: symptomID, preparationId: preparationID)
            }
        }
        if plantMatchID == "manzanilla" {
            let symptoms = [
                "inflamacion_bucal_leve": ("mild-mouth-inflammation", "oromucosal-infusion"),
                "aftas_pequenas": ("minor-mouth-ulcers", "oromucosal-infusion"),
                "irritacion_garganta_leve": ("mild-throat-irritation", "oromucosal-infusion"),
                "irritacion_cutanea_leve": ("mild-skin-irritation", "cutaneous-infusion-compress"),
                "quemadura_solar_leve": ("mild-sunburn", "cutaneous-infusion-compress")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "chamomile", symptomId: symptomID, preparationId: preparationID)
            }
        }
        if plantMatchID == "ginseng", ailmentID == "cansancio_debilidad_leves" {
            return Self(plantId: "ginseng", symptomId: "fatigue-weakness", preparationId: "decoction")
        }
        if plantMatchID == "valeriana" {
            let symptoms = [
                "dificultad_ocasional_dormir": ("occasional-sleep-difficulty", "infusion"),
                "estres_leve": ("mild-mental-stress", "commercial-herbal-tea-blend"),
                "tension_nerviosa_leve": ("mild-nervous-tension", "commercial-herbal-tea-blend")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "valerian", symptomId: symptomID, preparationId: preparationID)
            }
        }
        if plantMatchID == "romero" {
            let symptoms = [
                "estomago": ("mild-digestive-discomfort", "infusion"),
                "dolor_muscular_localizado_leve": ("mild-muscle-pain", "rosemary-leaf-bath"),
                "dolor_muscular_leve": ("mild-muscle-pain", "rosemary-leaf-bath"),
                "molestias_articulares_leves": ("mild-joint-pain", "rosemary-leaf-bath"),
                "piernas_cansadas_leves": ("minor-peripheral-circulation-discomfort", "rosemary-leaf-bath")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "rosemary", symptomId: symptomID, preparationId: preparationID)
            }
        }
        if plantMatchID == "eucalipto", ailmentID == "tos_resfriado" {
            return Self(plantId: "eucalyptus", symptomId: "cough-associated-with-cold", preparationId: "infusion")
        }
        if plantMatchID == "eucalipto", ailmentID == "dolor_muscular_localizado_leve" {
            return Self(plantId: "eucalyptus", symptomId: "localized-muscle-pain", preparationId: "muscle-ointment-10pct")
        }
        if plantMatchID == "lavanda" {
            let symptoms = [
                "estres_leve": ("mild-stress", "infusion"),
                "dificultad_ocasional_dormir": ("occasional-sleep-difficulty", "infusion"),
                "sintomas_ansiedad_leve": ("mild-anxiety-symptoms", "standard_oral"),
                "estres_leve_agotamiento": ("mild-stress", "lavender-bath-product"),
                "agotamiento_leve": ("mild-exhaustion", "lavender-bath-product")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "lavender", symptomId: symptomID, preparationId: preparationID)
            }
        }
        if plantMatchID == "aloe_vera", ailmentID == "quemaduras_superficiales_leves" {
            return Self(plantId: "aloe_vera", symptomId: "minor-superficial-burn", preparationId: "purified-inner-leaf-gel-topical")
        }
        if plantMatchID == "aloe_vera" {
            let symptoms = ["psoriasis_leve_diagnosticada": "mild-plaque-psoriasis", "placas_psoriasis_diagnosticada": "localized-psoriasis-plaques"]
            if let symptomID = symptoms[ailmentID] {
                return Self(plantId: "aloe_vera", symptomId: symptomID, preparationId: "commercial-aloe-topical-cream")
            }
        }
        if plantMatchID == "jengibre" {
            let symptoms = [
                "nauseas_movimiento": ("motion-sickness-nausea", "powdered-rhizome-with-water"),
                "estomago": ("mild-digestive-discomfort", "powdered-rhizome-warm-drink"),
                "indigestion_leve": ("mild-digestive-discomfort", "powdered-rhizome-warm-drink"),
                "hinchazon_abdominal": ("bloating", "powdered-rhizome-warm-drink"),
                "gases": ("flatulence", "powdered-rhizome-warm-drink"),
                "colicos_menstruales_leves": ("mild-menstrual-cramps", "measured-ginger-powder-capsules"),
                "dolor_menstrual_primario": ("primary-dysmenorrhea", "measured-ginger-powder-capsules")
            ]
            if let (symptomID, preparationID) = symptoms[ailmentID] {
                return Self(plantId: "zingiber_officinale", symptomId: symptomID, preparationId: preparationID)
            }
        }
        guard ["estomago", "gases"].contains(ailmentID) else { return nil }
        let plants = ["manzanilla": "chamomile", "menta": "peppermint", "curcuma": "turmeric"]
        guard let plantID = plants[plantMatchID] else { return nil }
        return Self(plantId: plantID, symptomId: "mild-digestive-discomfort", preparationId: "infusion")
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
