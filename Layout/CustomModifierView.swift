//
//  CustomModifierView.swift
//  CART
//
//  Created by t&a on 2022/12/04.
//

import SwiftUI

// MARK: - 丸型背景色
struct BackRoundColor: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .frame(width: 40, height:40)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(50)
                .compositingGroup()
                .shadow(color: .gray,radius: 3, x: 2, y: 2)
    }
}

extension View {
    func BackRoundColor(color:Color) -> some View {
        modifier(CART.BackRoundColor(backgroundColor: color))
    }
}
