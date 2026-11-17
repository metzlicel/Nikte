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

}
