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
        "nauseas",
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

                            plantDestination(plant)

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
