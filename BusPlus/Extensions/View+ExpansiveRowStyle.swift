//
//  View+ExpansiveRowStyle.swift
//  View+ExpansiveRowStyle
//
//  Created by Nayan Jansari on 12/08/2021.
//

import SwiftUI

extension View {
    func expansiveListRowStyle() -> some View {
        listRowBackground(Color.clear).listRowInsets(EdgeInsets())
    }
}
