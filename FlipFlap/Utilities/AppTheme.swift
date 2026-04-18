//
//  AppColours.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import SwiftUI

enum AppTheme {
    enum Colors {
        // MARK: - Brand Palette
        static let bluePrimary = Color(red: 24/255, green: 205/255, blue: 251/255)
        static let blueSecondary = Color(red: 96/255, green: 168/255, blue: 255/255)

        // MARK: - Semantic Colors
        static let splashGradientTop = blueSecondary
        static let splashGradientBottom = bluePrimary
        static let onSplash = Color.white
    }

    enum Typography {
        // Base font weights
        static let regular = Font.custom("Poppins-Regular", size: 16)
        static let medium = Font.custom("Poppins-Medium", size: 16)
        static let semiBold = Font.custom("Poppins-SemiBold", size: 16)
        static let bold = Font.custom("Poppins-Bold", size: 16)
        static let extraBold = Font.custom("Poppins-ExtraBold", size: 16)

        // Semantic text styles
        static let splashTitle = Font.custom("Poppins-ExtraBold", size: 46)
        static let screenTitle = Font.custom("Poppins-Bold", size: 28)
        static let sectionTitle = Font.custom("Poppins-SemiBold", size: 20)
        static let body = Font.custom("Poppins-Regular", size: 16)
        static let caption = Font.custom("Poppins-Medium", size: 12)
    }
}
