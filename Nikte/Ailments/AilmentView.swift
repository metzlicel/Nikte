import SwiftUI

// MARK: - 09 · BUSCAR POR MALESTARES

// MARK: - 09.1 · MODELOS

struct AilmentOption: Identifiable {
    let id: String
    let name: String
}

// Nombres del buscador; las relaciones con plantas provienen de GuideRecommendations.
let ailmentOptions: [AilmentOption] = [
    .init(id: "ansiedad", name: "Ansiedad"),
    .init(id: "colicos", name: "Cólicos"),
    .init(id: "congestion", name: "Congestión nasal"),
    .init(id: "cabeza", name: "Dolor de cabeza"),
    .init(id: "estomago", name: "Dolor de estómago"),
    .init(id: "molestias_digestivas_leves", name: "Molestias digestivas leves"),
    .init(id: "gases", name: "Gases leves"),
    .init(id: "insomnio", name: "Insomnio"),
    .init(id: "nauseas", name: "Náuseas"),
    .init(id: "nauseas_movimiento", name: "Náuseas por movimiento"),
    .init(id: "quemaduras_superficiales_leves", name: "Quemaduras superficiales leves"),
    .init(id: "estres_leve", name: "Estrés leve"),
    .init(id: "dificultad_ocasional_dormir", name: "Dificultad ocasional para dormir"),
    .init(id: "tos_resfriado", name: "Tos asociada al resfriado"),
    .init(id: "tension_nerviosa_leve", name: "Tensión nerviosa leve"),
    .init(id: "dolor_muscular_localizado_leve", name: "Dolor muscular localizado leve"),
    .init(id: "dolor_muscular_leve", name: "Dolor muscular leve"),
    .init(id: "molestias_articulares_leves", name: "Molestias articulares leves"),
    .init(id: "piernas_cansadas_leves", name: "Piernas cansadas sin signos de alarma"),
    .init(id: "sintomas_ansiedad_leve", name: "Síntomas leves de ansiedad"),
    .init(id: "estres_leve_agotamiento", name: "Estrés leve y agotamiento"),
    .init(id: "agotamiento_leve", name: "Agotamiento leve"),
    .init(id: "psoriasis_leve_diagnosticada", name: "Psoriasis leve diagnosticada"),
    .init(id: "placas_psoriasis_diagnosticada", name: "Placas localizadas de psoriasis diagnosticada"),
    .init(id: "indigestion_leve", name: "Indigestión leve"),
    .init(id: "hinchazon_abdominal", name: "Hinchazón abdominal"),
    .init(id: "colicos_menstruales_leves", name: "Cólicos menstruales leves"),
    .init(id: "dolor_menstrual_primario", name: "Dolor menstrual primario"),
    .init(id: "sindrome_intestino_irritable", name: "Síndrome de intestino irritable"),
    .init(id: "dolor_abdominal_sii", name: "Dolor abdominal asociado al síndrome de intestino irritable"),
    .init(id: "espasmos_intestinales_sii", name: "Espasmos intestinales asociados al síndrome de intestino irritable"),
    .init(id: "cefalea_tensional_leve", name: "Cefalea tensional leve"),
    .init(id: "inflamacion_bucal_leve", name: "Inflamación bucal leve"),
    .init(id: "aftas_pequenas", name: "Pequeñas aftas"),
    .init(id: "irritacion_garganta_leve", name: "Irritación leve de garganta"),
    .init(id: "irritacion_cutanea_leve", name: "Irritación cutánea leve"),
    .init(id: "quemadura_solar_leve", name: "Quemadura solar leve sin ampollas"),
    .init(id: "cansancio_debilidad_leves", name: "Cansancio y debilidad leves")
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
        "molestias_digestivas_leves",
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
        let matches = GuideRecommendations.forAilment(ailment.id).filter { recommendation in
            glossaryPlants.contains { $0.imageName == recommendation.imageName }
        }
        return VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("Plantas relacionadas")
                    .font(.system(
                        size: 23,
                        weight: .semibold,
                        design: .serif
                    ))
                    .foregroundStyle(Palette.olive)

                Spacer()

                Text("\(matches.count)")
                    .font(.system(size: 13))
                    .foregroundStyle(Palette.brown)
            }

            if matches.isEmpty {

                noMatchesView

            } else {

                ForEach(matches) { match in

                    if let plant = glossaryPlants.first(
                        where: { $0.imageName == match.imageName }
                    ) {

                        NavigationLink {

                            if match.requests.count > 1 {
                                PreparationGuideSelectionView(requests: match.requests)
                            } else if let request = match.requests.first {
                                PreparationGuideView(request: request)
                            }

                        } label: {

                            AilmentPlantCard(
                                plant: plant,
                                description: match.titles.count == 1 ? match.titles[0] : "\(match.titles.count) preparaciones disponibles"
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
                "Sin guías disponibles por ahora",
                systemImage: "leaf"
            )
            .font(.system(size: 18, design: .serif))
            .foregroundStyle(Palette.olive)

            Text(
                "No contamos con una guía de preparación para este malestar. Busca una opción más específica si corresponde."
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
