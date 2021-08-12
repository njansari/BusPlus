//
//  RoundedCornerRectangle.swift
//  RoundedCornerRectangle
//
//  Created by Nayan Jansari on 12/08/2021.
//

import SwiftUI

struct RoundedCornerRectangle: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let radii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        return Path(path.cgPath)
    }
}
