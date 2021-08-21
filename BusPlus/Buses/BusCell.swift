//
//  BusCell.swift
//  BusCell
//
//  Created by Nayan Jansari on 07/08/2021.
//

import SwiftUI

struct PlaceholderImage: View {
    let systemName: String
    let color: Color

    var body: some View {
        ZStack {
            color

            Image(systemName: systemName)
                .symbolVariant(.fill)
                .font(.system(size: 56))
                .foregroundStyle(.ultraThickMaterial)
        }
    }
}

struct BusCell: View {
    @ScaledMetric private var frame = 100

    let bus: Bus

    var body: some View {
        HStack {
            AsyncImage(url: bus.image, transaction: Transaction(animation: .default)) { phase in
                switch phase {
                    case .empty: PlaceholderImage(systemName: "bus", color: bus.placeholderColor.opacity(0.5))
                    case .success(let image): image.resizable().scaledToFit().accessibilityIgnoresInvertColors()
                    default: PlaceholderImage(systemName: "xmark", color: .red)
                }
            }
            .frame(width: frame)
            .clipShape(RoundedCornerRectangle(corners: [.bottomRight, .topRight], radius: 10))

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Label(bus.location, systemImage: "location")

                    Label(bus.destination, systemImage: "arrow.turn.down.right")
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Travelling from \(bus.location) to \(bus.destination)")

                Divider()
                    .background(.tint)
                    .padding(.vertical, 10)

                HStack(spacing: 20) {
                    Label(bus.passengers.formatted(), systemImage: "person.2")
                        .accessibilityLabel("Number of passengers: \(bus.passengers)")

                    Label(bus.fuel.formatted(.percent), systemImage: "fuelpump")
                        .accessibilityLabel("Fuel is at \(bus.fuel.formatted(.percent))")
                }
            }
            .symbolRenderingMode(.hierarchical)
            .padding(.horizontal)
        }
        .foregroundColor(.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.01)
        .accessibilityElement(children: .combine)
        .frame(height: frame)
    }
}

struct BusCell_Previews: PreviewProvider {
    @Namespace static private var namespace

    static var previews: some View {
        BusCell(bus: .example)
    }
}
