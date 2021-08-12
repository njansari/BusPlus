//
//  Bus.swift
//  Bus
//
//  Created by Nayan Jansari on 07/08/2021.
//

import SwiftUI

struct Bus: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let location: String
    let destination: String
    let passengers: Int
    let fuel: Int
    let image: URL

    var placeholderColor: Color {
        let colors: [Color] = [.blue, .cyan, .indigo, .mint, .purple, .teal]
        return colors.randomElement()!
    }

    static let example: Bus = {
        Bus(id: 1,
            name: "Al Bus Dumbledore",
            location: "East Winterslow",
            destination: "Lower Bullington",
            passengers: 21,
            fuel: 90,
            image: URL(string: "https://www.hackingwithswift.com/samples/img/bus-1.jpg")!
        )
    }()
}
