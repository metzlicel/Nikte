import SwiftUI

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

