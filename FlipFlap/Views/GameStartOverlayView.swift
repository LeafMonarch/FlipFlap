//
//  GameStartOverlayView.swift
//  FlipFlap
//
//  Created by Student on 24/04/2026.
//

import SwiftUI

import SwiftUI

struct GameStartOverlay: View {
    let game: GameCardItem
    let onClose: () -> Void
    let onStart: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                    Image(systemName: game.iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(game.accentColor)
                }
                .offset(y: -30)
                .padding(.bottom, -20)

                Text(game.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(game.accentColor)

                Text(game.overlayContent.description)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
                    .padding(.top, 6)

                Divider()
                    .padding(.top, 20)

                VStack(spacing: 12) {
                    Text(game.overlayContent.tip)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(game.accentColor)

                    HStack(spacing: 10) {
                        ForEach(0..<game.overlayContent.options.count, id: \.self) { column in
                            VStack(spacing: 8) {
                                ForEach(game.overlayContent.options[column], id: \.title) { option in
                                    PillButton(
                                        title: option.title,
                                        color: option.color,
                                        textColor: option.textColor
                                    )
                                }
                            }
                        }
                    }

                    Button(action: onStart) {
                        Text("Start")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(game.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(Color(red: 0.93, green: 0.96, blue: 0.98))
            }
            .padding(.top, 30)
            .frame(width: 280)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.12), radius: 10, y: 5)
        }
    }
}

struct PillButton: View {
    let title: String
    let color: Color
    let textColor: Color

    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(textColor)
            .frame(width: 80, height: 28)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
    }
}
