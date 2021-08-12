//
//  TicketView.swift
//  TicketView
//
//  Created by Nayan Jansari on 09/08/2021.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct TicketView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var ticketInformation: TicketInformation

    @State private var context = CIContext()
    @State private var filter = CIFilter.qrCodeGenerator()

    private var qrCode: Image {
        let data = Data(ticketInformation.identifier.utf8)
        filter.message = data

        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        }

        return Image(systemName: "xmark")
    }

    private var ticket: some View {
        VStack(spacing: 0) {
            Text(ticketInformation.name)
                .font(.title2.bold())

            qrCode
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding([.horizontal, .top])

            Text("#\(ticketInformation.reference)")
                .font(.callout.monospacedDigit())
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 10)
    }

    var body: some View {
        NavigationView {
            ticket
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.accentColor.opacity(0.15))
                .navigationTitle("Ticket")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    CloseButton(action: dismiss.callAsFunction)
                }
                .dynamicTypeSize(.large)
        }
    }
}

struct TicketView_Previews: PreviewProvider {
    static let ticketInformation: TicketInformation = {
        let info = TicketInformation()
        info.name = "John Appleseed"
        info.reference = "12345"
        return info
    }()

    static var previews: some View {
        TicketView(ticketInformation: ticketInformation)
    }
}
