//
//  NikteUITests.swift
//  NikteUITests
//
//  Created by Metzli Celeste on 21/10/26.
//

import XCTest

final class NikteUITests: XCTestCase {

    @MainActor
    func testInsomniaShowsDocumentedPreparations() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let insomnia = app.buttons["insomnio"]
        XCTAssertTrue(insomnia.waitForExistence(timeout: 10))
        insomnia.tap()
        let lavender = app.staticTexts["Lavanda"]
        for _ in 0..<6 where !lavender.isHittable { app.swipeUp() }
        XCTAssertTrue(lavender.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Manzanilla"].exists)
    }

    @MainActor
    func testLavenderSleepShowsAllMatchingGuides() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let option = app.buttons["insomnio"]
        for _ in 0..<5 where !option.isHittable { app.swipeUp() }
        XCTAssertTrue(option.waitForExistence(timeout: 10))
        option.tap()
        let lavender = app.staticTexts["Lavanda"]
        for _ in 0..<7 where !lavender.isHittable { app.swipeUp() }
        XCTAssertTrue(lavender.waitForExistence(timeout: 5))
        lavender.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de lavanda"].exists)
        let bath = app.staticTexts["Baño relajante con producto de lavanda"]
        XCTAssertTrue(bath.exists)
        bath.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Baño relajante con producto de lavanda"].exists)
    }

    @MainActor
    func testMintCompoundAndExtractionSelectorsUpdateContent() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Plantas"].tap()
        let search = app.textFields["Buscar planta..."]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText("menta")
        let mint = app.staticTexts["Menta"]
        XCTAssertTrue(mint.waitForExistence(timeout: 5))
        mint.tap()
        let composition = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "02 · Composición química")).firstMatch
        for _ in 0..<6 where !composition.isHittable { app.swipeUp() }
        XCTAssertTrue(composition.waitForExistence(timeout: 10))
        composition.tap()
        let menthol = app.buttons["Mentol"]
        for _ in 0..<5 where !menthol.isHittable { app.swipeUp() }
        XCTAssertTrue(menthol.waitForExistence(timeout: 5))
        menthol.tap()
        app.buttons["Mentona"].tap()
        XCTAssertTrue(app.buttons["Mentona"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["C10H18O"].exists)

        let extractions = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "04 · Extracciones")).firstMatch
        for _ in 0..<10 where !extractions.isHittable { app.swipeUp() }
        XCTAssertTrue(extractions.waitForExistence(timeout: 5))
        extractions.tap()
        let leaves = app.buttons["Hojas frescas o secas"]
        for _ in 0..<6 where !leaves.isHittable { app.swipeUp() }
        XCTAssertTrue(leaves.waitForExistence(timeout: 5))
        leaves.tap()
        app.buttons["Infusión de hojas"].tap()
        XCTAssertTrue(app.buttons["Infusión de hojas"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testDigestiveChamomileOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["indigestión"]
        for _ in 0..<5 where !gases.isHittable { app.swipeUp() }
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
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar los espasmos digestivos?", stage: "Señalización del Ca²⁺", detail: "El calcio participa en la contracción del músculo intestinal; ciertos extractos pueden modificar esa respuesta en laboratorio.")
    }

    @MainActor
    func testChamomileMouthRinseNavigation() {
        assertChamomileSearch(query: "inflamacion buc", option: "Inflamación bucal", title: "Enjuague de manzanilla", chemistryTitle: "¿Cómo podría aliviar la irritación bucal?", stage: "Compuestos fenólicos", detail: "Componentes de extractos de manzanilla pueden atenuar esas rutas en modelos experimentales.")
    }

    @MainActor
    func testChamomileSkinCompressNavigation() {
        assertChamomileSearch(query: "irritacion cutan", option: "Irritación cutánea", title: "Compresa de manzanilla", chemistryTitle: "¿Cómo podría aliviar la irritación de la piel?", stage: "Flavonoides", detail: "Componentes estudiados de la manzanilla pueden modular vías inflamatorias en modelos de laboratorio.")
    }

    @MainActor
    private func assertChamomileSearch(query: String, option: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(query)
        let suggestion = app.buttons[option]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        let chamomile = app.staticTexts["Manzanilla"]
        for _ in 0..<7 where !chamomile.isHittable { app.swipeUp() }
        XCTAssertTrue(chamomile.waitForExistence(timeout: 5))
        chamomile.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    private func assertChemistryInteraction(app: XCUIApplication, title: String, stage: String, detail: String) {
        let button = app.buttons[stage]
        for _ in 0..<10 where !button.isHittable { app.swipeUp() }
        XCTAssertTrue(app.staticTexts[title].exists)
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        let detailText = app.staticTexts.matching(NSPredicate(format: "label == %@", detail)).firstMatch
        XCTAssertTrue(detailText.waitForExistence(timeout: 5))
    }

    @MainActor
    func testDigestivePeppermintOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["indigestión"]
        for _ in 0..<5 where !gases.isHittable { app.swipeUp() }
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
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar las molestias digestivas?", stage: "Mentol y señalización", detail: "El mentol puede limitar corrientes de Ca²⁺ en modelos de músculo liso; la cantidad presente en el té es variable.")
    }

    @MainActor
    func testPeppermintIBSCapsulesNavigation() {
        assertPeppermintSearch(query: "dolor abdominal por", option: "Dolor abdominal por intestino irritable", title: "Cápsulas entéricas de aceite de menta", chemistryTitle: "¿Cómo puede disminuir los espasmos intestinales?", stage: "Acción del mentol", detail: "Puede disminuir corrientes de Ca²⁺ y la intensidad de ciertas contracciones.")
    }

    @MainActor
    func testPeppermintTensionHeadacheNavigation() {
        assertPeppermintSearch(query: "cefalea tension", option: "Cefalea tensional", title: "Preparado tópico de menta para cefalea tensional", chemistryTitle: "¿Cómo podría aliviar la cefalea tensional?", stage: "Señal nerviosa", detail: "TRPM8 permite el flujo de cationes y desencadena sensación de frescura.")
    }

    @MainActor
    private func assertPeppermintSearch(query: String, option: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(query)
        let suggestion = app.buttons[option]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        let mint = app.staticTexts["Menta"]
        for _ in 0..<7 where !mint.isHittable { app.swipeUp() }
        XCTAssertTrue(mint.waitForExistence(timeout: 5))
        mint.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    func testMotionSicknessGingerOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let nausea = app.buttons["mareo por viaje"]
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
        assertChemistryInteraction(app: app, title: "¿Cómo podría influir en las náuseas por viaje?", stage: "Gingeroles y shogaoles", detail: "En experimentos pueden disminuir la activación de determinados receptores 5-HT₃.")
    }

    @MainActor
    func testGingerDigestiveDrinkNavigation() {
        assertGingerSearch(query: "indigest", option: "Indigestión", title: "Bebida tibia de jengibre con miel (limón opcional)", chemistryTitle: "¿Cómo podría ayudar con la digestión?", stage: "Compuestos del jengibre", detail: "Gingeroles y otros constituyentes se han estudiado por su acción sobre señalización gastrointestinal.")
    }

    @MainActor
    func testGingerMenstrualCapsulesNavigation() {
        assertGingerSearch(query: "dolor menstru", option: "Dolor menstrual", title: "Cápsulas comerciales de jengibre", chemistryTitle: "¿Cómo podría influir en los cólicos?", stage: "Gingeroles y shogaoles", detail: "En modelos experimentales pueden modular procesos relacionados con COX y síntesis de prostaglandinas.")
    }

    @MainActor
    private func assertGingerSearch(query: String, option: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(query)
        let suggestion = app.buttons[option]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        let ginger = app.staticTexts["Jengibre"]
        for _ in 0..<7 where !ginger.isHittable { app.swipeUp() }
        XCTAssertTrue(ginger.waitForExistence(timeout: 5))
        ginger.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    func testMinorBurnAloeOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let burn = app.buttons["quemaduras"]
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
        assertChemistryInteraction(app: app, title: "¿Cómo podría ayudar a reparar una quemadura leve?", stage: "Acemanano y células reparadoras", detail: "En estudios preclínicos, el acemanano favorece respuestas de fibroblastos y señales asociadas con reparación tisular.")
    }

    @MainActor
    func testDiagnosedPsoriasisAloeCreamNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText("psoriasis")
        let option = app.buttons["Psoriasis diagnosticada"]
        XCTAssertTrue(option.waitForExistence(timeout: 5))
        option.tap()
        let aloe = app.staticTexts["Aloe Vera"]
        for _ in 0..<7 where !aloe.isHittable { app.swipeUp() }
        XCTAssertTrue(aloe.waitForExistence(timeout: 5))
        aloe.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Crema con aloe vera para placas de psoriasis leve"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría influir sobre la irritación de las placas?", stage: "Componentes del aloe", detail: "La matriz hidratante puede aliviar resequedad; se investigan efectos sobre mediadores inflamatorios.")
    }

    @MainActor
    func testMildStressLavenderOpensPreparationGuide() throws {
        assertLavenderGuide(ailment: "estrés")
    }

    @MainActor
    func testOccasionalSleepLavenderOpensPreparationGuide() throws {
        assertLavenderGuide(ailment: "insomnio")
    }

    @MainActor
    func testLavenderAnxietyCapsulesNavigation() {
        assertLavenderSearch(query: "ansied", option: "Ansiedad", title: "Cápsulas de aceite de lavanda estandarizado", chemistryTitle: "¿Cómo podría disminuir la ansiedad?", stage: "Aceite estandarizado", detail: "En modelos experimentales modula determinados canales de Ca²⁺ dependientes de voltaje.")
    }

    @MainActor
    func testLavenderBathNavigation() {
        assertLavenderSearch(query: "agotamien", option: "Agotamiento", title: "Baño relajante con producto de lavanda", chemistryTitle: "¿Cómo podría favorecer una sensación de calma?", stage: "Receptores olfativos", detail: "La unión de odorantes activa señales nerviosas que el cerebro interpreta como aroma.")
    }

    @MainActor
    private func assertLavenderSearch(query: String, option: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(query)
        let suggestion = app.buttons[option]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        let lavender = app.staticTexts["Lavanda"]
        for _ in 0..<7 where !lavender.isHittable { app.swipeUp() }
        XCTAssertTrue(lavender.waitForExistence(timeout: 5))
        lavender.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    func testColdCoughEucalyptusOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let cough = app.buttons["tos"]
        for _ in 0..<5 where !cough.isHittable { app.swipeUp() }
        XCTAssertTrue(cough.waitForExistence(timeout: 10))
        cough.tap()
        let eucalyptus = app.staticTexts["Eucalipto"]
        for _ in 0..<5 where !eucalyptus.isHittable { app.swipeUp() }
        XCTAssertTrue(eucalyptus.waitForExistence(timeout: 5))
        eucalyptus.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Ungüento torácico con eucalipto (producto formulado)"].exists)
        app.staticTexts["Infusión de hojas de eucalipto"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de hojas de eucalipto"].exists)
        XCTAssertTrue(app.staticTexts["1.5–3 g"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar la tos del resfriado?", stage: "1,8-cineol", detail: "En estudios experimentales puede modular señales inflamatorias y procesos de secreción de mucinas.")
    }

    @MainActor
    func testColdCoughEucalyptusOintmentNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let cough = app.buttons["tos"]
        for _ in 0..<5 where !cough.isHittable { app.swipeUp() }
        XCTAssertTrue(cough.waitForExistence(timeout: 10))
        cough.tap()
        let eucalyptus = app.staticTexts["Eucalipto"]
        for _ in 0..<5 where !eucalyptus.isHittable { app.swipeUp() }
        XCTAssertTrue(eucalyptus.waitForExistence(timeout: 5))
        eucalyptus.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        app.staticTexts["Ungüento torácico con eucalipto (producto formulado)"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Ungüento torácico con eucalipto (producto formulado)"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar la tos?", stage: "1,8-cineol", detail: "En estudios preclínicos modula mediadores inflamatorios y procesos asociados a mucinas.")
    }

    @MainActor
    func testEucalyptusMuscleOintmentNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText("dolor musc")
        let option = app.buttons["Dolor muscular"]
        XCTAssertTrue(option.waitForExistence(timeout: 5))
        option.tap()
        let eucalyptus = app.staticTexts["Eucalipto"]
        for _ in 0..<7 where !eucalyptus.isHittable { app.swipeUp() }
        XCTAssertTrue(eucalyptus.waitForExistence(timeout: 5))
        eucalyptus.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Ungüento de eucalipto para dolor muscular localizado"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar el dolor muscular?", stage: "Cineol y mediadores", detail: "En modelos experimentales el 1,8-cineol modifica ciertas respuestas inflamatorias.")
    }

    @MainActor
    func testDigestiveRosemaryOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let stomach = app.buttons["indigestión"]
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
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar las molestias digestivas?", stage: "Componentes del romero", detail: "Extractos de la planta muestran actividad espasmolítica en ciertos ensayos preclínicos; no se atribuye el efecto a una molécula única.")
    }

    @MainActor
    func testRosemaryMuscleBathNavigation() {
        assertRosemarySelection(query: "dolor musc", option: "Dolor muscular", title: "Baño con hojas de romero", chemistryTitle: "¿Cómo podría aliviar músculos y articulaciones?", stage: "Compuestos fenólicos del romero", detail: "En estudios experimentales, algunos modulan NF-κB y procesos vinculados a la inflamación; no se ha verificado este efecto con el baño.")
    }

    @MainActor
    func testRosemaryJointOintmentNavigation() {
        assertRosemarySelection(query: "dolor articul", option: "Dolor articular", title: "Crema o ungüento de romero", chemistryTitle: "¿Cómo podría aliviar las molestias musculares?", stage: "Monoterpenos del romero", detail: "Compuestos como el 1,8-cineol y el alcanfor han mostrado acciones biológicas en modelos experimentales.")
    }

    @MainActor
    private func assertRosemarySelection(query: String, option: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(query)
        let suggestion = app.buttons[option]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        let rosemary = app.staticTexts["Romero"]
        for _ in 0..<7 where !rosemary.isHittable { app.swipeUp() }
        XCTAssertTrue(rosemary.waitForExistence(timeout: 5))
        rosemary.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Baño con hojas de romero"].exists)
        XCTAssertTrue(app.staticTexts["Crema o ungüento de romero"].exists)
        app.staticTexts[title].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    func testRosemaryTiredLegsBathNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let search = app.textFields["¿Qué malestar tienes?"]
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText("piernas cansad")
        let option = app.buttons["Piernas cansadas"]
        XCTAssertTrue(option.waitForExistence(timeout: 5))
        option.tap()
        let rosemary = app.staticTexts["Romero"]
        for _ in 0..<7 where !rosemary.isHittable { app.swipeUp() }
        XCTAssertTrue(rosemary.waitForExistence(timeout: 5))
        rosemary.tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Baño con hojas de romero"].exists)
    }

    @MainActor
    func testDigestiveTurmericOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let gases = app.buttons["indigestión"]
        for _ in 0..<6 where !gases.isHittable { app.swipeUp() }
        XCTAssertTrue(gases.waitForExistence(timeout: 10))
        gases.tap()
        let turmeric = app.staticTexts["Cúrcuma"]
        for _ in 0..<7 where !turmeric.isHittable { app.swipeUp() }
        XCTAssertTrue(turmeric.waitForExistence(timeout: 5))
        turmeric.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Cúrcuma seca en polvo con alimentos"].exists)
        app.staticTexts["Infusión de cúrcuma"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de cúrcuma"].exists)
        XCTAssertTrue(app.staticTexts["0.5–1 g"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría aliviar la pesadez digestiva?", stage: "Compuestos del rizoma", detail: "Componentes de la cúrcuma se estudian por su influencia en funciones digestivas y secreción biliar; la infusión extrae cantidades variables.")
    }

    @MainActor
    func testDigestiveTurmericPowderNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let stomach = app.buttons["indigestión"]
        for _ in 0..<6 where !stomach.isHittable { app.swipeUp() }
        XCTAssertTrue(stomach.waitForExistence(timeout: 10))
        stomach.tap()
        let turmeric = app.staticTexts["Cúrcuma"]
        for _ in 0..<8 where !turmeric.isHittable { app.swipeUp() }
        XCTAssertTrue(turmeric.waitForExistence(timeout: 5))
        turmeric.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de cúrcuma"].exists)
        app.staticTexts["Cúrcuma seca en polvo con alimentos"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Cúrcuma seca en polvo con alimentos"].exists)
        assertChemistryInteraction(app: app, title: "¿Por qué se investiga para la digestión?", stage: "Constituyentes de cúrcuma", detail: "Curcuminoides y otros compuestos se investigan en modelos de fisiología digestiva; no hay un mecanismo clínico único confirmado.")
        let warning = app.staticTexts["No sustituir con suplementos concentrados o con piperina: algunos se han asociado con lesión hepática."]
        for _ in 0..<6 where !warning.isHittable { app.swipeUp() }
        XCTAssertTrue(warning.exists)
    }

    @MainActor
    func testOccasionalSleepValerianOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let sleep = app.buttons["insomnio"]
        for _ in 0..<5 where !sleep.isHittable { app.swipeUp() }
        XCTAssertTrue(sleep.waitForExistence(timeout: 10))
        sleep.tap()
        let valerian = app.staticTexts["Valeriana"]
        for _ in 0..<7 where !valerian.isHittable { app.swipeUp() }
        XCTAssertTrue(valerian.waitForExistence(timeout: 5))
        valerian.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de valeriana y melisa"].exists)
        XCTAssertTrue(app.staticTexts["Cápsulas de extracto seco de valeriana"].exists)
        app.staticTexts["Infusión de valeriana"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de valeriana"].exists)
        XCTAssertTrue(app.staticTexts["0.3–3 g"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría favorecer el sueño?", stage: "Receptor GABA-A", detail: "En experimentos, el ácido valerénico modula receptores activados por GABA, relacionados con la inhibición neuronal.")
    }

    @MainActor
    func testValerianMelissaStressNavigation() {
        assertValerianSelection(ailment: "estrés leve", title: "Infusión de valeriana y melisa", chemistryTitle: "¿Cómo podría disminuir la tensión nerviosa?", stage: "Sistema GABA", detail: "El GABA participa en la inhibición de la actividad neuronal; diversos extractos se estudian por su interacción con este sistema.")
    }

    @MainActor
    func testValerianExtractSleepNavigation() {
        assertValerianSelection(ailment: "dificultad ocasional para dormir", title: "Cápsulas de extracto seco de valeriana", chemistryTitle: "¿Cómo puede intervenir en la regulación del sueño?", stage: "Modulación GABA-A", detail: "El ácido valerénico puede afectar la respuesta del receptor GABA-A en modelos experimentales.")
    }

    @MainActor
    private func assertValerianSelection(ailment: String, title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let option = app.buttons[ailment]
        for _ in 0..<5 where !option.isHittable { app.swipeUp() }
        XCTAssertTrue(option.waitForExistence(timeout: 10))
        option.tap()
        let valerian = app.staticTexts["Valeriana"]
        for _ in 0..<7 where !valerian.isHittable { app.swipeUp() }
        XCTAssertTrue(valerian.waitForExistence(timeout: 5))
        valerian.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de valeriana y melisa"].exists)
        XCTAssertTrue(app.staticTexts["Cápsulas de extracto seco de valeriana"].exists)
        app.staticTexts[title].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
    }

    @MainActor
    func testMildFatigueGinsengOpensPreparationGuide() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let fatigue = app.buttons["cansancio"]
        for _ in 0..<5 where !fatigue.isHittable { app.swipeUp() }
        XCTAssertTrue(fatigue.waitForExistence(timeout: 10))
        fatigue.tap()
        let ginseng = app.staticTexts["Ginseng"]
        for _ in 0..<7 where !ginseng.isHittable { app.swipeUp() }
        XCTAssertTrue(ginseng.waitForExistence(timeout: 5))
        ginseng.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Ginseng blanco en polvo con yogur o miel"].exists)
        XCTAssertTrue(app.staticTexts["Cápsulas de extracto estandarizado de ginseng"].exists)
        app.staticTexts["Decocción de ginseng blanco"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Decocción de ginseng blanco"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
        XCTAssertFalse(app.staticTexts["Infusión de ginseng"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría influir en el cansancio?", stage: "Ginsenósidos y señalización", detail: "En modelos experimentales, ginsenósidos como Rg1 y Rb1 pueden modular rutas relacionadas con la función mitocondrial y las defensas antioxidantes.")
    }

    @MainActor
    func testGinsengPowderFoodNavigation() {
        assertGinsengSelection(title: "Ginseng blanco en polvo con yogur o miel", chemistryTitle: "¿Qué relación tienen los ginsenósidos con la energía?", stage: "Ginsenósidos", detail: "En experimentos, algunos ginsenósidos modulan procesos vinculados con actividad mitocondrial y estrés oxidativo.")
    }

    @MainActor
    func testGinsengStandardizedExtractNavigation() {
        assertGinsengSelection(title: "Cápsulas de extracto estandarizado de ginseng", chemistryTitle: "¿Cómo podrían actuar los ginsenósidos del extracto?", stage: "Ginsenósidos del extracto", detail: "Compuestos como Rg1 y Rb1 muestran modulación de rutas de energía y antioxidación en estudios preclínicos.")
    }

    @MainActor
    private func assertGinsengSelection(title: String, chemistryTitle: String, stage: String, detail: String) {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Malestares"].tap()
        let fatigue = app.buttons["cansancio"]
        for _ in 0..<5 where !fatigue.isHittable { app.swipeUp() }
        XCTAssertTrue(fatigue.waitForExistence(timeout: 10))
        fatigue.tap()
        let ginseng = app.staticTexts["Ginseng"]
        for _ in 0..<7 where !ginseng.isHittable { app.swipeUp() }
        XCTAssertTrue(ginseng.waitForExistence(timeout: 5))
        ginseng.tap()
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Decocción de ginseng blanco"].exists)
        XCTAssertTrue(app.staticTexts["Ginseng blanco en polvo con yogur o miel"].exists)
        XCTAssertTrue(app.staticTexts["Cápsulas de extracto estandarizado de ginseng"].exists)
        app.staticTexts[title].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts[title].exists)
        assertChemistryInteraction(app: app, title: chemistryTitle, stage: stage, detail: detail)
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
        XCTAssertTrue(app.navigationBars["Preparaciones"].waitForExistence(timeout: 10))
        app.staticTexts["Infusión de lavanda"].tap()
        XCTAssertTrue(app.navigationBars["Guía de preparación"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Infusión de lavanda"].exists)
        XCTAssertTrue(app.staticTexts["1–2 g"].exists)
        assertChemistryInteraction(app: app, title: "¿Cómo podría favorecer la relajación?", stage: "Terpenos de lavanda", detail: "El linalool se investiga por su capacidad de modular la señalización neuronal, principalmente en modelos experimentales.")
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
