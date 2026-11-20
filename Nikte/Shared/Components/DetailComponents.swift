import SwiftUI

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
        if label != "Explicación científica" {
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
