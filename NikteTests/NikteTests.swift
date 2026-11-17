//
//  NikteTests.swift
//  NikteTests
//
//  Created by Metzli Celeste on 21/10/26.
//

import Testing
import UIKit
@testable import Nikte

struct NikteTests {

    @Test @MainActor func chamomileDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "chamomile")
        for symptom in ["estomago", "gases"] {
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

    @Test @MainActor func peppermintDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "peppermint")
        #expect(document.plantId == "peppermint")
        #expect(document.guides(forSymptomID: "mild-digestive-discomfort").count == 1)
        #expect(document.guides(forSymptomID: "insomnia").isEmpty)
        for symptom in ["estomago", "gases"] {
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
        let mintRequest = try #require(PreparationGuideRequest.forAilment(plantMatchID: "menta", ailmentID: "gases"))
        #expect(chamomile.guide(for: mintRequest) == nil)
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
        #expect(document.guides(forSymptomID: "mild-digestive-discomfort").isEmpty)
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

    @Test @MainActor func rosemaryDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "rosemary")
        let request = try #require(PreparationGuideRequest.forAilment(plantMatchID: "romero", ailmentID: "estomago"))
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

    @Test @MainActor func turmericDigestiveGuideRoutesAndLoads() throws {
        let document = try PreparationGuideDocument.load(forPlantID: "turmeric")
        for ailment in ["estomago", "gases"] {
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
            #expect(guide.chemistry.explanation.contains("muy baja solubilidad"))
            #expect(guide.chemistry.explanation.contains("no equivale a un extracto concentrado"))
            #expect(guide.displaySafetyNote.contains("Solo adultos"))
            #expect(guide.displaySafetyNote.contains("lesión hepática"))
            #expect(!guide.references.isEmpty)
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
        #expect(guide.chemistry.explanation.contains("no equivale a un extracto estandarizado"))
        #expect(guide.displaySafetyNote.contains("somnolencia"))
        #expect(guide.displaySafetyNote.contains("sedantes"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: "insomnio") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "valeriana", ailmentID: "estres_leve") == nil)
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
        #expect(guide.chemistry.explanation.contains("difusión de ginsenósidos"))
        #expect(guide.chemistry.explanation.contains("ginseng rojo"))
        #expect(guide.displaySafetyNote.contains("anticoagulantes"))
        #expect(guide.displaySafetyNote.contains("insomnio"))
        #expect(!guide.references.isEmpty)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "ginseng", ailmentID: "insomnio") == nil)
        #expect(PreparationGuideRequest.forAilment(plantMatchID: "lavanda", ailmentID: "cansancio_debilidad_leves") == nil)
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
