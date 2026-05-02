//
//  GameCategoryView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 02/05/2026.
//

import SwiftUI

struct GameCategoryView: View {
    let game: GameCardItem
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: GameCategoryItem? = nil

    private let categories = [
        GameCategoryItem(
            title: "Waste\nManagement",
            imageName: "waste_management_category"
        ),
        GameCategoryItem(
            title: "Animal Food\nChain",
            imageName: "animal_food_chain_category"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Image(game.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 20)
                        .padding(.top, 28)

                    VStack(spacing: 16) {
                        ForEach(categories) { category in
                            CategoryRowCard(
                                category: category,
                                isSelected: selectedCategory?.id == category.id
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)

                    Spacer(minLength: 120)
                }
            }
            .background(Color.white)

            Button {
                if let selectedCategory {
                    print("Start \(selectedCategory.title)")
                }
            } label: {
                Text("Start")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 88)
                    .background(
                        LinearGradient(
                            colors: selectedCategory == nil
                            ? [
                                Color.gray.opacity(0.45),
                                Color.gray.opacity(0.35)
                            ]
                            : [
                                Color(red: 0.25, green: 0.63, blue: 1.0),
                                Color(red: 0.05, green: 0.79, blue: 0.91)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .disabled(selectedCategory == nil)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar) // hides bottom navbar
    }

    private var header: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 2) {
                Text("Choose Category")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                Text(game.title.uppercased())
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)

            Button {
                dismiss()
            } label: {
                Text("x")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.trailing, 36)
            }
        }
        .frame(height: 120)
        .background(game.accentColor)
    }
}

struct CategoryRowCard: View {
    let category: GameCategoryItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(category.title)
                    .font(.system(size: 23, weight: .heavy))
                    .foregroundColor(.white)
                    .lineSpacing(7)
                    .padding(.leading, 22)

                Spacer()

                Image(category.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 135, height: 100)
                    .padding(.trailing, 10)
            }
            .frame(height: 118)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.36, green: 0.79, blue: 0.33))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected ? Color.blue : Color.clear,
                        lineWidth: 5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.22), radius: 0, x: 5, y: 6)
        }
        .buttonStyle(.plain)
    }
}

struct GameCategoryItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
}

#Preview {
    NavigationStack {
        GameCategoryView(
            game: GameCardItem(
                title: "Nature",
                imageName: "game_environment",
                iconName: "leaf.fill",
                accentColor: .green,
                overlayContent: GameOverlayContent(
                    description: "",
                    tip: "",
                    options: []
                )
            )
        )
    }
}
