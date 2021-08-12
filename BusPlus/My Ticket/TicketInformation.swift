//
//  TicketInformation.swift
//  TicketInformation
//
//  Created by Nayan Jansari on 09/08/2021.
//

import SwiftUI

@MainActor class TicketInformation: ObservableObject {
    enum Kind: String, CaseIterable {
        case child
        case student
        case adult

        var price: Double {
            switch self {
                case .adult: return 3.5
                case .child: return 1
                case .student: return 2
            }
        }
    }

    @AppStorage("name") var name = ""
    @AppStorage("reference") var reference = ""
    @AppStorage("kind") var kind: Kind = .adult

    var identifier: String {
        "\(name)#\(reference)"
    }

    var isValid: Bool {
        !name.isEmpty && Int(reference) != nil
    }

    var kindDescription: String {
        let kindLabel = kind.rawValue.localizedCapitalized

        let currencyCode = Locale.current.currencyCode ?? "gbp"
        let priceLabel = kind.price.formatted(.currency(code: currencyCode))

        return "\(kindLabel) - \(priceLabel)"
    }
}
