import SwiftUI

// MARK: - 01 · APP DE NIKTÉ
@main

struct NikteApp: App {
    var body: some Scene { WindowGroup { RootView() } }
}

// MARK: - 02 · PALETA Y ESTILO BOTÁNICO

enum Palette {
    static let olive = Color(red: 0.47, green: 0.49, blue: 0.25)
    static let sage = Color(red: 0.76, green: 0.82, blue: 0.78)
    static let brown = Color(red: 0.50, green: 0.38, blue: 0.28)
    static let ink = Color(red: 0.26, green: 0.18, blue: 0.14)
    static let card = Color(red: 0.95, green: 0.91, blue: 0.83)
    // Compatibilidad con los componentes de InteractiveChemistry.swift
    static let paper = card
    static let cream = background
    static let line = Color(red: 0.62, green: 0.49, blue: 0.39)
    static let background = Color(red: 0.93, green: 0.89, blue: 0.80)
}

// MARK: - 03 · MODELOS Y CATÁLOGO DE PLANTAS

struct Plant: Identifiable, Hashable {
    let id: String
    let name: String
    let latin: String
    let subtitle: String
}

// MARK: - MODELO DEL GLOSARIO DE PLANTAS

struct PlantGlossaryItem: Identifiable {
    let id = UUID()
    let commonName: String
    let scientificName: String
    let imageName: String
}

// MARK: - DATOS DEL GLOSARIO

let glossaryPlants: [PlantGlossaryItem] = [
    PlantGlossaryItem(
        commonName: "Manzanilla",
        scientificName: "Matricaria chamomilla",
        imageName: "manzanilla_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Menta",
        scientificName: "Mentha piperita",
        imageName: "menta_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Jengibre",
        scientificName: "Zingiber officinale",
        imageName: "jengibre_ilustracion"
    ),
    PlantGlossaryItem(
        commonName: "Lavanda",
        scientificName: "Lavandula angustifolia",
        imageName: "lavanda_ilustracion"
    )
]

// MARK: - 04 · TARJETAS DEL GLOSARIO

struct PlantGlossaryCard: View {
    let plant: PlantGlossaryItem

    var body: some View {
        VStack(spacing: 14) {

            Spacer(minLength: 0)

            Image(plant.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Spacer(minLength: 0)

            Text(plant.commonName)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Palette.ink)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            Text(plant.scientificName)
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Palette.brown)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, 8)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Palette.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Palette.line, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

// MARK: - VISTA TEMPORAL DE FICHA EN DESARROLLO

struct PlaceholderPlantView: View {
    let plant: PlantGlossaryItem

    var body: some View {
        ZStack {
            BotanicalBackground()
                .allowsHitTesting(false)

            VStack(spacing: 16) {

                Image(plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)

                Text(plant.commonName)
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundStyle(Palette.olive)

                Text(plant.scientificName)
                    .font(.system(size: 18, design: .serif))
                    .italic()
                    .foregroundStyle(Palette.brown)

                Text("Ficha en desarrollo")
                    .font(.system(size: 16))
                    .foregroundStyle(Palette.ink.opacity(0.8))
            }
            .padding(30)
        }
    }
}

// MARK: - 05 · GLOSARIO · BUSCADOR Y ORDEN A–Z

// MARK: =============================================
// MARK: - 05 · GLOSARIO BOTÁNICO
// MARK: =============================================

struct PlantGlossaryView: View {

    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    // MARK: - 05.1 · ORDEN ALFABÉTICO Y BÚSQUEDA

    private var filteredPlants: [PlantGlossaryItem] {

        let sortedPlants = glossaryPlants.sorted {
            $0.commonName.localizedStandardCompare($1.commonName)
                == .orderedAscending
        }

        guard !searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else {
            return sortedPlants
        }

        return sortedPlants.filter { plant in
            plant.commonName.localizedStandardContains(searchText) ||
            plant.scientificName.localizedStandardContains(searchText)
        }
    }

    // MARK: - 05.2 · VISTA PRINCIPAL

    var body: some View {

        ZStack {

            BotanicalBackground()
                .allowsHitTesting(false)

            ScrollView(.vertical, showsIndicators: true) {

                VStack(spacing: 0) {

                    // MARK: - ENCABEZADO VINTAGE

                    BotanicalHeaderView()

                    // MARK: - CONTENIDO DEL GLOSARIO

                    VStack(alignment: .leading, spacing: 20) {

                        // Título
                        Text("Botánica")
                            .font(
                                .system(
                                    size: 32,
                                    weight: .semibold,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(Palette.olive)

                        // MARK: - BUSCADOR

                        HStack(spacing: 12) {

                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Palette.olive)

                            TextField(
                                "Buscar planta...",
                                text: $searchText
                            )
                            .font(.system(size: 15))
                            .foregroundStyle(Palette.ink)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                            if !searchText.isEmpty {

                                Button {
                                    searchText = ""
                                } label: {

                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Palette.brown)
                                }
                                .accessibilityLabel("Limpiar búsqueda")
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Palette.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Palette.line,
                                    lineWidth: 1
                                )
                        )

                        // MARK: - CONTADOR Y ORDEN A–Z

                        HStack {

                            Text("\(filteredPlants.count) plantas")
                                .font(
                                    .system(
                                        size: 13,
                                        design: .serif
                                    )
                                )
                                .foregroundStyle(Palette.brown)

                            Spacer()

                            Label(
                                "A–Z",
                                systemImage: "arrow.down"
                            )
                            .font(
                                .system(
                                    size: 12,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(Palette.olive)
                        }

                        // MARK: - TARJETAS DE PLANTAS

                        if filteredPlants.isEmpty {

                            VStack(spacing: 12) {

                                Image(systemName: "leaf")
                                    .font(.system(size: 35))
                                    .foregroundStyle(Palette.olive)

                                Text("No encontramos esa planta")
                                    .font(
                                        .system(
                                            size: 20,
                                            design: .serif
                                        )
                                    )
                                    .foregroundStyle(Palette.olive)

                                Text(
                                    "Prueba con otro nombre común o científico."
                                )
                                .font(.system(size: 14))
                                .foregroundStyle(Palette.brown)
                                .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)

                        } else {

                            LazyVGrid(
                                columns: columns,
                                spacing: 14
                            ) {

                                ForEach(filteredPlants) { plant in

                                    NavigationLink {

                                        destinationView(for: plant)

                                    } label: {

                                        PlantGlossaryCard(plant: plant)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
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

    // MARK: - 05.3 · NAVEGACIÓN A FICHAS TÉCNICAS

    @ViewBuilder
    private func destinationView(
        for plant: PlantGlossaryItem
    ) -> some View {

        switch plant.commonName {

        case "Manzanilla":
            ChamomileDetailView()

        default:
            PlaceholderPlantView(plant: plant)
        }
    }
}


// MARK: =============================================
// MARK: - 05.4 · ENCABEZADO BOTÁNICO COMPARTIDO
// MARK: =============================================

struct BotanicalHeaderView: View {

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // Fondo rayado vintage
                Image("nikte_vintage_wallpaper")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()

                // Logo de Nikté
                Image("nikte_plant_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width * 0.82
                    )
                    .offset(y: 35)
                    .accessibilityHidden(true)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .frame(height: 240)
        .accessibilityLabel("Nikté")
    }
}
let chamomile = Plant(id: "chamomile", name: "Manzanilla", latin: "Matricaria chamomilla L.", subtitle: "Flores · Familia Asteraceae")

// MARK: - 06 · TAB BAR (INICIO / PLANTAS / MALESTARES)

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Inicio", systemImage: "house") }
            NavigationStack { PlantGlossaryView() }
                .tabItem { Label("Plantas", systemImage: "leaf") }
            NavigationStack { AilmentView() }
                .tabItem { Label("Malestares", systemImage: "magnifyingglass") }
        }
        .tint(Palette.olive)
    }
}

// MARK: - 07 · COMPONENTES COMPARTIDOS Y FONDO

struct BotanicalBackground: View {
    var body: some View {
        ZStack {
            Palette.background.ignoresSafeArea()
            GeometryReader { geo in
                Path { path in
                    stride(from: CGFloat(0), through: geo.size.width, by: 22).forEach { x in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    }
                }
                .stroke(Palette.sage.opacity(0.16), lineWidth: 1)
                VStack {
                    HStack { Text("❧  ✿  ❧  ✿  ❧  ✿"); Spacer() }
                    Spacer()
                    HStack { Spacer(); Text("✿  ❧  ✿  ❧  ✿") }
                }
                .font(.system(size: 25))
                .foregroundStyle(Palette.olive.opacity(0.30))
                .padding(12)
            }.ignoresSafeArea()
        }
    }
}

struct PaperCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 14) { content }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Palette.card, in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Palette.brown.opacity(0.55), lineWidth: 1.3))
    }
}

struct BrandMark: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("24").font(.system(size: 12, design: .serif)).frame(maxWidth: .infinity, alignment: .leading)
            Text("N").font(.system(size: 65, design: .serif)).italic()
            Text("10.12").font(.system(size: 12, design: .serif))
            Text("Nikté").font(.system(size: 20, design: .serif))
                .frame(maxWidth: .infinity).padding(.vertical, 5)
                .background(Palette.sage)
                .foregroundStyle(Palette.olive)
        }
        .foregroundStyle(Palette.card)
        .padding(.top, 10)
        .frame(width: 138)
        .background(Palette.olive, in: RoundedRectangle(cornerRadius: 19))
        .clipShape(RoundedRectangle(cornerRadius: 19))
        .accessibilityLabel("Nikté, emblema verde")
    }
}

// MARK: - 08 · HOME / PANTALLA INICIAL

// MARK: - HEADER DECORATIVO DEL HOME

struct HomeHeroHeaderView: View {
    var body: some View {
        ZStack {
            Image("nikte_vintage_wallpaper")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 190)
                .clipped()

            Image("nikte_home_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 285)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Palette.line.opacity(0.35), lineWidth: 1)
        )
    }
}

// MARK: - HOME
struct HomeView: View {

    var body: some View {

        GeometryReader { geometry in

            let screenWidth = geometry.size.width
            let cardWidth = max(0, screenWidth - 40)

            ZStack {

                GeometryReader { backgroundGeometry in

                    Image("nikte_vintage_wallpaper")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: backgroundGeometry.size.width,
                            height: backgroundGeometry.size.height
                        )
                        .clipped()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

                // MARK: - CONTENIDO PRINCIPAL

                ScrollView(.vertical, showsIndicators: false) {

                    VStack(spacing: 0) {

                        Spacer(minLength: 75)

                        // MARK: - LOGO

                        Image("nikte_home_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.82)

                        // MARK: - ESLOGAN

                        Text("Aprende la química detrás de\nlas flores")
                            .font(.system(
                                size: 22,
                                weight: .semibold,
                                design: .serif
                            ))
                            .foregroundStyle(Palette.ink)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 35)

                        Spacer(minLength: 45)

                        // MARK: - TARJETAS DE NAVEGACIÓN

                        VStack(spacing: 20) {

                            NavigationLink {
                                PlantGlossaryView()
                            } label: {

                                HomeNavigationCard(
                                    title: "Conoce las plantas",
                                    imageName: "home_book_icon",
                                    cardWidth: cardWidth
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                AilmentView()
                            } label: {

                                HomeNavigationCard(
                                    title: "Busca por malestar",
                                    imageName: "home_magnifier_icon",
                                    cardWidth: cardWidth
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(width: screenWidth)

                        Spacer(minLength: 40)

                        // MARK: - PIE DE PÁGINA

                        Text("NIKTÉ · BOTÁNICA Y QUÍMICA")
                            .font(.system(size: 13, design: .serif))
                            .tracking(2)
                            .foregroundStyle(Palette.olive)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 35)
                    }
                    .frame(width: screenWidth)
                    .frame(
                        minHeight: geometry.size.height,
                        alignment: .top
                    )
                }
                .frame(
                    width: screenWidth,
                    height: geometry.size.height
                )
            }
            .frame(
                width: screenWidth,
                height: geometry.size.height
            )
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}
// MARK: - 08.1 · TARJETA DE NAVEGACIÓN DEL HOME

struct HomeNavigationCard: View {

    let title: String
    let imageName: String
    let cardWidth: CGFloat

    var body: some View {

        HStack(spacing: 14) {

            // Ilustración
            Group {

                if imageName == "home_book_icon" {

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.35)

                } else {

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 85, height: 100)
            .accessibilityHidden(true)

            // Título
            Text(title)
                .font(.system(
                    size: 22,
                    weight: .semibold,
                    design: .serif
                ))
                .foregroundStyle(Palette.olive)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Flecha
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Palette.olive)
        }
        .padding(.horizontal, 15)
        .frame(width: cardWidth, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Palette.paper)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Palette.line, lineWidth: 1.4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct MenuTile: View {
    let title: String
    let subtitle: String
    let symbol: String
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: symbol).font(.system(size: 28)).frame(width: 42)
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.system(size: 23, design: .serif)).bold()
                Text(subtitle).font(.system(size: 13, design: .serif))
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Palette.olive)
        .padding(19)
        .background(Palette.card, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Palette.olive.opacity(0.5)))
    }
}

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

struct AilmentIllustrationView: View {
    var body: some View {
        Image("malestares_ilustracion")
            .resizable()
            .scaledToFit()
            .frame(height: 170)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .accessibilityHidden(true)
    }
}


// MARK: =============================================
// MARK: - 09.10 · TARJETAS DE PLANTAS
// MARK: =============================================

struct AilmentPlantCard: View {

    let plant: PlantGlossaryItem
    let description: String

    var body: some View {

        HStack(alignment: .center, spacing: 15) {

            Image(plant.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 275)

            VStack(alignment: .leading, spacing: 6) {

                Text(plant.commonName)
                    .font(.system(
                        size: 23,
                        weight: .medium,
                        design: .serif
                    ))
                    .foregroundStyle(Palette.ink)

                Text(plant.scientificName)
                    .font(.system(size: 13, design: .serif))
                    .italic()
                    .foregroundStyle(Palette.brown)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Palette.olive)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.paper,
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    Palette.brown.opacity(0.7),
                    lineWidth: 1.2
                )
        )
        .shadow(
            color: Palette.brown.opacity(0.05),
            radius: 5,
            y: 3
        )
    }
}


// MARK: =============================================
// MARK: - 09.11 · LAYOUT DE ETIQUETAS
// MARK: =============================================

// Distribuye las etiquetas en varias filas,
// según el ancho disponible en el iPhone.

struct AilmentFlowLayout: Layout {

    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let width = proposal.width ?? 350

        let sizes = subviews.map {
            $0.sizeThatFits(.unspecified)
        }

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for size in sizes {

            if x > 0 && x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(
            width: width,
            height: y + rowHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(.unspecified)

            if x > bounds.minX &&
                x + size.width > bounds.maxX {

                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height
                )
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}


struct SectionTitle: View {
    let kicker: String
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(kicker).font(.system(size: 12, design: .serif)).tracking(3).foregroundStyle(Palette.brown)
            Text(title) .font(.system(size: 32, weight: .semibold, design: .serif))
                .foregroundStyle(Palette.olive)
            Rectangle().fill(Palette.brown.opacity(0.5)).frame(height: 1)
        }
    }
}

// MARK: - 10 · DATOS QUÍMICOS DE MANZANILLA

struct Compound: Identifiable {
    let id: String
    let name: String
    let formula: String
    let family: String
    let mechanism: String
    let extraction: String
}

let compounds: [Compound] = [
    Compound(id: "apigenin", name: "Apigenina", formula: "C₁₅H₁₀O₅", family: "Flavona (flavonoide)", mechanism: "En estudios experimentales se ha asociado con modulación de NF-κB y mediadores inflamatorios. También se ha estudiado su interacción con receptores GABA-A; esto no demuestra por sí solo eficacia clínica contra el insomnio.", extraction: "Los glucósidos de apigenina se recuperan mejor en medios polares como agua y mezclas hidroalcohólicas; la apigenina libre es menos soluble en agua."),
    Compound(id: "apigenin7", name: "Apigenina-7-O-glucósido", formula: "C₂₁H₂₀O₁₀", family: "Flavonoide glucosilado", mechanism: "La unión a una unidad de glucosa modifica la polaridad y la solubilidad respecto de la apigenina libre. La hidrólisis del enlace glucosídico puede liberar apigenina, dependiendo de las condiciones.", extraction: "Se encuentra entre los constituyentes que pueden extraerse de las flores mediante infusión y disolventes polares."),
    Compound(id: "bisabolol", name: "α-Bisabolol", formula: "C₁₅H₂₆O", family: "Alcohol sesquiterpénico", mechanism: "En modelos preclínicos presenta actividad antiinflamatoria; se han investigado cambios en rutas de señalización y producción de mediadores inflamatorios.", extraction: "Componente lipofílico y relativamente volátil del aceite esencial; se recupera principalmente por destilación por arrastre de vapor."),
    Compound(id: "matricin", name: "Matricina", formula: "C₁₇H₂₂O₅", family: "Lactona sesquiterpénica", mechanism: "Es un precursor natural del camazuleno. Durante el procesamiento térmico puede sufrir transformaciones químicas que conducen a camazuleno.", extraction: "Se encuentra en las flores; el calentamiento durante la destilación favorece su transformación, por lo que el perfil del aceite difiere del de la flor."),
    Compound(id: "chamazulene", name: "Camazuleno", formula: "C₁₄H₁₆", family: "Hidrocarburo aromático (azuleno)", mechanism: "Se forma durante la destilación a partir de precursores como la matricina. Se le atribuyen actividades antiinflamatorias en investigación experimental.", extraction: "Característico de ciertos aceites esenciales de manzanilla; no debe suponerse que la infusión contiene la misma cantidad que el aceite destilado.")
]

// MARK: - 11 · TARJETAS DESPLEGABLES Y COMPONENTES DE FICHA

struct ExpandableCard<Content: View>: View {
    let title: String
    let subtitle: String
    @State private var expanded = false
    @ViewBuilder var content: Content
    var body: some View {
        PaperCard {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) { expanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title).font(.system(size: 23, design: .serif)).bold()
                        Text(subtitle).font(.system(size: 13, design: .serif))
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                }.foregroundStyle(Palette.olive).contentShape(Rectangle())
            }.buttonStyle(.plain)
                .accessibilityHint(expanded ? "Contraer sección" : "Expandir sección")
            if expanded {
                Rectangle().fill(Palette.sage).frame(height: 1)
                content
            }
        }
    }
}

struct InfoLine: View {
    let title: String
    let bodyText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 18, design: .serif)).bold().foregroundStyle(Palette.olive)
            Text(bodyText).font(.system(size: 15)).foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
}

// MARK: - 12 · PRESENTACIÓN VISUAL DE LA QUÍMICA

struct FactChip: View {
    let text: String
    let symbol: String
    var body: some View {
        Label(text, systemImage: symbol)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Palette.olive)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Palette.sage.opacity(0.22), in: Capsule())
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct QuickFact: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .medium, design: .serif))
                .tracking(1)
                .foregroundStyle(Palette.brown)
            Text(value)
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(Palette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Palette.sage.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BulletFacts: View {
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                        .padding(.top, 7)
                        .foregroundStyle(Palette.olive)
                    Text(item)
                        .font(.system(size: 14))
                        .foregroundStyle(Palette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

// MARK: - 13 · PROPIEDADES EN TARJETAS INTERACTIVAS

struct PropertyInfo: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let subtitle: String
    let compound: String
    let action: String
    let observations: [String]
    let caveat: String
}

private let chamomileProperties: [PropertyInfo] = [
    .init(id: "digestiva", title: "Digestiva", symbol: "waveform.path.ecg", subtitle: "Espasmos intestinales", compound: "Flavonoides y otros componentes", action: "Se estudia si pueden modificar la contracción del músculo liso intestinal.", observations: ["Posible participación de señales asociadas al calcio.", "Los resultados experimentales no garantizan alivio clínico de cualquier cólico."], caveat: "Actividad antiespasmódica: evidencia principalmente experimental."),
    .init(id: "inflamacion", title: "Antiinflamatoria", symbol: "flame", subtitle: "Mediadores de inflamación", compound: "Apigenina · α-bisabolol", action: "En modelos de laboratorio pueden modular señales inflamatorias.", observations: ["Se investigan rutas como NF-κB.", "Pueden variar mediadores asociados con COX-2 e iNOS."], caveat: "No implica que una infusión alcance las concentraciones de los ensayos."),
    .init(id: "relajacion", title: "Relajante", symbol: "moon.stars", subtitle: "Señalización nerviosa", compound: "Apigenina", action: "Se investiga su interacción con el sistema de receptores GABA-A.", observations: ["GABA-A participa en la neurotransmisión inhibitoria.", "Interacción molecular no equivale a eficacia comprobada contra el insomnio."], caveat: "No hay que confundir una hipótesis mecanística con un efecto clínico demostrado."),
    .init(id: "antioxidante", title: "Antioxidante", symbol: "sparkles", subtitle: "Reacciones de transferencia", compound: "Flavonoides fenólicos", action: "Sus grupos –OH pueden transferir hidrógeno o electrones en ensayos químicos.", observations: ["Ejemplo general: ArOH + R• → ArO• + RH.", "Un ensayo antioxidante no prueba por sí solo un beneficio en el organismo."], caveat: "La reacción mostrada es ilustrativa, no específica de una dosis de manzanilla.")
]

struct PropertyCard: View {
    let property: PropertyInfo
    @State private var isOpen = false
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) { isOpen.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: property.symbol)
                        .font(.system(size: 23))
                        .frame(width: 43, height: 43)
                        .foregroundStyle(Palette.olive)
                        .background(Palette.sage.opacity(0.22), in: RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(property.title)
                            .font(.system(size: 21, design: .serif)).bold()
                        Text(property.subtitle)
                            .font(.system(size: 12))
                    }
                    Spacer(minLength: 4)
                    Image(systemName: isOpen ? "minus.circle" : "plus.circle")
                        .font(.system(size: 20))
                }
                .foregroundStyle(Palette.olive)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(isOpen ? "Ocultar mecanismo" : "Mostrar mecanismo y compuestos")
            if isOpen {
                Rectangle().fill(Palette.sage.opacity(0.8)).frame(height: 1)
                Text("¿CÓMO PODRÍA ACTUAR?")
                    .font(.system(size: 11, design: .serif)).tracking(1.5)
                    .foregroundStyle(Palette.brown)
                Text(property.action)
                    .font(.system(size: 15))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
                QuickFact(label: "Compuestos relacionados", value: property.compound)
                BulletFacts(items: property.observations)
                HStack(alignment: .top, spacing: 7) {
                    Image(systemName: "info.circle")
                    Text(property.caveat)
                }
                .font(.system(size: 12))
                .foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Palette.card.opacity(0.85), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Palette.sage.opacity(0.75), lineWidth: 1))
    }
}

struct PropertyGallery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Toca una propiedad para explorar su química")
                .font(.system(size: 14, design: .serif)).italic()
                .foregroundStyle(Palette.brown)
            ForEach(chamomileProperties) { item in
                PropertyCard(property: item)
            }
        }
    }
}

// MARK: - 14 · COMPARACIÓN DE EXTRACCIONES

struct ExtractionComparison: View {
    let extraction: String
    private var contents: (title: String, characteristics: [String], chemistry: String) {
        switch extraction {
        case "flowers":
            return ("Flores secas", ["Flavonoides y sus glucósidos", "Constituyentes del aceite esencial", "Cambios posibles durante el secado"], "Deshidratación y conservación; no constituye una extracción selectiva.")
        case "steam":
            return ("Aceite esencial", ["Constituyentes relativamente volátiles", "α-Bisabolol", "Camazuleno puede formarse por calor"], "Volatilidad, condensación y separación de fases.")
        case "ethanol":
            return ("Extracto hidroalcohólico", ["Flavonoides con distintas polaridades", "Perfil variable según proporción agua/etanol", "Disolución y filtrado"], "La mezcla de solventes modifica la solubilidad de los compuestos.")
        default:
            return ("Infusión acuosa", ["Compuestos relativamente polares", "Glucósidos como apigenina-7-O-glucósido", "Perfil distinto al aceite esencial"], "El agua caliente facilita disolución y difusión.")
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(contents.title)
                .font(.system(size: 21, design: .serif)).bold()
                .foregroundStyle(Palette.olive)
            Text("QUÉ CONTIENE O FAVORECE")
                .font(.system(size: 11, design: .serif)).tracking(1.3)
                .foregroundStyle(Palette.brown)
            BulletFacts(items: contents.characteristics)
            QuickFact(label: "Principio químico", value: contents.chemistry)
        }
    }
}

// MARK: - 15 · FICHA TÉCNICA DE MANZANILLA

struct ChamomileDetailView: View {
    @State private var selectedCompound = "apigenin"
    @State private var extraction = "infusion"
    @State private var selectedMechanism = "heat"
    
    private let extractions = [
        ("flowers", "Flores secas"),
        ("infusion", "Infusión acuosa"),
        ("steam", "Aceite esencial"),
        ("ethanol", "Extracto hidroalcohólico")
    ]
    var body: some View {
        ZStack {
            BotanicalBackground().allowsHitTesting(false)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    Image("ficha_manzanilla_ilustracion")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    SectionTitle(kicker: "FICHA BOTÁNICA · 001", title: "Manzanilla")
                    Text("Matricaria chamomilla L. · Asteraceae")
                        .font(.system(size: 17, design: .serif)).italic().foregroundStyle(Palette.brown)
                    Text("Parte estudiada: capítulos florales (flores).")
                        .foregroundStyle(Palette.ink)
                    ExpandableCard(title: "01 · Composición química", subtitle: "Conoce los compuestos activos") {
                        Text("Explora las moléculas y toca sus grupos funcionales.")
                            .font(.system(size: 14, design: .serif))
                            .foregroundStyle(Palette.brown)
                        Picker("Compuesto", selection: $selectedCompound) {
                            ForEach(compounds) { compound in Text(compound.name).tag(compound.id) }
                        }.tint(Palette.olive).pickerStyle(.menu)
                        if let compound = compounds.first(where: { $0.id == selectedCompound }) {
                            Text(compound.name)
                                .font(.system(size: 22, design: .serif)).bold()
                                .foregroundStyle(Palette.olive)
                            FactChip(text: compound.formula, symbol: "atom")
                            QuickFact(label: "Familia química", value: compound.family)
                            MolecularDiagramView(compoundID: selectedCompound)
                            QuickFact(label: "Actividad investigada", value: compound.mechanism)
                            QuickFact(label: "Extracción", value: compound.extraction)
                        }
                    }
                    ExpandableCard(title: "02 · Propiedades", subtitle: "Actividad biológica investigada") {
                        PropertyGallery()
                    }

                    ExpandableCard(
                        title: "03 · Reacciones y mecanismos",
                        subtitle: "Cómo funcionan los compuestos en el organismo"
                    ) {
                        BiologicalMechanismsView()
                    }
                    ExpandableCard(title: "04 · Extracciones", subtitle: "Cómo cambia la composición") {
                        Picker("Presentación", selection: $extraction) {
                            ForEach(extractions.indices, id: \.self) { index in
                                Text(extractions[index].1).tag(extractions[index].0)
                            }
                        }.tint(Palette.olive).pickerStyle(.menu)
                        ExtractionExplorerView(extraction: extraction)
                        ExtractionComparison(extraction: extraction)
                    }
                    PaperCard {
                        Text("Nota de seguridad").font(.system(size: 19, design: .serif)).bold().foregroundStyle(Palette.olive)
                        Text("Contenido educativo. Las personas con alergia a plantas de la familia Asteraceae deben tener precaución. Los extractos concentrados y aceites esenciales no son equivalentes a una infusión ni deben ingerirse por analogía.")
                            .font(.system(size: 14)).foregroundStyle(Palette.ink)
                    }
                    Text("Fuentes de consulta: revisión fitoquímica de Matricaria chamomilla, PMC9822300. Los mecanismos resumidos incluyen hallazgos experimentales y no implican eficacia terapéutica demostrada.")
                        .font(.system(size: 12, design: .serif)).foregroundStyle(Palette.brown)
                }.padding(20)
                 .padding(.bottom, 45)
            }
            .scrollDisabled(false)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Ficha de manzanilla")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 16 · DIAGRAMAS DE REACCIONES

struct ReactionStrip: View {
    let lhs: String
    let rhs: String
    let note: String
    var body: some View {
        VStack(spacing: 7) {
            HStack(spacing: 8) {
                Text(lhs)
                Image(systemName: "arrow.right")
                Text(rhs)
            }
            .font(.system(size: 14, design: .serif)).bold()
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            Text(note).font(.system(size: 11)).multilineTextAlignment(.center)
        }
        .foregroundStyle(Palette.olive)
        .frame(maxWidth: .infinity)
        .padding(13)
        .background(Palette.sage.opacity(0.23), in: RoundedRectangle(cornerRadius: 12))
    }
}


// MARK: - EXPLORADOR DE MECANISMOS BIOQUÍMICOS

struct BiologicalMechanismsView: View {

    @State private var selectedMechanism = "inflammation"

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Selecciona una propiedad para descubrir cómo actúan sus compuestos.")
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(Palette.brown)

            // MARK: - Dropdown de mecanismos

            Picker("Mecanismo molecular", selection: $selectedMechanism) {

                Text("Antiinflamatorio")
                    .tag("inflammation")

                Text("Relajante")
                    .tag("relaxation")

                Text("Digestivo y antiespasmódico")
                    .tag("digestive")

                Text("Antioxidante")
                    .tag("antioxidant")
            }
            .pickerStyle(.menu)
            .tint(Palette.olive)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Palette.sage.opacity(0.20),
                in: RoundedRectangle(cornerRadius: 14)
            )

            // MARK: - Contenido según selección

            switch selectedMechanism {

            case "inflammation":
                antiInflammatoryView

            case "relaxation":
                relaxationView

            case "digestive":
                digestiveView

            case "antioxidant":
                antioxidantView

            default:
                EmptyView()
            }
        }
    }

    // MARK: - A · MECANISMO ANTIINFLAMATORIO

    private var antiInflammatoryView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo antiinflamatorio",
                symbol: "flame"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "α-Bisabolol, apigenina y otros constituyentes del extracto."
            )

            Text("Ruta molecular simplificada")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Estímulo inflamatorio",
                detail: "Activa señales intracelulares."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Activación de NF-κB",
                detail: "Regula genes asociados con inflamación."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Modulación por fitoquímicos",
                detail: "α-Bisabolol y extractos pueden reducir la activación de esta vía en modelos experimentales."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Menor expresión de mediadores",
                detail: "Cambios observados en COX-2, iNOS y ciertas citocinas."
            )

            explanation(
                "Algunas moléculas de la manzanilla pueden disminuir señales celulares que favorecen la inflamación."
            )

            evidenceNote(
                "Resultados observados principalmente en modelos celulares y animales."
            )
        }
    }

    // MARK: - B · MECANISMO RELAJANTE

    private var relaxationView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo relajante",
                symbol: "moon.stars"
            )

            QuickFact(
                label: "Compuesto relacionado",
                value: "Apigenina"
            )

            Text("Interacción con el sistema GABA-A")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Apigenina",
                detail: "Flavonoide presente en la manzanilla."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Interacción con GABA-A",
                detail: "Se ha investigado su unión a un sitio asociado a receptores GABA-A."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Posible modulación neuronal",
                detail: "GABA-A participa en la inhibición de la actividad neuronal mediante canales de Cl⁻."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Actividad relajante propuesta",
                detail: "Mecanismo investigado para posibles efectos ansiolíticos."
            )

            explanation(
                "La apigenina puede interactuar con proteínas neuronales relacionadas con la regulación de la excitabilidad del sistema nervioso."
            )

            evidenceNote(
                "No debe interpretarse que la apigenina abre directamente el canal GABA-A ni que actúa igual que una benzodiacepina."
            )
        }
    }

    // MARK: - C · MECANISMO DIGESTIVO

    private var digestiveView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo digestivo y antiespasmódico",
                symbol: "waveform.path.ecg"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "Flavonoides, como la apigenina, y componentes del aceite esencial."
            )

            Text("Modelo fisiológico simplificado")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            pathwayStep(
                number: "01",
                title: "Aumento de Ca²⁺ intracelular",
                detail: "El calcio participa en la regulación de la contracción muscular."
            )

            pathwayArrow()

            pathwayStep(
                number: "02",
                title: "Contracción del músculo liso",
                detail: "Participa en los movimientos del sistema digestivo."
            )

            pathwayArrow()

            pathwayStep(
                number: "03",
                title: "Posible modulación",
                detail: "Algunos fitoquímicos pueden modificar estas rutas en modelos experimentales."
            )

            pathwayArrow()

            pathwayStep(
                number: "04",
                title: "Relajación muscular",
                detail: "Actividad antiespasmódica estudiada experimentalmente."
            )

            explanation(
                "Algunos compuestos de la manzanilla podrían modificar mecanismos que regulan las contracciones musculares del sistema digestivo."
            )

            evidenceNote(
                "No está demostrado que la apigenina bloquee directamente los canales de calcio del intestino humano."
            )
        }
    }

    // MARK: - D · MECANISMO ANTIOXIDANTE

    private var antioxidantView: some View {

        VStack(alignment: .leading, spacing: 14) {

            mechanismTitle(
                "Mecanismo antioxidante",
                symbol: "sparkles"
            )

            QuickFact(
                label: "Compuestos relacionados",
                value: "Apigenina y otros flavonoides fenólicos."
            )

            Text("Transferencia de hidrógeno")
                .font(.system(size: 18, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            ReactionStrip(
                lhs: "ArOH + R•",
                rhs: "ArO• + RH",
                note: "Reacción general de transferencia de hidrógeno"
            )

            Text("¿Qué representa cada símbolo?")
                .font(.system(size: 17, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)

            QuickFact(
                label: "ArOH",
                value: "Compuesto fenólico."
            )

            QuickFact(
                label: "R•",
                value: "Radical libre."
            )

            QuickFact(
                label: "ArO•",
                value: "Radical fenóxico que puede estabilizarse por resonancia."
            )

            QuickFact(
                label: "RH",
                value: "Producto de la transferencia de hidrógeno."
            )

            explanation(
                "Los grupos fenólicos de algunos flavonoides pueden participar en reacciones de oxidación-reducción y estabilizar radicales."
            )

            evidenceNote(
                "La actividad antioxidante experimental no demuestra que beber manzanilla reduzca el daño oxidativo en humanos."
            )
        }
    }

    // MARK: - COMPONENTES VISUALES COMPARTIDOS

    private func mechanismTitle(
        _ title: String,
        symbol: String
    ) -> some View {

        HStack(spacing: 10) {

            Image(systemName: symbol)
                .font(.system(size: 25))
                .foregroundStyle(Palette.olive)
                .frame(width: 42, height: 42)
                .background(
                    Palette.sage.opacity(0.25),
                    in: RoundedRectangle(cornerRadius: 12)
                )

            Text(title)
                .font(.system(size: 21, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)
        }
    }

    private func pathwayStep(
        number: String,
        title: String,
        detail: String
    ) -> some View {

        HStack(alignment: .top, spacing: 12) {

            Text(number)
                .font(.system(size: 15, design: .serif))
                .bold()
                .foregroundStyle(Palette.olive)
                .frame(width: 32, height: 32)
                .background(
                    Palette.sage.opacity(0.35),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(.system(size: 17, design: .serif))
                    .bold()
                    .foregroundStyle(Palette.olive)

                Text(detail)
                    .font(.system(size: 14))
                    .foregroundStyle(Palette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.sage.opacity(0.16),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }

    private func pathwayArrow() -> some View {

        Image(systemName: "arrow.down")
            .font(.system(size: 18))
            .foregroundStyle(Palette.olive)
            .frame(maxWidth: .infinity)
    }

    private func explanation(_ text: String) -> some View {

        VStack(alignment: .leading, spacing: 7) {

            Label(
                "En palabras sencillas",
                systemImage: "lightbulb"
            )
            .font(.system(size: 16, design: .serif))
            .bold()
            .foregroundStyle(Palette.olive)

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Palette.ink)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Palette.sage.opacity(0.22),
            in: RoundedRectangle(cornerRadius: 14)
        )
    }

    private func evidenceNote(_ text: String) -> some View {

        HStack(alignment: .top, spacing: 8) {

            Image(systemName: "info.circle")
                .foregroundStyle(Palette.brown)

            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(Palette.brown)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 5)
    }
}
