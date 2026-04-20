//
//  GamesView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct GamesView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private let gameCards: [GameCardItem] = [
        GameCardItem(
            title: "Nature",
            imageName: "game_environment",
            iconName: "leaf.fill",
            accentColor: .green
        ),
        GameCardItem(
            title: "Maths",
            imageName: "game_maths",
            iconName: "plus.forwardslash.minus",
            accentColor: .pink
        ),
        GameCardItem(
            title: "Sports",
            imageName: "game_pe",
            iconName: "basketball.fill",
            accentColor: .orange
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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    FeaturedGameBanner(imageName: "games_banner")

                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(gameCards) { card in
                            GameCardView(card: card)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 110)
            }
            .background(Color(red: 0.90, green: 0.94, blue: 0.96))
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

    var body: some View {
        Button {
            print("\(card.title) tapped")
        } label: {
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
}
