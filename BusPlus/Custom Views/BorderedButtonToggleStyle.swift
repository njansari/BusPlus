//
//  BorderedButtonToggleStyle.swift
//  BorderedButtonToggleStyle
//
//  Created by Nayan Jansari on 08/08/2021.
//

import SwiftUI

struct BorderedButtonToggleModifier: ViewModifier {
    let isOn: Bool

    @ViewBuilder func body(content: Content) -> some View {
        if isOn {
            content.buttonStyle(.borderedProminent)
        } else {
            content.buttonStyle(.bordered)
        }
    }
}

struct BorderedButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
        }
        .modifier(BorderedButtonToggleModifier(isOn: configuration.isOn))
    }
}

extension ToggleStyle where Self == BorderedButtonToggleStyle {
    static var borderedButton: BorderedButtonToggleStyle {
        BorderedButtonToggleStyle()
    }
}
