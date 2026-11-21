//
//  NikteTests.swift
//  NikteTests
//
//  Created by Metzli Celeste on 21/10/26.
//

import Testing
import UIKit
@testable import Nikte

private extension PreparationGuideRequest {
    static func forAilment(plantMatchID: String, ailmentID: String) -> Self? {
        func normalized(_ name: String) -> String {
            name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es_MX"))
                .replacingOccurrences(of: " ", with: "_")
        }
        return GuideRecommendations.forAilment(ailmentID)
            .first { normalized($0.plantName) == normalized(plantMatchID) }?.requests.first
    }
}

struct NikteTests {

    @Test @MainActor func recommendationsAlwaysResolveToMatchingBundledGuides() throws {
        #expect(PreparationGuideDocument.resources.count == 10)
        for plantID in PreparationGuideDocument.resources.keys {
            let document = try PreparationGuideDocument.load(forPlantID: plantID)
            #expect(!document.guides.isEmpty)
            for guide in document.guides {
                let option = try #require(ailmentOptions.first { GuideRecommendations.matchingSymptom(for: guide, ailmentID: $0.id) != nil })
                #expect(GuideRecommendations.forAilment(option.id).contains { recommendation in
                    recommendation.plantId == plantID && recommendation.requests.contains { $0.preparationId == guide.preparationId }
                })
            }
        }
        for option in ailmentOptions {
            let symptomIDs = GuideRecommendations.symptomIDs[option.id] ?? []
            let recommendations = GuideRecommendations.forAilment(option.id)
            #expect(Set(recommendations.map(\.plantId)).count == recommendations.count)
            for recommendation in recommendations {
                #expect(!recommendation.requests.isEmpty)
                #expect(glossaryPlants.contains { $0.imageName == recommendation.imageName })
                let document = try PreparationGuideDocument.load(forPlantID: recommendation.plantId)
                let eligible = document.guides.filter { guide in
                    guide.plantId == document.plantId && GuideRecommendations.matchingSymptom(for: guide, ailmentID: option.id) != nil
                }
                #expect(Set(eligible.map(\.id)) == Set(recommendation.requests.compactMap { document.guide(for: $0)?.id }))
                for request in recommendation.requests {
                    #expect(request.plantId == document.plantId)
                    #expect(symptomIDs.contains(request.symptomId))
                    let guide = try #require(document.guide(for: request))
                    #expect(guide.symptomIds.contains(request.symptomId))
                    #expect(guide.preparationId == request.preparationId)
                }
            }
        }
        for id in ["insomnio", "ansiedad", "colicos", "nauseas", "cabeza", "estomago", "congestion"] {
            #expect(GuideRecommendations.forAilment(id).isEmpty)
        }
        #expect(GuideRecommendations.forAilment("unknown").isEmpty)
        #expect(Set(GuideRecommendations.forAilment("gases").map(\.plantId)) == Set(["peppermint", "turmeric", "zingiber_officinale"]))
        #expect(!GuideRecommendations.forAilment("gases").contains { $0.plantId == "rosemary" || $0.plantId == "chamomile" })
        #expect(GuideRecommendations.forAilment("tos_resfriado").first?.requests.count == 2)
        #expect(GuideRecommendations.forAilment("cansancio_debilidad_leves").first?.requests.count == 3)
        #expect(GuideRecommendations.forAilment("estres_leve").first { $0.plantId == "lavender" }?.requests.count == 3)
        #expect(GuideRecommendations.forAilment("dificultad_ocasional_dormir").first { $0.plantId == "lavender" }?.requests.count == 2)
    }

    @Test @MainActor func chamomileDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "chamomile")
        for symptom in ["molestias_digestivas_leves"] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: symptom))
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "chamomile-digestive-infusion")
            #expect(guide.plantId == "chamomile")
            #expect(guide.symptomIds.contains("mild-digestive-discomfort"))
            #expect(guide.preparationId == "infusion")
            #expect(guide.ingredients.first?.amount == "1.5–4 g")
            #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
            #expect(guide.dosage.waterVolume == "150 mL")
            #expect(guide.dosage.steepingMinutes == "5–15")
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(!guide.displaySafetyNote.isEmpty)
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showDosageFrequency)
            #expect(!guide.display.showReferences)
            #expect(guide.medicalReviewStatus == "not_clinically_reviewed")
        }
        for symptom in ["ansiedad", "insomnio", "colicos"] {
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: symptom) == nil)
        }
        let mismatch = PreparationGuideRequest(plantId: "chamomile", symptomId: "insomnia", preparationId: "infusion")
        #expect(document.guide(for: mismatch) == nil)
    }

    @Test @MainActor func chamomileMouthAndSkinGuidesRouteAndLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "chamomile")
        #expect(document.guides.count == 3)
        let routes = [
            ("inflamacion_bucal_leve", "mild-mouth-inflammation", "oromucosal-infusion"),
            ("aftas_pequenas", "minor-mouth-ulcers", "oromucosal-infusion"),
            ("irritacion_garganta_leve", "mild-throat-irritation", "oromucosal-infusion"),
            ("irritacion_cutanea_leve", "mild-skin-irritation", "cutaneous-infusion-compress"),
            ("quemadura_solar_leve", "mild-sunburn", "cutaneous-infusion-compress")
        ]
        for (ailment, symptom, preparation) in routes {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == preparation)
            let guide = try #require(document.guide(for: request))
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.medicalReviewStatus == "not_clinically_reviewed")
            #expect(!guide.references.isEmpty)
            #expect(guide.ingredients.dropFirst().first?.amount == "100 mL")
            if preparation == "oromucosal-infusion" {
                #expect(guide.id == "chamomile-mouth-rinse")
                #expect(guide.administrationRoute == "oromucosal")
                #expect(guide.ingredients.first?.amount == "1–5 g")
                #expect(guide.displaySafetyNote.contains("No tragar"))
            } else {
                #expect(guide.id == "chamomile-skin-compress")
                #expect(guide.administrationRoute == "cutaneous")
                #expect(guide.ingredients.first?.amount == "3–10 g")
                #expect(guide.displaySafetyNote.contains("piel intacta"))
                #expect(guide.displaySafetyNote.contains("ampollas"))
            }
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: ailment) == nil)
            let mismatch = PreparationGuideRequest(plantId: "chamomile", symptomId: symptom, preparationId: "infusion")
            #expect(document.guide(for: mismatch) == nil)
        }
    }

    @Test @MainActor func chamomileBiochemicalMechanismsLoadForEachPreparation() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "chamomile")
        let cases = [
            ("molestias_digestivas_leves", "¿Cómo podría aliviar los espasmos digestivos?", "Señalización del Ca²⁺", "contracción del músculo intestinal"),
            ("inflamacion_bucal_leve", "¿Cómo podría aliviar la irritación bucal?", "Compuestos fenólicos", "modelos experimentales"),
            ("irritacion_cutanea_leve", "¿Cómo podría aliviar la irritación de la piel?", "Flavonoides", "vías inflamatorias")
        ]
        for (ailment, title, stage, detail) in cases {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: ailment))
            let guide = try #require(document.guide(for: request))
            #expect(guide.chemistry.title == title)
            #expect(!guide.chemistry.explanation.isEmpty)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.chemistry.interactiveSteps[1].title == stage)
            #expect(guide.chemistry.interactiveSteps[1].description.contains(detail))
        }
    }

    @Test @MainActor func peppermintDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "peppermint")
        #expect(document.plantId == "peppermint")
        #expect(document.guides(forSymptomID: "mild-digestive-discomfort").count == 1)
        #expect(document.guides(forSymptomID: "insomnia").isEmpty)
        for symptom in ["molestias_digestivas_leves", "indigestion_leve"] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: symptom))
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "peppermint-digestive-infusion")
            #expect(guide.plantId == "peppermint")
            #expect(guide.symptomIds.contains("mild-digestive-discomfort"))
            #expect(guide.preparationId == "infusion")
            #expect(guide.imageName == "menta_ilustracion")
            #expect(guide.ingredients.first?.amount == "1.5–3 g")
            #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.targetPopulation.display == "Adultos (cantidades de esta guía)")
            #expect(guide.displaySafetyNote.contains("reflujo/acidez"))
            #expect(!guide.references.isEmpty)
        }
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "colicos") == nil)
        let chamomile = try PreparationGuideDocument.load(forPlantID: "chamomile")
        let mintRequest = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "molestias_digestivas_leves"))
        #expect(chamomile.guide(for: mintRequest) == nil)
    }

    @Test @MainActor func peppermintIBSAndHeadacheGuidesRouteAndLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "peppermint")
        #expect(document.guides.count == 3)
        let routes = [
            ("sindrome_intestino_irritable", "irritable-bowel-syndrome"),
            ("dolor_abdominal_sii", "ibs-abdominal-pain"),
            ("espasmos_intestinales_sii", "ibs-intestinal-spasms")
        ]
        for (ailment, symptom) in routes {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == "enteric-coated-peppermint-oil")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "peppermint-ibs-enteric-capsules")
            #expect(guide.administrationRoute == "oral")
            #expect(guide.steps.count == 4)
            #expect(guide.steps[2].instruction.contains("entera"))
            #expect(guide.displaySafetyNote.contains("No ingerir aceite esencial puro"))
            #expect(guide.displaySafetyNote.contains("antiácidos"))
            #expect(guide.chemistry.interactiveSteps[1].title == "Acción del mentol")
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showReferences)
            #expect(document.guide(for: .init(plantId: "peppermint", symptomId: symptom, preparationId: "infusion")) == nil)
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: ailment) == nil)
        }
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "cefalea_tensional_leve"))
        #expect(request.symptomId == "mild-tension-headache")
        #expect(request.preparationId == "commercial-10-percent-peppermint-topical")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "peppermint-tension-headache-topical")
        #expect(guide.administrationRoute == "cutaneous")
        #expect(guide.ingredients.first?.name.contains("10 %") == true)
        #expect(guide.steps.count == 4)
        #expect(guide.displaySafetyNote.contains("Solo adultos"))
        #expect(guide.displaySafetyNote.contains("ojos, mucosas"))
        #expect(guide.chemistry.explanation.contains("TRPM8"))
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "cabeza") == nil)
        let infusionRequest = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "molestias_digestivas_leves"))
        let infusion = try #require(document.guide(for: infusionRequest))
        #expect(infusion.chemistry.interactiveSteps[1].title == "Mentol y señalización")
    }

    @Test @MainActor func gingerMotionSicknessGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "zingiber_officinale")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: "nauseas_movimiento"))
        #expect(request.symptomId == "motion-sickness-nausea")
        #expect(request.preparationId == "powdered-rhizome-with-water")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "ginger-motion-sickness-powder")
        #expect(guide.imageName == "jengibre_ilustracion")
        #expect(guide.ingredients.first?.amount == "1–2 g")
        #expect(guide.ingredients.first?.name.contains("seco") == true)
        #expect(guide.dosage.waterVolume == nil)
        #expect(guide.dosage.steepingMinutes == nil)
        #expect(guide.steps.count == 3)
        #expect(guide.steps.last?.instruction.contains("una hora antes del viaje") == true)
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.displaySafetyNote.contains("Solo adultos"))
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: "nauseas") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "nauseas_movimiento") == nil)
        #expect(document.guides(forSymptomID: "mild-digestive-discomfort").first?.id == "ginger-digestive-warm-drink")
    }

    @Test @MainActor func gingerDigestiveAndMenstrualGuidesRouteAndLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "zingiber_officinale")
        #expect(document.guides.count == 3)
        let digestive = [("molestias_digestivas_leves", "mild-digestive-discomfort"), ("indigestion_leve", "mild-digestive-discomfort"), ("hinchazon_abdominal", "bloating"), ("gases", "flatulence")]
        for (ailment, symptom) in digestive {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == "powdered-rhizome-warm-drink")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "ginger-digestive-warm-drink")
            #expect(guide.ingredients[2].amount?.contains("opcional") == true)
            #expect(guide.ingredients[3].amount?.contains("opcional") == true)
            #expect(guide.steps.count == 4)
            #expect(guide.steps[3].instruction.contains("no filtres"))
            #expect(guide.chemistry.interactiveSteps[1].title == "Compuestos del jengibre")
            #expect(guide.chemistry.explanation.contains("no mejoraron los síntomas"))
            #expect(guide.displaySafetyNote.contains("anticoagulantes"))
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showReferences)
        }
        for (ailment, symptom) in [("colicos_menstruales_leves", "mild-menstrual-cramps"), ("dolor_menstrual_primario", "primary-dysmenorrhea")] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == "measured-ginger-powder-capsules")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "ginger-menstrual-cramps-capsules")
            #expect(guide.steps.count == 3)
            #expect(guide.chemistry.explanation.contains("no prueban que una bebida casera"))
            #expect(guide.chemistry.interactiveSteps[1].description.contains("COX"))
            #expect(guide.displaySafetyNote.contains("anticoagulantes"))
            #expect(!guide.references.isEmpty)
            #expect(document.guide(for: .init(plantId: "zingiber_officinale", symptomId: symptom, preparationId: "powdered-rhizome-warm-drink")) == nil)
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: ailment) == nil)
        }
        let motion = try #require(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: "nauseas_movimiento"))
        let guide = try #require(document.guide(for: motion))
        #expect(guide.chemistry.explanation.contains("no ha encontrado un beneficio claro"))
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "jengibre", ailmentID: "colicos") == nil)
    }

    @Test @MainActor func aloeMinorBurnGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "aloe_vera")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "aloe_vera", ailmentID: "quemaduras_superficiales_leves"))
        #expect(request.symptomId == "minor-superficial-burn")
        #expect(request.preparationId == "purified-inner-leaf-gel-topical")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "aloe-vera-minor-superficial-burn-topical-gel")
        #expect(guide.administrationRoute == "topical")
        #expect(guide.imageName == "aloe_ilustracion")
        #expect(guide.ingredients.first?.amount == "Cantidad suficiente para una capa fina")
        #expect(guide.steps.count == 4)
        #expect(guide.steps.first?.instruction.contains("10–15 minutos") == true)
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.displaySafetyNote.contains("látex amarillo"))
        #expect(guide.displaySafetyNote.contains("ampollas extensas"))
        #expect(guide.dosage.herbalMaterial == nil)
        #expect(guide.dosage.frequency == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "aloe_vera", ailmentID: "estomago") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "quemaduras_superficiales_leves") == nil)
    }

    @Test @MainActor func aloeDiagnosedPsoriasisGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "aloe_vera")
        let routes = [("psoriasis_leve_diagnosticada", "mild-plaque-psoriasis"), ("placas_psoriasis_diagnosticada", "localized-psoriasis-plaques")]
        for (ailment, symptom) in routes {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "aloe_vera", ailmentID: ailment))
            #expect(request.plantId == "aloe_vera")
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == "commercial-aloe-topical-cream")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "aloe-vera-mild-plaque-psoriasis-topical-cream")
            #expect(guide.administrationRoute == "topical")
            #expect(guide.ingredients.first?.name.contains("Crema comercial") == true)
            #expect(guide.steps.count == 4)
            #expect(guide.steps.first?.instruction.contains("diagnosticada") == true)
            #expect(guide.chemistry.explanation.contains("contradictorios"))
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.chemistry.interactiveSteps[1].title == "Componentes del aloe")
            #expect(guide.displaySafetyNote.contains("No sustituye"))
            #expect(guide.displaySafetyNote.contains("infectadas"))
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showReferences)
            #expect(document.guide(for: .init(plantId: "aloe_vera", symptomId: symptom, preparationId: "purified-inner-leaf-gel-topical")) == nil)
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "manzanilla", ailmentID: ailment) == nil)
        }
        let burn = try #require(PreparationGuideRequest.forAilment(plantMatchID: "aloe_vera", ailmentID: "quemaduras_superficiales_leves"))
        let guide = try #require(document.guide(for: burn))
        #expect(guide.chemistry.explanation.contains("acemanano"))
        #expect(guide.chemistry.interactiveSteps[1].title == "Acemanano y células reparadoras")
    }

    @Test @MainActor func lavenderMildStressAndOccasionalSleepGuideLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "lavender")
        let symptomIDs = ["estres_leve": "mild-stress", "dificultad_ocasional_dormir": "occasional-sleep-difficulty"]
        for (ailmentID, symptomID) in symptomIDs {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: ailmentID))
            #expect(request.plantId == "lavender")
            #expect(request.symptomId == symptomID)
            #expect(request.preparationId == "infusion")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "lavender-mild-stress-infusion")
            #expect(guide.imageName == "lavanda_ilustracion")
            #expect(guide.ingredients.first?.amount == "1–2 g")
            #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.displaySafetyNote.contains("No ingerir aceite esencial"))
            #expect(guide.displaySafetyNote.contains("sedantes"))
            #expect(!guide.references.isEmpty)
        }
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "insomnio") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "ansiedad") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "estres_leve") == nil)
    }

    @Test @MainActor func lavenderStandardizedOilAndBathGuidesRouteAndLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "lavender")
        #expect(document.guides.count == 3)
        let oral = try #require(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "sintomas_ansiedad_leve"))
        #expect(oral.symptomId == "mild-anxiety-symptoms")
        #expect(oral.preparationId == "standard_oral")
        let capsules = try #require(document.guide(for: oral))
        #expect(capsules.id == "lavender-standardized-oil-anxiety")
        #expect(capsules.administrationRoute == "oral")
        #expect(capsules.steps.count == 4)
        #expect(capsules.displaySafetyNote.contains("No ingerir aceite esencial puro"))
        #expect(capsules.displaySafetyNote.contains("sedantes"))
        #expect(capsules.chemistry.interactiveSteps[1].title == "Aceite estandarizado")
        #expect(!capsules.references.isEmpty)
        #expect(!capsules.display.showReferences)
        for (ailment, symptom) in [("estres_leve_agotamiento", "mild-exhaustion"), ("agotamiento_leve", "mild-exhaustion")] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(request.preparationId == "lavender-bath-product")
            let bath = try #require(document.guide(for: request))
            #expect(bath.id == "lavender-bath-mild-stress")
            #expect(bath.administrationRoute == "bath")
            #expect(bath.steps.count == 4)
            #expect(bath.steps[2].instruction.contains("no añadas aceite esencial puro"))
            #expect(bath.displaySafetyNote.contains("no beber"))
            #expect(bath.displaySafetyNote.contains("heridas abiertas"))
            #expect(bath.chemistry.interactiveSteps[1].title == "Receptores olfativos")
            #expect(!bath.references.isEmpty)
            #expect(!bath.display.showReferences)
            #expect(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: ailment) == nil)
        }
        let infusion = try #require(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "estres_leve"))
        let guide = try #require(document.guide(for: infusion))
        #expect(guide.preparationId == "infusion")
        #expect(guide.chemistry.interactiveSteps[1].title == "Terpenos de lavanda")
        #expect(document.guide(for: .init(plantId: "lavender", symptomId: "mild-anxiety-symptoms", preparationId: "lavender-bath-product")) == nil)
    }

    @Test @MainActor func eucalyptusColdCoughGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "eucalyptus")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "eucalipto", ailmentID: "tos_resfriado"))
        #expect(request.plantId == "eucalyptus")
        #expect(request.symptomId == "cough-associated-with-cold")
        #expect(request.preparationId == "infusion")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "eucalyptus-cold-cough-infusion")
        #expect(guide.administrationRoute == "oral")
        #expect(guide.imageName == "eucalipto_ilustracion")
        #expect(guide.ingredients.first?.amount == "1.5–3 g")
        #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
        #expect(guide.dosage.steepingMinutes == "10–15")
        #expect(guide.steps.count == 4)
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.displaySafetyNote.contains("No agregar aceite esencial"))
        #expect(guide.displaySafetyNote.contains("falta de aire"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "eucalipto", ailmentID: "congestion") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "tos_resfriado") == nil)
    }

    @Test @MainActor func eucalyptusOintmentGuidesAndCoughSelectionLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "eucalyptus")
        let cough = document.guides(forSymptomID: "cough-associated-with-cold")
        #expect(Set(cough.map(\.preparationId)) == Set(["infusion", "chest-ointment-10pct"]))
        for preparation in ["infusion", "chest-ointment-10pct"] {
            let request = PreparationGuideRequest(plantId: "eucalyptus", symptomId: "cough-associated-with-cold", preparationId: preparation)
            let guide = try #require(document.guide(for: request))
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.chemistry.interactiveSteps[1].title == "1,8-cineol")
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showReferences)
            if preparation == "infusion" {
                #expect(guide.administrationRoute == "oral")
                #expect(guide.displaySafetyNote.contains("No agregar aceite esencial"))
            } else {
                #expect(guide.id == "eucalyptus-cold-cough-chest-ointment")
                #expect(guide.administrationRoute == "cutaneous")
                #expect(guide.steps.count == 3)
                #expect(guide.displaySafetyNote.contains("No ingerir"))
                #expect(guide.displaySafetyNote.contains("rostro, nariz"))
            }
        }
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "eucalipto", ailmentID: "dolor_muscular_localizado_leve"))
        #expect(request.symptomId == "localized-muscle-pain")
        #expect(request.preparationId == "muscle-ointment-10pct")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "eucalyptus-local-muscle-pain-ointment")
        #expect(guide.administrationRoute == "cutaneous")
        #expect(guide.ingredients.first?.name.contains("10 %") == true)
        #expect(guide.steps.count == 3)
        #expect(guide.displaySafetyNote.contains("heridas"))
        #expect(guide.displaySafetyNote.contains("Solo adultos"))
        #expect(guide.chemistry.interactiveSteps[1].title == "Cineol y mediadores")
        #expect(!guide.references.isEmpty)
        #expect(document.guide(for: .init(plantId: "eucalyptus", symptomId: "localized-muscle-pain", preparationId: "chest-ointment-10pct")) == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "dolor_muscular_localizado_leve") == nil)
    }

    @Test @MainActor func rosemaryDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "rosemary")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "molestias_digestivas_leves"))
        #expect(request.plantId == "rosemary")
        #expect(request.symptomId == "mild-digestive-discomfort")
        #expect(request.preparationId == "infusion")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "rosemary-mild-digestive-infusion")
        #expect(guide.imageName == "romero_ilustracion")
        #expect(guide.ingredients.first?.amount == "1–2 g")
        #expect(guide.ingredients.dropFirst().first?.amount == "150–250 mL")
        #expect(guide.dosage.steepingMinutes == "5–15")
        #expect(guide.steps.count == 4)
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.displaySafetyNote.contains("vías biliares"))
        #expect(guide.displaySafetyNote.contains("embarazo o lactancia"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "colicos") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "gases") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "eucalipto", ailmentID: "estomago") == nil)
    }

    @Test @MainActor func rosemaryBathAndOintmentGuidesRouteAndLoad() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "rosemary")
        #expect(document.guides.count == 3)
        for (ailment, symptom) in [("dolor_muscular_localizado_leve", "mild-muscle-pain"), ("dolor_muscular_leve", "mild-muscle-pain"), ("molestias_articulares_leves", "mild-joint-pain")] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            #expect(Set(document.guides(forSymptomID: symptom).map(\.preparationId)) == Set(["rosemary-leaf-bath", "rosemary-oil-commercial-ointment"]))
            let bath = try #require(document.guide(for: request))
            #expect(bath.id == "rosemary-muscle-joint-bath")
            #expect(bath.administrationRoute == "bath")
            #expect(bath.ingredients.first?.amount == "50 g")
            #expect(bath.steps.count == 4)
            #expect(bath.displaySafetyNote.contains("pierna súbitamente hinchada"))
            #expect(bath.chemistry.interactiveSteps[1].title == "Compuestos fenólicos del romero")
            #expect(!bath.references.isEmpty)
            let ointment = try #require(document.guide(for: .init(plantId: "rosemary", symptomId: symptom, preparationId: "rosemary-oil-commercial-ointment")))
            #expect(ointment.id == "rosemary-local-muscle-pain-ointment")
            #expect(ointment.administrationRoute == "topical")
            #expect(ointment.steps.count == 3)
            #expect(ointment.displaySafetyNote.contains("Solo adultos"))
            #expect(ointment.displaySafetyNote.contains("nunca aceite esencial sin diluir"))
            #expect(ointment.chemistry.interactiveSteps[1].title == "Monoterpenos del romero")
            #expect(!ointment.references.isEmpty)
            #expect(!ointment.display.showReferences)
        }
        let circulation = try #require(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "piernas_cansadas_leves"))
        #expect(circulation.symptomId == "minor-peripheral-circulation-discomfort")
        #expect(document.guides(forSymptomID: circulation.symptomId).count == 1)
        #expect(document.guide(for: circulation)?.id == "rosemary-muscle-joint-bath")
        #expect(document.guide(for: .init(plantId: "rosemary", symptomId: circulation.symptomId, preparationId: "rosemary-oil-commercial-ointment")) == nil)
        let digestive = try #require(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "molestias_digestivas_leves"))
        #expect(document.guide(for: digestive)?.chemistry.interactiveSteps[1].title == "Componentes del romero")
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "molestias_articulares_leves") == nil)
    }

    @Test @MainActor func turmericDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "turmeric")
        for ailment in ["molestias_digestivas_leves", "gases"] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "curcuma", ailmentID: ailment))
            #expect(request.plantId == "turmeric")
            #expect(request.symptomId == "mild-digestive-discomfort")
            #expect(request.preparationId == "infusion")
            let guide = try #require(document.guide(for: request))
            #expect(guide.id == "turmeric-mild-digestive-infusion")
            #expect(guide.imageName == "curcuma_ilustracion")
            #expect(guide.ingredients.first?.amount == "0.5–1 g")
            #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
            #expect(guide.dosage.steepingMinutes == "5–15")
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.chemistry.explanation.contains("poca curcumina disuelta"))
            #expect(guide.chemistry.interactiveSteps[1].title == "Compuestos del rizoma")
            #expect(guide.displaySafetyNote.contains("Solo adultos"))
            #expect(guide.displaySafetyNote.contains("lesión hepática"))
            #expect(!guide.references.isEmpty)
            #expect(Set(document.guides(forSymptomID: request.symptomId).map(\.preparationId)) == Set(["infusion", "powdered-rhizome-food"]))
            let foodRequest = PreparationGuideRequest(plantId: "turmeric", symptomId: request.symptomId, preparationId: "powdered-rhizome-food")
            let food = try #require(document.guide(for: foodRequest))
            #expect(food.id == "turmeric-digestive-powder-food")
            #expect(food.administrationRoute == "oral")
            #expect(food.steps.count == 3)
            #expect(food.steps[2].instruction.contains("no intentes alcanzar una dosis medicinal"))
            #expect(food.chemistry.interactiveSteps[1].title == "Constituyentes de cúrcuma")
            #expect(food.chemistry.interactiveSteps[2].description.contains("no equivale"))
            #expect(food.displaySafetyNote.contains("enfermedad hepática"))
            #expect(food.displaySafetyNote.contains("ictericia"))
            #expect(!food.references.isEmpty)
            #expect(!food.display.showReferences)
        }
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "curcuma", ailmentID: "colicos") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "curcuma", ailmentID: "nauseas") == nil)
    }

    @Test @MainActor func valerianOccasionalSleepGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "valerian")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: "dificultad_ocasional_dormir"))
        #expect(request.plantId == "valerian")
        #expect(request.symptomId == "occasional-sleep-difficulty")
        #expect(request.preparationId == "infusion")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "valerian-occasional-sleep-difficulty-infusion")
        #expect(guide.imageName == "valeriana_ilustracion")
        #expect(guide.ingredients.first?.amount == "0.3–3 g")
        #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
        #expect(guide.steps.count == 4)
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.chemistry.explanation.contains("misma exposición que un extracto estandarizado"))
        #expect(guide.displaySafetyNote.contains("somnolencia"))
        #expect(guide.displaySafetyNote.contains("sedantes"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: "insomnio") == nil)
        #expect(guide.chemistry.interactiveSteps[1].title == "Receptor GABA-A")
    }

    @Test @MainActor func valerianSharedSymptomsOfferMatchingPreparations() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "valerian")
        #expect(document.guides.count == 3)
        for (ailment, symptom, count) in [("dificultad_ocasional_dormir", "occasional-sleep-difficulty", 3), ("estres_leve", "mild-mental-stress", 2), ("tension_nerviosa_leve", "mild-nervous-tension", 2)] {
            let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: ailment))
            #expect(request.symptomId == symptom)
            let guides = document.guides(forSymptomID: symptom)
            #expect(guides.count == count)
            for guide in guides {
                let selected = PreparationGuideRequest(plantId: "valerian", symptomId: symptom, preparationId: guide.preparationId)
                #expect(document.guide(for: selected)?.id == guide.id)
                #expect(guide.administrationRoute == "oral")
                #expect(guide.steps.count == 4)
                #expect(guide.chemistry.interactiveSteps.count == 3)
                #expect(guide.displaySafetyNote.contains("somnolencia"))
                #expect(guide.displaySafetyNote.contains("alcohol"))
                #expect(guide.displaySafetyNote.contains("sedantes"))
                #expect(!guide.references.isEmpty)
                #expect(!guide.display.showReferences)
            }
            let blend = try #require(guides.first { $0.preparationId == "commercial-herbal-tea-blend" })
            #expect(blend.chemistry.explanation.contains("sinergia clínica"))
            #expect(blend.chemistry.interactiveSteps[1].title == "Sistema GABA")
            let capsules = try #require(guides.first { $0.preparationId == "standardized-ethanolic-dry-extract-capsules" })
            #expect(capsules.chemistry.interactiveSteps[1].title == "Modulación GABA-A")
            #expect(capsules.chemistry.explanation.contains("no todas las cápsulas o suplementos son equivalentes"))
        }
    }

    @Test @MainActor func ginsengFatigueDecoctionGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "ginseng")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "ginseng", ailmentID: "cansancio_debilidad_leves"))
        #expect(request.plantId == "ginseng")
        #expect(request.symptomId == "fatigue-weakness")
        #expect(request.preparationId == "decoction")
        let guide = try #require(document.guide(for: request))
        #expect(guide.id == "ginseng-fatigue-white-root-decoction")
        #expect(guide.imageName == "ginseng_ilustracion")
        #expect(guide.ingredients.first?.amount == "1–2 g")
        #expect(guide.ingredients.first?.name.contains("ginseng blanco") == true)
        #expect(guide.ingredients.dropFirst().first?.amount == "150 mL")
        #expect(guide.dosage.decoctionMinutes == "15–30")
        #expect(guide.dosage.steepingMinutes == nil)
        #expect(guide.steps.count == 4)
        #expect(guide.steps[1].instruction.contains("agua fría"))
        #expect(guide.chemistry.interactiveSteps.count == 3)
        #expect(guide.chemistry.explanation.contains("modelos experimentales"))
        #expect(guide.chemistry.explanation.contains("limitada y heterogénea"))
        #expect(guide.chemistry.interactiveSteps[1].title == "Ginsenósidos y señalización")
        #expect(guide.displaySafetyNote.contains("anticoagulantes"))
        #expect(guide.displaySafetyNote.contains("insomnio"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "ginseng", ailmentID: "insomnio") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "cansancio_debilidad_leves") == nil)
    }

    @Test @MainActor func ginsengFatiguePreparationSelectionLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "ginseng")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "ginseng", ailmentID: "cansancio_debilidad_leves"))
        let guides = document.guides(forSymptomID: request.symptomId)
        #expect(Set(guides.map(\.preparationId)) == Set(["decoction", "powder-food", "standardized-oral-extract"]))
        for guide in guides {
            let selection = PreparationGuideRequest(plantId: "ginseng", symptomId: request.symptomId, preparationId: guide.preparationId)
            #expect(document.guide(for: selection)?.id == guide.id)
            #expect(guide.administrationRoute == "oral")
            #expect(guide.steps.count == 4)
            #expect(guide.chemistry.interactiveSteps.count == 3)
            #expect(guide.displaySafetyNote.contains("anticoagulantes"))
            #expect(guide.displaySafetyNote.contains("insomnio"))
            #expect(guide.displaySafetyNote.contains("diabetes"))
            #expect(!guide.references.isEmpty)
            #expect(!guide.display.showReferences)
        }
        let powder = try #require(guides.first { $0.preparationId == "powder-food" })
        #expect(powder.ingredients.first?.amount?.contains("250–600 mg") == true)
        #expect(powder.steps[1].instruction.contains("báscula de precisión"))
        #expect(powder.chemistry.explanation.contains("preclínica"))
        #expect(powder.chemistry.interactiveSteps[2].description.contains("sin confirmarse"))
        let extract = try #require(guides.first { $0.preparationId == "standardized-oral-extract" })
        #expect(extract.steps[1].instruction.contains("no son equivalentes"))
        #expect(extract.steps[3].instruction.contains("No combines"))
        #expect(extract.chemistry.explanation.contains("no son consistentes"))
        #expect(extract.chemistry.interactiveSteps[1].title == "Ginsenósidos del extracto")
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test @MainActor func mintProfileAndStructuresAreBundled() throws {
        let document = try MintDocument.load()
        let profile = document.plant
        #expect(profile.section1.items.count == 4)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 6)
        #expect(!document.sources.isEmpty)
        let compoundIDs = Set(profile.section2.items.map(\.id))
        for compound in profile.section2.items {
            #expect(compound.structureCID != nil)
            #expect(UIImage(named: "mint_\(compound.id)") != nil)
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compoundIDs))
        }
        for preparation in profile.section4.items {
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compoundIDs))
            let experience = try #require(preparation.extractionExperience)
            #expect(!experience.heading.isEmpty)
            #expect(!experience.processTitle.isEmpty)
            #expect(experience.steps.count == 3)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(experience.focusCompoundIds).isSubset(of: compoundIDs))
            #expect(experience.isExtraction == ["infusion", "essential_oil", "hydroalcoholic_extract"].contains(preparation.id))
        }
    }

    @Test @MainActor func gingerProfileAndStructuresAreBundled() throws {
        let document = try GingerDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Jengibre")
        #expect(profile.section1.items.count == 4)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 6)
        #expect(!document.sources.isEmpty)
        let compoundIDs = Set(profile.section2.items.map(\.id))
        let preparationIDs = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            #expect(GingerDocument.structureCID(for: compound) != nil)
            #expect(UIImage(named: "ginger_\(compound.id)") != nil)
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compoundIDs))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparationIDs))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compoundIDs))
        }
        for preparation in profile.section4.items {
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compoundIDs))
            let experience = try #require(preparation.extractionExperience)
            #expect(!experience.heading.isEmpty)
            #expect(!experience.processTitle.isEmpty)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(experience.steps.allSatisfy { !$0.detail.isEmpty })
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(experience.focusCompoundIds).isSubset(of: compoundIDs))
            #expect(experience.isExtraction == ["infusion", "essential_oil", "hydroalcoholic_extract"].contains(preparation.id))
        }
        #expect(profile.section3.featuredChemistry.title.contains("deshidratación"))
    }

    @Test @MainActor func aloeProfileAndExtractionExperiencesAreBundled() throws {
        let document = try AloeDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Aloe vera")
        #expect(profile.section1.items.count == 5)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 6)
        #expect(!document.sources.isEmpty)
        let compoundIDs = Set(profile.section2.items.map(\.id))
        let preparationIDs = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            if ["acemannan", "glucomannan"].contains(compound.id) {
                #expect(compound.molecularFormula == nil)
                #expect(compound.structureCID == nil)
                #expect(compound.smallMolecule == nil)
            } else {
                #expect(compound.structureCID != nil)
                #expect(UIImage(named: "aloe_\(compound.id)") != nil)
            }
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compoundIDs))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparationIDs))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compoundIDs))
        }
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compoundIDs))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compoundIDs))
        }
    }

    @Test @MainActor func lavenderProfileAndExtractionExperiencesAreBundled() throws {
        let document = try LavenderDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Lavanda")
        #expect(profile.section1.items.count == 5)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 7)
        #expect(!document.sources.isEmpty)
        let compoundIDs = Set(profile.section2.items.map(\.id))
        let preparationIDs = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            #expect(LavenderDocument.structureCID(for: compound) != nil)
            #expect(UIImage(named: "lavender_\(compound.id)") != nil)
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compoundIDs))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparationIDs))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compoundIDs))
        }
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compoundIDs))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compoundIDs))
            #expect(experience.isExtraction == ["infusion", "steam_oil", "hydroalcoholic"].contains(preparation.id))
        }
        #expect(profile.section3.featuredChemistry.reactionClass.contains("hidrólisis"))
    }

    @Test @MainActor func eucalyptusProfileAndExtractionExperiencesAreBundled() throws {
        let document = try EucalyptusDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Eucalipto")
        #expect(profile.section1.items.count == 5)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 7)
        #expect(!document.sources.isEmpty)
        let compounds = Set(profile.section2.items.map(\.id))
        let preparations = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            #expect(EucalyptusDocument.structureCID(for: compound) != nil)
            #expect(UIImage(named: "eucalyptus_\(compound.id)") != nil)
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compounds))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparations))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compounds))
        }
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compounds))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compounds))
            #expect(experience.isExtraction == ["infusion", "essential_oil", "hydroalcoholic"].contains(preparation.id))
        }
        #expect(profile.section3.featuredChemistry.reactionClass.contains("NO es una reacción"))
    }

    @Test @MainActor func rosemaryProfileAndExtractionExperiencesAreBundled() throws {
        let document = try RosemaryDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Romero")
        #expect(profile.section1.items.count == 5)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 5)
        #expect(profile.section4.items.count == 9)
        #expect(!document.sources.isEmpty)
        let compounds = Set(profile.section2.items.map(\.id))
        let preparations = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            #expect(RosemaryDocument.structureCID(for: compound) != nil)
            #expect(UIImage(named: "rosemary_\(compound.id)") != nil)
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compounds))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparations))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compounds))
        }
        let featured = profile.section3.featuredChemistry
        #expect(featured.interactiveSteps.map(\.index) == [1, 2, 3])
        #expect(Set(featured.compoundIds).isSubset(of: compounds))
        #expect(featured.description.contains("NO es una reacción única balanceada"))
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compounds))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compounds))
            #expect(experience.isExtraction == ["infusion", "essential_oil", "hydroalcoholic", "lipophilic", "bath"].contains(preparation.id))
        }
    }

    @Test @MainActor func turmericProfileAndExtractionExperiencesAreBundled() throws {
        let document = try TurmericDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Cúrcuma")
        #expect(profile.section1.items.count == 5)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 5)
        #expect(profile.section4.items.count == 8)
        #expect(!document.sources.isEmpty)
        let compounds = Set(profile.section2.items.map(\.id))
        let preparations = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            if compound.id == "turmerones" {
                #expect(compound.pubchemCID == nil)
            } else {
                #expect(compound.pubchemCID != nil)
                #expect(UIImage(named: "turmeric_\(compound.id)") != nil)
            }
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compounds))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparations))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compounds))
        }
        let featured = profile.section3.featuredChemistry
        #expect(featured.interactiveSteps.map(\.index) == [1, 2, 3, 4])
        #expect(Set(featured.compoundIds).isSubset(of: compounds))
        #expect(featured.equation.contains("⇌"))
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compounds))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compounds))
            #expect(experience.isExtraction == ["infusion", "essential_oil", "hydroalcoholic"].contains(preparation.id))
        }
    }

    @Test @MainActor func valerianProfileAndExtractionExperiencesAreBundled() throws {
        let document = try ValerianDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Valeriana")
        #expect(profile.section1.items.count == 4)
        #expect(profile.section2.items.count == 5)
        #expect(profile.section3.items.count == 4)
        #expect(profile.section4.items.count == 8)
        #expect(!document.sources.isEmpty)
        let compounds = Set(profile.section2.items.map(\.id))
        let preparations = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            #expect(compound.pubchemCID != nil)
            #expect(UIImage(named: "valerian_\(compound.id)") != nil)
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compounds))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparations))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compounds))
        }
        let featured = profile.section3.featuredChemistry
        #expect(featured.interactiveSteps.map(\.index) == [1, 2, 3, 4])
        #expect(Set(featured.compoundIds).isSubset(of: compounds))
        #expect(featured.products.contains { $0.contains("baldrinal") })
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compounds))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compounds))
            #expect(experience.isExtraction == ["infusion", "hydroalcoholic", "ethanolic_dry", "essential_oil", "aqueous_extract"].contains(preparation.id))
        }
    }

    @Test @MainActor func ginsengProfileAndExtractionExperiencesAreBundled() throws {
        let document = try GinsengDocument.load()
        let profile = document.plant
        #expect(profile.commonName == "Ginseng asiático")
        #expect(profile.section1.items.count == 4)
        #expect(profile.section2.items.count == 6)
        #expect(profile.section3.items.count == 5)
        #expect(profile.section4.items.count == 8)
        #expect(!document.sources.isEmpty)
        let compounds = Set(profile.section2.items.map(\.id))
        let preparations = Set(profile.section4.items.map(\.id))
        for compound in profile.section2.items {
            if compound.id == "polysaccharides" {
                #expect(compound.molecularFormula == nil)
                #expect(compound.pubchemCID == nil)
                #expect(compound.smallMolecule == nil)
            } else {
                #expect(compound.pubchemCID != nil)
                #expect(UIImage(named: "ginseng_\(compound.id)") != nil)
            }
        }
        for property in profile.section1.items {
            #expect(Set(property.relatedCompoundIds).isSubset(of: compounds))
            #expect(Set(property.relatedPreparationIds).isSubset(of: preparations))
        }
        for mechanism in profile.section3.items {
            #expect(!mechanism.steps.isEmpty)
            #expect(Set(mechanism.compoundIds).isSubset(of: compounds))
        }
        let featured = profile.section3.featuredChemistry
        #expect(featured.interactiveSteps.map(\.index) == [1, 2, 3, 4])
        #expect(featured.compoundIds == ["rb1", "rd", "rg3"])
        #expect(featured.description.contains("no conversión exclusiva"))
        for preparation in profile.section4.items {
            let experience = try #require(preparation.extractionExperience)
            #expect(experience.steps.map(\.index) == [1, 2, 3])
            #expect(!experience.chemicalPrinciples.isEmpty)
            #expect(!experience.comparisonNote.isEmpty)
            #expect(Set(preparation.highlightCompoundIds).isSubset(of: compounds))
            #expect(Set(experience.focusCompoundIds).isSubset(of: compounds))
            #expect(experience.isExtraction == ["aqueous_decoction", "infusion", "hydroalcoholic", "polysaccharide_fraction"].contains(preparation.id))
        }
    }

}
