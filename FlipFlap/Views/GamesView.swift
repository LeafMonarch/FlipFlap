//
//  GamesView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct GamesView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private let gameCards: [GameCardItem] = [
        GameCardItem(
            title: "Nature",
            imageName: "game_environment",
            iconName: "leaf.fill",
            accentColor: Color.green
        ),
        GameCardItem(
            title: "Maths",
            imageName: "game_maths",
            iconName: "plus.forwardslash.minus",
            accentColor: Color.pink
        ),
        GameCardItem(
            title: "Sports",
            imageName: "game_pe",
            iconName: "basketball.fill",
            accentColor: Color.orange
        )
    ]

    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Games",
                onMenuTap: {
                    print("Menu tapped in Games")
                },
                onNotificationTap: {
                    print("Notification tapped in Games")
                }
            ) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        FeaturedGameBanner(imageName: "games_banner")

                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(gameCards) { card in
                                GameCardView(card: card)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
                .background(Color(red: 0.90, green: 0.94, blue: 0.96))
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
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.35))

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(height: 150)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

struct GameCardView: View {
    let card: GameCardItem

    var body: some View {
        Button {
            print("\(card.title) tapped")
        } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)

                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 260)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 62, height: 52)
                    .overlay(
                        Image(systemName: card.iconName)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(card.accentColor)
                    )
                    .padding(12)
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct GameCardItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let iconName: String
    let accentColor: Color
}
