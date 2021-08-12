//
//  LocationsFilterList.swift
//  LocationsFilterList
//
//  Created by Nayan Jansari on 10/08/2021.
//

import SwiftUI

struct LocationsFilterList: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var locations: Set<String>

    let allLocations: [String]

    private var clearAllToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button("Clear All", action: clearAll)
                .disabled(locations.isEmpty)
        }
    }

    private var doneToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: dismiss.callAsFunction)
        }
    }

    var body: some View {
        NavigationView {
            List(allLocations, id: \.self) { location in
                Button {
                    toggleLocation(location)
                } label: {
                    HStack {
                        Text(location)
                            .foregroundColor(.primary)

                        Spacer()

                        if locations.contains(location) {
                            Image(systemName: "checkmark")
                                .font(.headline)
                        }
                    }
                }
                .listRowBackground(Color.accentColor.opacity(0.15))
                .listRowSeparatorTint(.accentColor)
            }
            .navigationTitle("Filter Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                clearAllToolbarButton
                doneToolbarButton
            }
        }
    }

    private func toggleLocation(_ location: String) {
        if locations.contains(location) {
            locations.remove(location)
        } else {
            locations.insert(location)
        }
    }

    private func clearAll() {
        locations.removeAll()
    }
}

struct LocationsFilterList_Previews: PreviewProvider {
    static var previews: some View {
        LocationsFilterList(locations: .constant([]), allLocations: [])
    }
}
