//
//  FontExtension.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 03.02.2025.
//

import SwiftUI
import UIKit

extension Font {
    static func montserrat(_ type: MontserratFontType, size: CGFloat) -> Font {
        return Font.custom(type.rawValue, size: size)
    }
}

extension UIFont {
    static func montserrat(_ type: MontserratFontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

enum MontserratFontType: String {
    case regular = "Montserrat-Regular"
    case bold = "Montserrat-Bold"
    case light = "Montserrat-Light"
    case semibold = "Montserrat-SemiBold"
}
