//
//  CloseButton.swift
//  CloseButton
//
//  Created by Nayan Jansari on 12/08/2021.
//

import SwiftUI

struct CloseButton: UIViewRepresentable {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func makeUIView(context: Context) -> some UIView {
        let buttonAction = UIAction { _ in
            action()
        }

        let button = UIButton(type: .close, primaryAction: buttonAction)
        return button
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
