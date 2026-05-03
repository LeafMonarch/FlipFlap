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

    @State private var selectedCategoryID: String? = nil
    @State private var showNatureWasteGame = false
    @State private var showAnimalFoodChainGame = false
    @State private var showMathsAdditionGame = false
    @State private var showMathsSubtractionGame = false

    private var categories: [GameCategoryItem] {
        if game.title == "Maths" {
            return [
                GameCategoryItem(id: "addition", title: "Addition", imageName: "addition_category", backgroundColor: .red),
                GameCategoryItem(id: "subtraction", title: "Subtraction", imageName: "subtraction_category", backgroundColor: .red)
            ]
        } else if game.title == "Sports" {
            return [
                GameCategoryItem(id: "jumping-jacks", title: "Jumping\nJacks", imageName: "jumping_jacks_category", backgroundColor: .orange),
                GameCategoryItem(id: "running-in-place", title: "Running\nIn Place", imageName: "running_in_place_category", backgroundColor: .orange)
            ]
        } else {
            return [
                GameCategoryItem(
                    id: "waste-management",
                    title: "Waste\nManagement",
                    imageName: "waste_management_category",
                    backgroundColor: Color(red: 0.36, green: 0.79, blue: 0.33)
                ),
                GameCategoryItem(
                    id: "animal-food-chain",
                    title: "Animal Food\nChain",
                    imageName: "animal_food_chain_category",
                    backgroundColor: Color(red: 0.36, green: 0.79, blue: 0.33)
                )
            ]
        }
    }

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
                                isSelected: selectedCategoryID == category.id
                            ) {
                                selectedCategoryID = category.id
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
                if selectedCategoryID == "waste-management" && game.title == "Nature" {
                    showNatureWasteGame = true
                } else if selectedCategoryID == "animal-food-chain" && game.title == "Nature" {
                    showAnimalFoodChainGame = true
                } else if selectedCategoryID == "addition" && game.title == "Maths" {
                    showMathsAdditionGame = true
                } else if selectedCategoryID == "subtraction" && game.title == "Maths" {
                    showMathsSubtractionGame = true
                } else if let selectedCategoryID {
                    print("Start \(selectedCategoryID)")
                }
            } label: {
                Text("Start")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 88)
                    .background(selectedCategoryID == nil ? Color.gray.opacity(0.45) : Color.blue)
            }
            .disabled(selectedCategoryID == nil)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showNatureWasteGame) {
            NatureWasteGameView()
        }
        .navigationDestination(isPresented: $showAnimalFoodChainGame) {
            NatureAnimalFoodChainGameView()
        }
        .navigationDestination(isPresented: $showMathsAdditionGame) {
            MathsAdditionGameView()
        }
        .navigationDestination(isPresented: $showMathsSubtractionGame) {
            MathsSubtractionGameView()
        }
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
        .background(game.title == "Maths" ? Color.red : game.accentColor)
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
            .background(category.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 6)
            )
            .shadow(
                color: isSelected ? Color.blue.opacity(0.45) : Color.black.opacity(0.22),
                radius: isSelected ? 8 : 0,
                x: isSelected ? 0 : 5,
                y: isSelected ? 3 : 6
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct GameCategoryItem: Identifiable, Equatable {
    let id: String
    let title: String
    let imageName: String
    let backgroundColor: Color
}
