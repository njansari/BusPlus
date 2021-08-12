//
//  BusPlusApp.swift
//  BusPlus
//
//  Created by Nayan Jansari on 07/08/2021.
//

import SwiftUI

@main struct BusPlusApp: App {
    @StateObject private var ticketInformation = TicketInformation()

    var body: some Scene {
        WindowGroup {
            ContentView(ticketInformation: ticketInformation)
        }
    }
}
