import SwiftUI

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

