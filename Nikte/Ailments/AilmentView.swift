import SwiftUI

// MARK: - 09 · BUSCAR POR MALESTARES

// MARK: - 09.1 · MODELOS

struct AilmentOption: Identifiable {
    let id: String
    let name: String
    let matches: [PlantMatch]
}

struct PlantMatch: Identifiable {
    let id: String
    let plantName: String
    let description: String
}


// MARK: - 09.2 · DATOS DE MALESTARES

private let ailmentOptions: [AilmentOption] = [

    AilmentOption(
        id: "ansiedad",
        name: "Ansiedad",
        matches: [
            PlantMatch(
                id: "lavanda",
                plantName: "Lavanda",
                description: "Se estudian sus posibles efectos sobre la ansiedad."
            ),
            PlantMatch(
                id: "manzanilla",
                plantName: "Manzanilla",
                description: "Contiene apigenina, investigada por su interacción con GABA-A."
            )
        ]
    ),

    AilmentOption(
        id: "colicos",
        name: "Cólicos",
        matches: [
            PlantMatch(
                id: "manzanilla",
                plantName: "Manzanilla",
                description: "Actividad antiespasmódica investigada experimentalmente."
            ),
            PlantMatch(
                id: "menta",
                plantName: "Menta",
                description: "El aceite de menta se ha estudiado para espasmos intestinales."
            )
        ]
    ),

    AilmentOption(
        id: "congestion",
        name: "Congestión nasal",
        matches: []
    ),

    AilmentOption(
        id: "cabeza",
        name: "Dolor de cabeza",
        matches: []
    ),

    AilmentOption(
        id: "estomago",
        name: "Dolor de estómago",
        matches: [
            PlantMatch(
                id: "manzanilla",
                plantName: "Manzanilla",
                description: "Uso tradicional para molestias digestivas leves."
            ),
            PlantMatch(
                id: "menta",
                plantName: "Menta",
                description: "Algunas preparaciones se estudian para síntomas digestivos."
            ),
            PlantMatch(
                id: "romero",
                plantName: "Romero",
                description: "Infusión de hojas para molestias digestivas leves, de uso tradicional."
            ),
            PlantMatch(
                id: "curcuma",
                plantName: "Cúrcuma",
                description: "Infusión o cúrcuma en polvo con alimentos para molestias digestivas leves."
            ),
            PlantMatch(
                id: "jengibre",
                plantName: "Jengibre",
                description: "Bebida tibia de jengibre en polvo para molestias digestivas leves, de uso tradicional."
            )
        ]
    ),

    AilmentOption(
        id: "gases",
        name: "Gases",
        matches: [
            PlantMatch(
                id: "menta",
                plantName: "Menta",
                description: "Uso tradicional relacionado con molestias digestivas."
            ),
            PlantMatch(
                id: "manzanilla",
                plantName: "Manzanilla",
                description: "Uso tradicional para molestias gastrointestinales leves."
            ),
            PlantMatch(
                id: "curcuma",
                plantName: "Cúrcuma",
                description: "Infusión o cúrcuma en polvo con alimentos para gases leves."
            ),
            PlantMatch(
                id: "jengibre",
                plantName: "Jengibre",
                description: "Bebida tibia de jengibre en polvo para gases, de uso tradicional."
            )
        ]
    ),

    AilmentOption(
        id: "insomnio",
        name: "Insomnio",
        matches: [
            PlantMatch(
                id: "lavanda",
                plantName: "Lavanda",
                description: "Se ha investigado su relación con el sueño y la relajación."
            ),
            PlantMatch(
                id: "manzanilla",
                plantName: "Manzanilla",
                description: "La apigenina presenta interacciones moleculares investigadas con GABA-A."
            )
        ]
    ),

    AilmentOption(
        id: "nauseas",
        name: "Náuseas",
        matches: [
            PlantMatch(
                id: "jengibre",
                plantName: "Jengibre",
                description: "Los gingeroles y shogaoles se investigan por su actividad antiemética."
            )
        ]
    ),

    AilmentOption(
        id: "nauseas_movimiento",
        name: "Náuseas por movimiento",
        matches: [
            PlantMatch(
                id: "jengibre",
                plantName: "Jengibre",
                description: "Preparación de rizoma seco pulverizado para náuseas por movimiento."
            )
        ]
    ),

    AilmentOption(
        id: "quemaduras_superficiales_leves",
        name: "Quemaduras superficiales leves",
        matches: [
            PlantMatch(
                id: "aloe_vera",
                plantName: "Aloe Vera",
                description: "Gel interno purificado, formulado para aplicación cutánea."
            )
        ]
    ),

    AilmentOption(
        id: "estres_leve",
        name: "Estrés leve",
        matches: [
            PlantMatch(
                id: "lavanda",
                plantName: "Lavanda",
                description: "Infusión de flores para estrés leve, de uso tradicional."
            ),
            PlantMatch(
                id: "valeriana",
                plantName: "Valeriana",
                description: "Mezcla de valeriana con melisa o extracto seco comercial para tensión leve."
            )
        ]
    ),

    AilmentOption(
        id: "dificultad_ocasional_dormir",
        name: "Dificultad ocasional para dormir",
        matches: [
            PlantMatch(
                id: "lavanda",
                plantName: "Lavanda",
                description: "Infusión de flores como ayuda tradicional para dormir."
            ),
            PlantMatch(
                id: "valeriana",
                plantName: "Valeriana",
                description: "Infusiones o extracto seco comercial de valeriana para dificultad ocasional para dormir."
            )
        ]
    ),

    AilmentOption(
        id: "tos_resfriado",
        name: "Tos asociada al resfriado",
        matches: [
            PlantMatch(
                id: "eucalipto",
                plantName: "Eucalipto",
                description: "Infusión de hojas o ungüento torácico comercial para tos asociada al resfriado."
            )
        ]
    ),

    AilmentOption(
        id: "tension_nerviosa_leve", name: "Tensión nerviosa leve",
        matches: [PlantMatch(id: "valeriana", plantName: "Valeriana", description: "Mezcla de valeriana con melisa o extracto seco comercial para tensión leve.")]
    ),

    AilmentOption(
        id: "dolor_muscular_localizado_leve", name: "Dolor muscular localizado leve",
        matches: [
            PlantMatch(id: "eucalipto", plantName: "Eucalipto", description: "Ungüento comercial de eucalipto para uso cutáneo en dolor muscular localizado."),
            PlantMatch(id: "romero", plantName: "Romero", description: "Baño de hojas o preparado cutáneo comercial de romero para molestias musculares leves.")
        ]
    ),
    AilmentOption(
        id: "dolor_muscular_leve", name: "Dolor muscular leve",
        matches: [PlantMatch(id: "romero", plantName: "Romero", description: "Baño de hojas o preparado cutáneo comercial de romero para molestias musculares leves.")]
    ),
    AilmentOption(
        id: "molestias_articulares_leves", name: "Molestias articulares leves",
        matches: [PlantMatch(id: "romero", plantName: "Romero", description: "Baño de hojas o preparado cutáneo comercial de romero para molestias articulares leves.")]
    ),
    AilmentOption(
        id: "piernas_cansadas_leves", name: "Piernas cansadas sin signos de alarma",
        matches: [PlantMatch(id: "romero", plantName: "Romero", description: "Baño de hojas de romero para sensación leve de piernas cansadas.")]
    ),

    AilmentOption(
        id: "sintomas_ansiedad_leve", name: "Síntomas leves de ansiedad",
        matches: [PlantMatch(id: "lavanda", plantName: "Lavanda", description: "Cápsulas comerciales de aceite de lavanda estandarizado para uso oral.")]
    ),
    AilmentOption(
        id: "estres_leve_agotamiento", name: "Estrés leve y agotamiento",
        matches: [PlantMatch(id: "lavanda", plantName: "Lavanda", description: "Baño con producto comercial de lavanda para uso externo.")]
    ),
    AilmentOption(
        id: "agotamiento_leve", name: "Agotamiento leve",
        matches: [PlantMatch(id: "lavanda", plantName: "Lavanda", description: "Baño con producto comercial de lavanda para uso externo.")]
    ),

    AilmentOption(
        id: "psoriasis_leve_diagnosticada", name: "Psoriasis leve diagnosticada",
        matches: [PlantMatch(id: "aloe_vera", plantName: "Aloe Vera", description: "Crema comercial con aloe como complemento para psoriasis leve diagnosticada.")]
    ),
    AilmentOption(
        id: "placas_psoriasis_diagnosticada", name: "Placas localizadas de psoriasis diagnosticada",
        matches: [PlantMatch(id: "aloe_vera", plantName: "Aloe Vera", description: "Crema comercial con aloe como complemento para psoriasis leve diagnosticada.")]
    ),

    AilmentOption(
        id: "indigestion_leve", name: "Indigestión leve",
        matches: [PlantMatch(id: "jengibre", plantName: "Jengibre", description: "Bebida tibia de jengibre en polvo, de uso tradicional.")]
    ),
    AilmentOption(
        id: "hinchazon_abdominal", name: "Hinchazón abdominal",
        matches: [PlantMatch(id: "jengibre", plantName: "Jengibre", description: "Bebida tibia de jengibre en polvo, de uso tradicional.")]
    ),
    AilmentOption(
        id: "colicos_menstruales_leves", name: "Cólicos menstruales leves",
        matches: [PlantMatch(id: "jengibre", plantName: "Jengibre", description: "Cápsulas comerciales de jengibre para dolor menstrual.")]
    ),
    AilmentOption(
        id: "dolor_menstrual_primario", name: "Dolor menstrual primario",
        matches: [PlantMatch(id: "jengibre", plantName: "Jengibre", description: "Cápsulas comerciales de jengibre para dolor menstrual.")]
    ),

    AilmentOption(
        id: "sindrome_intestino_irritable", name: "Síndrome de intestino irritable",
        matches: [PlantMatch(id: "menta", plantName: "Menta", description: "Cápsulas comerciales entéricas de aceite de menta para síntomas del SII.")]
    ),
    AilmentOption(
        id: "dolor_abdominal_sii", name: "Dolor abdominal asociado al síndrome de intestino irritable",
        matches: [PlantMatch(id: "menta", plantName: "Menta", description: "Cápsulas comerciales entéricas de aceite de menta para síntomas del SII.")]
    ),
    AilmentOption(
        id: "espasmos_intestinales_sii", name: "Espasmos intestinales asociados al síndrome de intestino irritable",
        matches: [PlantMatch(id: "menta", plantName: "Menta", description: "Cápsulas comerciales entéricas de aceite de menta para síntomas del SII.")]
    ),
    AilmentOption(
        id: "cefalea_tensional_leve", name: "Cefalea tensional leve",
        matches: [PlantMatch(id: "menta", plantName: "Menta", description: "Preparado tópico comercial de menta para cefalea tensional leve.")]
    ),

    AilmentOption(
        id: "inflamacion_bucal_leve", name: "Inflamación bucal leve",
        matches: [PlantMatch(id: "manzanilla", plantName: "Manzanilla", description: "Enjuague de manzanilla para uso bucal; no tragar.")]
    ),
    AilmentOption(
        id: "aftas_pequenas", name: "Pequeñas aftas",
        matches: [PlantMatch(id: "manzanilla", plantName: "Manzanilla", description: "Enjuague de manzanilla para uso bucal; no tragar.")]
    ),
    AilmentOption(
        id: "irritacion_garganta_leve", name: "Irritación leve de garganta",
        matches: [PlantMatch(id: "manzanilla", plantName: "Manzanilla", description: "Enjuague de manzanilla para boca y garganta; no tragar.")]
    ),
    AilmentOption(
        id: "irritacion_cutanea_leve", name: "Irritación cutánea leve",
        matches: [PlantMatch(id: "manzanilla", plantName: "Manzanilla", description: "Compresa de manzanilla para pequeñas zonas de piel intacta.")]
    ),
    AilmentOption(
        id: "quemadura_solar_leve", name: "Quemadura solar leve sin ampollas",
        matches: [PlantMatch(id: "manzanilla", plantName: "Manzanilla", description: "Compresa de manzanilla para pequeñas zonas de piel intacta.")]
    ),

    AilmentOption(
        id: "cansancio_debilidad_leves",
        name: "Cansancio y debilidad leves",
        matches: [
            PlantMatch(
                id: "ginseng",
                plantName: "Ginseng",
                description: "Decocción, polvo de raíz blanca o extracto comercial para cansancio y debilidad leves."
            )
        ]
    )
]


// MARK: =============================================
// MARK: - 09.3 · VISTA PRINCIPAL
// MARK: =============================================

struct AilmentView: View {

    @State private var searchText = ""
    @State private var selectedID: String?
    @FocusState private var searchFocused: Bool
    @State private var showDropdown = false


    private let frequentIDs = [
        "insomnio",
        "ansiedad",
        "estres_leve",
        "dificultad_ocasional_dormir",
        "tos_resfriado",
        "cansancio_debilidad_leves",
        "nauseas",
        "nauseas_movimiento",
        "quemaduras_superficiales_leves",
        "cabeza",
        "estomago",
        "gases"
    ]

    // MARK: - Normalización de búsqueda

    private func normalize(_ text: String) -> String {
        text.folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_MX")
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Sugerencias del buscador

    private var suggestions: [AilmentOption] {

        let query = normalize(searchText)

        guard !query.isEmpty else {
            return []
        }

        return ailmentOptions
            .filter {
                normalize($0.name).contains(query)
            }
            .sorted {
                $0.name.localizedStandardCompare($1.name)
                    == .orderedAscending
            }
    }

    // MARK: - Malestar seleccionado

    private var selectedAilment: AilmentOption? {

        if let selectedID {
            return ailmentOptions.first {
                $0.id == selectedID
            }
        }

        return ailmentOptions.first {
            normalize($0.name) == normalize(searchText)
        }
    }

    // MARK: - Seleccionar malestar

    private func selectAilment(_ ailment: AilmentOption) {

        searchText = ailment.name
        selectedID = ailment.id

        searchFocused = false
        showDropdown = false
    }

    // MARK: - Limpiar búsqueda

    private func clearSearch() {

        searchText = ""
        selectedID = nil

        searchFocused = false
        showDropdown = false
    }
    
    // MARK: - Body

    var body: some View {

        ZStack {

            BotanicalBackground()
                .allowsHitTesting(false)

            ScrollView(.vertical, showsIndicators: true) {

                VStack(spacing: 0) {

                    // MARK: - ENCABEZADO VINTAGE

                    // Reutiliza el mismo encabezado del glosario.
                    BotanicalHeaderView()

                    // MARK: - CONTENIDO PRINCIPAL

                    VStack(alignment: .leading, spacing: 22) {

                        // MARK: - TÍTULO

                        Text("Buscar por malestar")
                            .font(
                                .system(
                                    size: 32,
                                    weight: .semibold,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(Palette.olive)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )

                        // MARK: - BUSCADOR

                        searchBar

                        // MARK: - DROPDOWN Y SUGERENCIAS

                        if showDropdown {

                            ailmentDropdown

                        } else if searchFocused &&
                                    !searchText.isEmpty &&
                                    selectedAilment == nil {

                            suggestionsView
                        }

                        // MARK: - MALESTARES FRECUENTES

                        frequentAilments

                        // MARK: - RESULTADOS DE PLANTAS

                        if let selectedAilment {

                            resultsView(for: selectedAilment)

                        } else if !searchText.isEmpty &&
                                    suggestions.isEmpty {

                            emptySearchView
                        }

                        // MARK: - ILUSTRACIÓN DEL LIBRO

                        AilmentIllustrationView()
                            .padding(.top, 12)
                            .padding(.bottom, 8)

                        // MARK: - NOTA INFORMATIVA

                        Text(
                            "Las relaciones entre plantas y malestares son informativas. No representan un diagnóstico ni una recomendación de tratamiento."
                        )
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(Palette.brown)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: =========================================
    // MARK: - 09.4 · BARRA DE BÚSQUEDA + DROPDOWN
    // MARK: =========================================

    private var searchBar: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(Palette.olive)

            TextField(
                "¿Qué malestar tienes?",
                text: $searchText
            )
            .font(.system(size: 17, design: .serif))
            .foregroundStyle(Palette.ink)
            .focused($searchFocused)
            .autocorrectionDisabled()
            .submitLabel(.search)

            .onChange(of: searchText) { _, newValue in

                if let selectedID,
                   let ailment = ailmentOptions.first(
                    where: { $0.id == selectedID }
                   ),
                   normalize(newValue) != normalize(ailment.name) {

                    self.selectedID = nil
                }
            }

            .onSubmit {
                if let first = suggestions.first {
                    selectAilment(first)
                }
            }

            // Limpiar búsqueda
            if !searchText.isEmpty {

                Button {
                    clearSearch()
                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Palette.brown)
                }
                .accessibilityLabel("Limpiar búsqueda")
            }

            // Abrir o cerrar dropdown
            Button {

                searchFocused = false

                withAnimation(.easeInOut(duration: 0.2)) {
                    showDropdown.toggle()
                }

            } label: {

                Image(
                    systemName: showDropdown
                        ? "chevron.up"
                        : "chevron.down"
                )
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Palette.olive)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                showDropdown
                    ? "Cerrar lista de malestares"
                    : "Mostrar todos los malestares"
            )
        }
        .padding(18)
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    showDropdown || searchFocused
                        ? Palette.olive
                        : Palette.brown.opacity(0.4),
                    lineWidth: showDropdown || searchFocused ? 2 : 1
                )
        )
        .shadow(
            color: Palette.brown.opacity(0.08),
            radius: 8,
            y: 4
        )
    }

    // MARK: =========================================
    // MARK: - 09.5 · SUGERENCIAS DESPLEGABLES
    // MARK: =========================================

    private var suggestionsView: some View {

        VStack(alignment: .leading, spacing: 0) {

            if suggestions.isEmpty {

                Text("No encontramos ese malestar")
                    .font(.system(size: 15, design: .serif))
                    .foregroundStyle(Palette.brown)
                    .padding(16)

            } else {

                ForEach(suggestions) { ailment in

                    Button {

                        selectAilment(ailment)

                    } label: {

                        HStack {

                            Text(ailment.name)
                                .font(.system(
                                    size: 16,
                                    design: .serif
                                ))

                            Spacer()

                            Image(systemName: "arrow.up.left")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(Palette.ink)
                        .padding(15)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if ailment.id != suggestions.last?.id {

                        Divider()
                            .overlay(
                                Palette.brown.opacity(0.2)
                            )
                    }
                }
            }
        }
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Palette.line, lineWidth: 1)
        )
    }
    
    // MARK: =========================================
    // MARK: - 09.5.1 · DROPDOWN DE TODOS LOS MALESTARES
    // MARK: =========================================

    private var ailmentDropdown: some View {

        VStack(alignment: .leading, spacing: 0) {

            // Encabezado
            HStack {

                Text("SELECCIONA UN MALESTAR")
                    .font(.system(size: 11, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Palette.brown)

                Spacer()

                Text("\(ailmentOptions.count) opciones")
                    .font(.system(size: 12, design: .serif))
                    .foregroundStyle(Palette.olive)
            }
            .padding(15)

            Divider()
                .overlay(Palette.sage)

            // Lista con scroll
            ScrollView(.vertical, showsIndicators: true) {

                LazyVStack(spacing: 0) {

                    ForEach(
                        ailmentOptions.sorted {
                            $0.name.localizedStandardCompare($1.name)
                                == .orderedAscending
                        }
                    ) { ailment in

                        Button {

                            selectAilment(ailment)

                            withAnimation(.easeInOut(duration: 0.2)) {
                                showDropdown = false
                            }

                        } label: {

                            HStack(spacing: 12) {

                                Image(systemName: "leaf")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Palette.olive)

                                Text(ailment.name)
                                    .font(.system(size: 16, design: .serif))
                                    .foregroundStyle(Palette.ink)

                                Spacer()

                                if selectedAilment?.id == ailment.id {

                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Palette.olive)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 15)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .background(
                                selectedAilment?.id == ailment.id
                                    ? Palette.sage.opacity(0.25)
                                    : Color.clear
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, 40)
                            .overlay(Palette.sage.opacity(0.3))
                    }
                }
            }
            .frame(maxHeight: 280)
        }
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 18)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Palette.line, lineWidth: 1)
        )
        .shadow(
            color: Palette.brown.opacity(0.12),
            radius: 12,
            y: 6
        )
    }
    

    // MARK: =========================================
    // MARK: - 09.6 · MALESTARES FRECUENTES
    // MARK: =========================================

    private var frequentAilments: some View {

        VStack(alignment: .leading, spacing: 12) {


            AilmentFlowLayout(spacing: 9) {

                ForEach(frequentIDs, id: \.self) { id in

                    if let ailment = ailmentOptions.first(
                        where: { $0.id == id }
                    ) {

                        Button {

                            selectAilment(ailment)

                        } label: {

                            Text(ailment.name.lowercased())
                                .font(.system(
                                    size: 14,
                                    design: .serif
                                ))
                                .foregroundStyle(Palette.olive)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(
                                    selectedAilment?.id == id
                                        ? Palette.sage.opacity(0.55)
                                        : Palette.card,
                                    in: Capsule()
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            selectedAilment?.id == id
                                                ? Palette.olive
                                                : .clear,
                                            lineWidth: 1.5
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: =========================================
    // MARK: - 09.7 · RESULTADOS
    // MARK: =========================================

    private func resultsView(
        for ailment: AilmentOption
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("Plantas relacionadas")
                    .font(.system(
                        size: 23,
                        weight: .semibold,
                        design: .serif
                    ))
                    .foregroundStyle(Palette.olive)

                Spacer()

                Text("\(ailment.matches.count)")
                    .font(.system(size: 13))
                    .foregroundStyle(Palette.brown)
            }

            if ailment.matches.isEmpty {

                noMatchesView

            } else {

                ForEach(ailment.matches) { match in

                    if let plant = glossaryPlants.first(
                        where: { $0.commonName == match.plantName }
                    ) {

                        NavigationLink {

                            if let request = PreparationGuideRequest.forAilment(plantMatchID: match.id, ailmentID: ailment.id) {
                                if (request.plantId == "ginseng" && request.symptomId == "fatigue-weakness") ||
                                    (request.plantId == "valerian" && ["occasional-sleep-difficulty", "mild-mental-stress", "mild-nervous-tension"].contains(request.symptomId)) ||
                                    (request.plantId == "turmeric" && request.symptomId == "mild-digestive-discomfort") ||
                                    (request.plantId == "eucalyptus" && request.symptomId == "cough-associated-with-cold") ||
                                    (request.plantId == "rosemary" && ["mild-muscle-pain", "mild-joint-pain"].contains(request.symptomId)) {
                                    PreparationGuideSelectionView(plantId: request.plantId, symptomId: request.symptomId)
                                } else {
                                    PreparationGuideView(request: request)
                                }
                            } else {
                                plantDestination(plant)
                            }

                        } label: {

                            AilmentPlantCard(
                                plant: plant,
                                description: match.description
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.top, 14)
    }

    // MARK: =========================================
    // MARK: - 09.8 · NAVEGACIÓN A FICHAS
    // MARK: =========================================

    @ViewBuilder
    private func plantDestination(
        _ plant: PlantGlossaryItem
    ) -> some View {

        switch plant.commonName {

        case "Manzanilla":
            ChamomileDetailView()

        case "Menta":
            MintDetailView()

        case "Jengibre":
            GingerDetailView()

        case "Aloe Vera":
            AloeDetailView()

        case "Lavanda":
            LavenderDetailView()

        case "Eucalipto":
            EucalyptusDetailView()

        case "Romero":
            RosemaryDetailView()

        case "Cúrcuma":
            TurmericDetailView()

        case "Valeriana":
            ValerianDetailView()

        case "Ginseng":
            GinsengDetailView()

        default:
            PlaceholderPlantView(plant: plant)
        }
    }

    // MARK: =========================================
    // MARK: - 09.9 · ESTADOS VACÍOS
    // MARK: =========================================

    private var emptySearchView: some View {

        VStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 34))
                .foregroundStyle(Palette.olive)

            Text("No encontramos ese malestar")
                .font(.system(size: 20, design: .serif))
                .foregroundStyle(Palette.olive)

            Text("Intenta buscar con otro término.")
                .font(.system(size: 14))
                .foregroundStyle(Palette.brown)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 35)
    }

    private var noMatchesView: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Sin plantas asociadas por ahora",
                systemImage: "leaf"
            )
            .font(.system(size: 18, design: .serif))
            .foregroundStyle(Palette.olive)

            Text(
                "Todavía no contamos con una asociación suficientemente documentada para este malestar dentro del catálogo."
            )
            .font(.system(size: 14))
            .foregroundStyle(Palette.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 18)
        )
    }
}

// MARK: - ILUSTRACIÓN DECORATIVA DE MALESTARES
