//
//  BusesView.swift
//  BusPlus
//
//  Created by Nayan Jansari on 07/08/2021.
//

import SwiftUI

struct BusesView: View {
    private enum SortOrder: String, CaseIterable {
        case name
        case passengers
        case fuel
    }

    @AppStorage("sortOrder") private var sortOrder: SortOrder = .name

    @State private var sortDirection: [SortOrder: Bool] = [.name: true, .passengers: true, .fuel: true]

    @State private var buses: [Bus] = []

    @State private var favourites: Set<String> = {
        let array = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
        return Set(array)
    }()

    @State private var searchText = ""
    @State private var showFavouritesOnly = false
    @State private var showingLocationsFilter = false
    @State private var filteredLocations: Set<String> = []

    private var filteredBuses: [Bus] {
        let searchFields: [KeyPath<Bus, String>] = [\.name, \.location, \.destination]

        let filtered = buses.filter { bus in
            let search: Bool = {
                for field in searchFields {
                    if bus[keyPath: field].localizedCaseInsensitiveContains(searchText) {
                        return true
                    }
                }

                return searchText.isEmpty
            }()

            let favourites = showFavouritesOnly ? favourites.contains(bus.name) : true

            let locations: Bool = {
                for location in filteredLocations {
                    if bus.location == location || bus.destination == location {
                        return true
                    }
                }

                return filteredLocations.isEmpty
            }()

            return search && favourites && locations
        }

        let sorted = filtered.sorted { lhb, rhb in
            switch sortOrder {
                case .name: return directionSorted(lhb.name, rhb.name)
                case .passengers: return directionSorted(lhb.passengers, rhb.passengers)
                case .fuel: return directionSorted(lhb.fuel, rhb.fuel)
            }
        }

        return sorted
    }

    private var allLocations: [String] {
        let locations = buses.map(\.location) + buses.map(\.destination)
        let reducedLocations = Set(locations)
        return reducedLocations.sorted()
    }

    private var filterLocationsLabel: String {
        if filteredLocations.isEmpty {
            return "Filter Locations"
        } else {
            let locationsCount = filteredLocations.count
            let locationsLabel = locationsCount == 1 ? "Location" : "Locations"
            return "\(locationsCount) \(locationsLabel)"
        }
    }

    private var filterLocations: Binding<Bool> {
        Binding {
            !filteredLocations.isEmpty
        } set: { _ in
            showingLocationsFilter = true
        }
    }

    private var sortOrderDirection: Binding<SortOrder> {
        Binding {
            sortOrder
        } set: { newValue in
            if newValue == sortOrder {
                sortDirection[newValue]?.toggle()
            } else {
                sortOrder = newValue
                sortDirection[newValue] = true
            }
        }
    }

    private var filterButtons: some View {
        HStack {
            Toggle("Favourites Only", isOn: $showFavouritesOnly.animation())

            Toggle(filterLocationsLabel, isOn: filterLocations.animation())
        }
        .toggleStyle(.borderedButton)
        .expansiveListRowStyle()
    }

    private var sortOrderMenu: some View {
        Menu {
            Picker("Sort Order", selection: sortOrderDirection.animation()) {
                ForEach(SortOrder.allCases, id: \.self, content: sortOrderLabel)
            }
        } label: {
            Label("Sort Order", systemImage: "arrow.up.arrow.down")
        }
    }

    private var busesList: some View {
        ForEach(filteredBuses) { bus in
            Section {
                BusCell(bus: bus)
                    .expansiveListRowStyle()
                    .swipeActions(edge: .leading) {
                        Button {
                            toggleFavourite(bus: bus)
                        } label: {
                            if favourites.contains(bus.name) {
                                Label("Unfavourite", systemImage: "star")
                                    .symbolVariant(.slash)
                            } else {
                                Label("Favourite", systemImage: "star")
                            }
                        }
                        .tint(favourites.contains(bus.name) ? nil : .accentColor)
                    }
            } header: {
                HStack {
                    Text(bus.name)

                    if favourites.contains(bus.name) {
                        Image(systemName: "star")
                            .symbolVariant(.fill)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .headerProminence(.increased)
            .animation(nil, value: buses)
        }
    }

    var body: some View {
        NavigationView {
            List {
                filterButtons
                busesList
            }
            .listStyle(.insetGrouped)
            .animation(.default, value: buses)
            .searchable(text: $searchText.animation())
            .refreshable {
                await fetchBuses()
            }
            .navigationTitle("Bus+")
            .toolbar {
                sortOrderMenu
            }
            .sheet(isPresented: $showingLocationsFilter) {
                LocationsFilterList(locations: $filteredLocations, allLocations: allLocations)
            }
            .task {
                if buses.isEmpty {
                    await fetchBuses()
                }
            }
        }
    }

    private func fetchBuses() async {
        guard let url = URL(string: "https://hws.dev/bus-timetable") else { return }

        do {
            buses = try await URLSession.shared.decodeJSON(ofType: [Bus].self, from: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func toggleFavourite(bus: Bus) {
        if favourites.contains(bus.name) {
            favourites.remove(bus.name)
        } else {
            favourites.insert(bus.name)
        }

        UserDefaults.standard.set(Array(favourites), forKey: "favourites")
    }

    private func directionSorted<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool {
        if sortDirection[sortOrder, default: true] {
            return lhs < rhs
        } else {
            return lhs > rhs
        }
    }

    @ViewBuilder private func sortOrderLabel(for order: SortOrder) -> some View {
        if order == sortOrder {
            let direction = sortDirection[order, default: true] ? "up" : "down"
            let directionLabel = sortDirection[order, default: true] ? "ascending" : "descending"

            Label(order.rawValue.localizedCapitalized, systemImage: "chevron.\(direction)")
                .accessibilityLabel("Sorted \(directionLabel) by \(order.rawValue.localizedCapitalized)")
        } else {
            Text(order.rawValue.localizedCapitalized)
        }
    }
}

struct BusesView_Previews: PreviewProvider {
    static var previews: some View {
        BusesView()
    }
}
