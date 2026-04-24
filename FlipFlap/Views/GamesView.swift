//
//  GamesView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

import SwiftUI

struct GamesView: View {
    @State private var selectedGame: GameCardItem? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private let gameCards: [GameCardItem] = [
        GameCardItem(
            title: "Nature",
            imageName: "game_environment",
            iconName: "leaf.fill",
            accentColor: .green,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn how to manage your waste; Food waste, Rubbish, Recyclables.",
                tip: "Tip: Where do these go?",
                options: [
                    [
                        OptionItem(title: "Plastic", color: .green, textColor: .white),
                        OptionItem(title: "Chicken", color: .green, textColor: .white)
                    ],
                    [
                        OptionItem(title: "Recyclable", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "Food Waste", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        ),
        GameCardItem(
            title: "Maths",
            imageName: "game_maths",
            iconName: "plus.forwardslash.minus",
            accentColor: .pink,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn how to add, subtract, multiply and divide two numbers!",
                tip: "Tip: What is 4 x 2?",
                options: [
                    [
                        OptionItem(title: "2", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "6", color: Color.blue.opacity(0.22), textColor: .blue)
                    ],
                    [
                        OptionItem(title: "8", color: .green, textColor: .white),
                        OptionItem(title: "4", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        ),
        GameCardItem(
            title: "Sports",
            imageName: "game_pe",
            iconName: "basketball.fill",
            accentColor: .orange,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn about sports, movement, and healthy activities.",
                tip: "Tip: Which one is a sport?",
                options: [
                    [
                        OptionItem(title: "Football", color: .orange, textColor: .white),
                        OptionItem(title: "Basketball", color: .orange, textColor: .white)
                    ],
                    [
                        OptionItem(title: "Reading", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "Sleeping", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        )
    ]

    var body: some View {
        PageLayoutView(
            title: "Games",
            onMenuTap: {
                print("Menu tapped in Games")
            },
            onNotificationTap: {
                print("Notification tapped in Games")
            }
        ) {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        FeaturedGameBanner(imageName: "games_banner")

                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(gameCards) { card in
                                GameCardView(card: card) {
                                    selectedGame = card
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 18)
                    .padding(.bottom, 110)
                }
                .background(Color(red: 0.90, green: 0.94, blue: 0.96))

                if let selectedGame {
                    GameStartOverlay(
                        game: selectedGame,
                        onClose: {
                            self.selectedGame = nil
                        },
                        onStart: {
                            print("Start \(selectedGame.title)")
                            self.selectedGame = nil
                        }
                    )
                    .transition(.opacity)
                    .zIndex(10)
                }
            }
        }
    }
}

#Preview {
    GamesView()
}

// MARK: - Components

struct FeaturedGameBanner: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

struct GameCardView: View {
    let card: GameCardItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(0.78, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 13))

                BadgeIconView(
                    iconName: card.iconName,
                    accentColor: card.accentColor
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct BadgeIconView: View {
    let iconName: String
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.white)
                .frame(width: 54, height: 50)

            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(accentColor)
        }
        .padding(.leading, 0)
        .padding(.bottom, 0)
    }
}

struct GameCardItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let iconName: String
    let accentColor: Color
    let overlayContent: GameOverlayContent
}

struct GameOverlayContent {
    let description: String
    let tip: String
    let options: [[OptionItem]]
}

struct OptionItem {
    let title: String
    let color: Color
    let textColor: Color
}
