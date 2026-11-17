//
//  NikteUITests.swift
//  NikteUITests
//
//  Created by Metzli Celeste on 21/10/26.
//

import XCTest

final class NikteUITests: XCTestCase {

    @MainActor
    func testDigestiveChamomileOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["gases"]
        XCTAssertTrue(gases.waitForExistence(timeout: 10))
        gases.tap()
        let chamomile = app.staticTexts["Manzanilla"]
        for _ in 0..<4 where !chamomile.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(chamomile.waitForExistence(timeout: 5))
        chamomile.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de manzanilla"].exists)
        XCTAssertTrue(app.staticTexts["Molestias digestivas leves"].exists)
        XCTAssertTrue(app.staticTexts["1.5–4 g"].exists)
        XCTAssertFalse(app.staticTexts["Aceite esencial"].exists)
    }

    @MainActor
    func testDigestivePeppermintOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["gases"]
        XCTAssertTrue(gases.waitForExistence(timeout: 10))
        gases.tap()
        let mint = app.staticTexts["Menta"]
        for _ in 0..<4 where !mint.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(mint.waitForExistence(timeout: 5))
        mint.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de menta"].exists)
        XCTAssertTrue(app.staticTexts["1.5–3 g"].exists)
        XCTAssertFalse(app.staticTexts["Infusión de manzanilla"].exists)
    }

    @MainActor
    func testMotionSicknessGingerOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let nausea = app.buttons["náuseas por movimiento"]
        for _ in 0..<3 where !nausea.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(nausea.waitForExistence(timeout: 10))
        nausea.tap()
        let ginger = app.staticTexts["Jengibre"]
        for _ in 0..<4 where !ginger.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(ginger.waitForExistence(timeout: 5))
        ginger.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Jengibre en polvo con agua"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
        XCTAssertFalse(app.staticTexts["Infusión de jengibre"].exists)
    }

    @MainActor
    func testMinorBurnAloeOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let burn = app.buttons["quemaduras superficiales leves"]
        for _ in 0..<4 where !burn.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(burn.waitForExistence(timeout: 10))
        burn.tap()
        let aloe = app.staticTexts["Aloe Vera"]
        for _ in 0..<5 where !aloe.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(aloe.waitForExistence(timeout: 5))
        aloe.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Gel de aloe vera para quemaduras superficiales leves"].exists)
        XCTAssertTrue(app.staticTexts["Cantidad suficiente para una capa fina"].exists)
    }

    @MainActor
    func testMildStressLavenderOpensPreparationGuide() throws {
        assertLavenderGuide(ailment: "estrés leve")
    }

    @MainActor
    func testOccasionalSleepLavenderOpensPreparationGuide() throws {
        assertLavenderGuide(ailment: "dificultad ocasional para dormir")
    }

    @MainActor
    func testColdCoughEucalyptusOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let cough = app.buttons["tos asociada al resfriado"]
        for _ in 0..<5 where !cough.isHittable { app.swipeUp() }
        XCTAssertTrue(cough.waitForExistence(timeout: 10))
        cough.tap()
        let eucalyptus = app.staticTexts["Eucalipto"]
        for _ in 0..<5 where !eucalyptus.isHittable { app.swipeUp() }
        XCTAssertTrue(eucalyptus.waitForExistence(timeout: 5))
        eucalyptus.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de hojas de eucalipto"].exists)
        XCTAssertTrue(app.staticTexts["1.5–3 g"].exists)
    }

    @MainActor
    func testDigestiveRosemaryOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let stomach = app.buttons["dolor de estómago"]
        for _ in 0..<5 where !stomach.isHittable { app.swipeUp() }
        XCTAssertTrue(stomach.waitForExistence(timeout: 10))
        stomach.tap()
        let rosemary = app.staticTexts["Romero"]
        for _ in 0..<7 where !rosemary.isHittable { app.swipeUp() }
        XCTAssertTrue(rosemary.waitForExistence(timeout: 5))
        rosemary.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de romero"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
    }

    @MainActor
    func testDigestiveTurmericOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["gases"]
        for _ in 0..<6 where !gases.isHittable { app.swipeUp() }
        XCTAssertTrue(gases.waitForExistence(timeout: 10))
        gases.tap()
        let turmeric = app.staticTexts["Cúrcuma"]
        for _ in 0..<7 where !turmeric.isHittable { app.swipeUp() }
        XCTAssertTrue(turmeric.waitForExistence(timeout: 5))
        turmeric.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de cúrcuma"].exists)
        XCTAssertTrue(app.staticTexts["0.5–1 g"].exists)
    }

    @MainActor
    func testOccasionalSleepValerianOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let sleep = app.buttons["dificultad ocasional para dormir"]
        for _ in 0..<5 where !sleep.isHittable { app.swipeUp() }
        XCTAssertTrue(sleep.waitForExistence(timeout: 10))
        sleep.tap()
        let valerian = app.staticTexts["Valeriana"]
        for _ in 0..<7 where !valerian.isHittable { app.swipeUp() }
        XCTAssertTrue(valerian.waitForExistence(timeout: 5))
        valerian.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de valeriana"].exists)
        XCTAssertTrue(app.staticTexts["0.3–3 g"].exists)
    }

    @MainActor
    func testMildFatigueGinsengOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let fatigue = app.buttons["cansancio y debilidad leves"]
        for _ in 0..<5 where !fatigue.isHittable { app.swipeUp() }
        XCTAssertTrue(fatigue.waitForExistence(timeout: 10))
        fatigue.tap()
        let ginseng = app.staticTexts["Ginseng"]
        for _ in 0..<7 where !ginseng.isHittable { app.swipeUp() }
        XCTAssertTrue(ginseng.waitForExistence(timeout: 5))
        ginseng.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Decocción de ginseng blanco"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
        XCTAssertFalse(app.staticTexts["Infusión de ginseng"].exists)
    }

    @MainActor
    private func assertLavenderGuide(ailment: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let option = app.buttons[ailment]
        for _ in 0..<4 where !option.isHittable { app.swipeUp() }
        XCTAssertTrue(option.waitForExistence(timeout: 10))
        option.tap()
        let lavender = app.staticTexts["Lavanda"]
        for _ in 0..<5 where !lavender.isHittable { app.swipeUp() }
        XCTAssertTrue(lavender.waitForExistence(timeout: 5))
        lavender.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de lavanda"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
