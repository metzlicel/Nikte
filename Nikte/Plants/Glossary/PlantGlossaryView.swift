import SwiftUI

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

                                        PlantDetailDestination(plant: plant.id)

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

}
