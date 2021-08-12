//
//  MyTicketView.swift
//  MyTicketView
//
//  Created by Nayan Jansari on 09/08/2021.
//

import SwiftUI

struct MyTicketView: View {
    private enum Field {
        case name
        case reference
    }

    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject var ticketInformation: TicketInformation

    @FocusState private var field: Field?

    @State private var showingTicket = false

    @Binding var brightness: Double

    private var name: Binding<PersonNameComponents> {
        Binding {
            do {
                return try PersonNameComponents(ticketInformation.name)
            } catch {
                var nameComponents = PersonNameComponents()
                nameComponents.givenName = ticketInformation.name
                return nameComponents
            }
        } set: {
            ticketInformation.name = $0.formatted()
        }
    }

    private var referenceNumber: Binding<Int?> {
        Binding {
            Int(ticketInformation.reference)
        } set: {
            ticketInformation.reference = $0?.formatted() ?? ""
        }
    }

    private var nameSection: some View {
        Section("Name") {
            TextField("Name", value: name, format: .name(style: .medium), prompt: Text("John Appleseed"))
                .textContentType(.name)
                .submitLabel(.next)
                .focused($field, equals: .name)
                .listRowBackground(Color.accentColor.opacity(0.15))
        }
    }

    private var referenceSection: some View {
        Section("Reference Number") {
            TextField("Reference Number", value: referenceNumber, format: .number, prompt: Text("12345"))
                .keyboardType(.numberPad)
                .focused($field, equals: .reference)
                .listRowBackground(Color.accentColor.opacity(0.15))
        }
    }

    private var viewTicketButton: some View {
        Button(action: showQR) {
            Text("View Ticket")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 30)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!ticketInformation.isValid)
        .expansiveListRowStyle()
    }

    private var doneKeyboardToolbarButton: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()

            Button("Done", action: dismissKeyboard)
                .font(.headline)
        }
    }

    private var ticketView: some View {
        TicketView(ticketInformation: ticketInformation)
            .onAppear {
                brightness = UIScreen.main.brightness
                UIScreen.main.brightness = 1
            }
            .onChange(of: scenePhase, perform: scenePhaseChanged)
    }

    var body: some View {
        NavigationView {
            Form {
                nameSection
                referenceSection
                viewTicketButton
            }
            .onSubmit(fieldSubmitted)
            .navigationTitle("My Ticket")
            .toolbar {
                doneKeyboardToolbarButton
            }
            .fullScreenCover(isPresented: $showingTicket, onDismiss: restoreBrightness) {
                ticketView
            }
        }
    }

    private func fieldSubmitted() {
        switch field {
            case .name: field = .reference
            default: field = nil
        }
    }

    private func dismissKeyboard() {
        field = nil
    }

    private func showQR() {
        dismissKeyboard()
        showingTicket = true
    }

    private func restoreBrightness() {
        UIScreen.main.brightness = brightness
    }

    private func scenePhaseChanged(to newValue: ScenePhase) {
        switch newValue {
            case .active: UIScreen.main.brightness = 1
            default: restoreBrightness()
        }
    }
}

struct MyTicketView_Previews: PreviewProvider {
    static var previews: some View {
        MyTicketView(ticketInformation: TicketInformation(), brightness: .constant(0.5))
    }
}
