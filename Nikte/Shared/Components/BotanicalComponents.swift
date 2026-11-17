import SwiftUI

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

