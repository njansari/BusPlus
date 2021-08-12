//
//  TicketInformation.swift
//  TicketInformation
//
//  Created by Nayan Jansari on 09/08/2021.
//

import SwiftUI

@MainActor class TicketInformation: ObservableObject {
    @AppStorage("name") var name = ""
    @AppStorage("reference") var reference = ""

    var identifier: String {
        "\(name)#\(reference)"
    }

    var isValid: Bool {
        !name.isEmpty && Int(reference) != nil
    }
}
