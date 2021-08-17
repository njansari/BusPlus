//
//  ContentView.swift
//  ContentView
//
//  Created by Nayan Jansari on 11/08/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var ticketInformation: TicketInformation

    @State private var brightness: Double = UIScreen.main.brightness

    init(ticketInformation: TicketInformation) {
        self.ticketInformation = ticketInformation

        let backgroundColor: UIColor = .tintColor.withAlphaComponent(0.15)

        UITableView.appearance().backgroundColor = backgroundColor

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = backgroundColor
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = backgroundColor

        UITabBar.appearance().standardAppearance = tabBarAppearance

        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.backgroundColor = backgroundColor

        UIToolbar.appearance().standardAppearance = toolbarAppearance

        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        TabView {
            BusesView()
                .tabItem {
                    Label("Buses", systemImage: "bus")
                }

            MyTicketView(ticketInformation: ticketInformation, brightness: $brightness)
                .tabItem {
                    Label("My Ticket", systemImage: "qrcode")
                }
                .badge(ticketInformation.isValid ? .none : "!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ticketInformation: TicketInformation())
    }
}
