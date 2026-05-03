//
//  NatureAnimalFoodChainGameView.swift
//  FlipFlap
//
//  Created by Raph on 03/05/2026.
//

import SwiftUI

struct NatureAnimalFoodChainGameView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var questionIndex = 0
    @State private var score = 0
    @State private var currentItems: [AnimalItem] = []
    @State private var hasChecked = false

    private let mainGreen = Color(red: 0.31, green: 0.78, blue: 0.31)

    private let questions: [AnimalQuestion] = [
        AnimalQuestion(
            question: "What type of eater are these animals?",
            items: [
                AnimalItem(name: "Bear", imageName: "animal_bear", correctBin: .omnivore, xRatio: 0.23, yRatio: 0.72),
                AnimalItem(name: "Rabbit", imageName: "animal_rabbit", correctBin: .herbivore, xRatio: 0.50, yRatio: 0.76),
                AnimalItem(name: "Lion", imageName: "animal_lion", correctBin: .carnivore, xRatio: 0.77, yRatio: 0.72)
            ]
        ),
        AnimalQuestion(
            question: "Sort these animals correctly!",
            items: [
                AnimalItem(name: "Pig", imageName: "animal_pig", correctBin: .omnivore, xRatio: 0.23, yRatio: 0.72),
                AnimalItem(name: "Cow", imageName: "animal_cow", correctBin: .herbivore, xRatio: 0.50, yRatio: 0.76),
                AnimalItem(name: "Tiger", imageName: "animal_tiger", correctBin: .carnivore, xRatio: 0.77, yRatio: 0.72)
            ]
        )
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .frame(height: 180)

                    questionCard
                        .padding(.top, 42)

                    animalBinsRow
                        .padding(.top, 32)

                    animalResultsRow
                        .padding(.top, 12)

                    Spacer()

                    bottomButton
                }
                .ignoresSafeArea(edges: .top)

                ForEach($currentItems) { $item in
                    DraggableAnimalItem(
                        item: $item,
                        screenSize: geo.size,
                        isLocked: hasChecked
                    ) { dropPoint in
                        handleDrop(
                            item: &item,
                            dropPoint: dropPoint,
                            screenWidth: geo.size.width,
                            screenHeight: geo.size.height
                        )
                    }
                }
            }
            .onAppear {
                loadQuestion()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }

    private var header: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 6) {
                Text("\(questionIndex + 1) / \(questions.count)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                Text("Animal Food\nChain")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(0)
            }
            .padding(.top, 52)
            .frame(maxWidth: .infinity)

            Button {
                dismiss()
            } label: {
                Text("x")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.trailing, 34)
                    .padding(.top, 60)
            }
        }
        .background(mainGreen)
    }

    private var questionCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(mainGreen)
                .frame(height: 150)
                .shadow(color: .black.opacity(0.22), radius: 0, x: 6, y: 7)

            VStack(spacing: 26) {
                Text("Question \(questionIndex + 1):")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text(questions[questionIndex].question)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, 14)
        }
        .padding(.horizontal, 48)
    }

    private var animalBinsRow: some View {
        HStack(spacing: 14) {
            AnimalBinCard(title: "Omnivore", imageName: "omnivore_bin", green: mainGreen)
            AnimalBinCard(title: "Herbivore", imageName: "herbivore_bin", green: mainGreen)
            AnimalBinCard(title: "Carnivore", imageName: "carnivore_bin", green: mainGreen)
        }
        .padding(.horizontal, 48)
    }

    private var animalResultsRow: some View {
        HStack(spacing: 14) {
            AnimalResultLabel(bin: .omnivore, items: currentItems, hasChecked: hasChecked)
            AnimalResultLabel(bin: .herbivore, items: currentItems, hasChecked: hasChecked)
            AnimalResultLabel(bin: .carnivore, items: currentItems, hasChecked: hasChecked)
        }
        .padding(.horizontal, 48)
    }

    private var canUseBottomButton: Bool {
        hasChecked || currentItems.allSatisfy { $0.selectedBin != nil }
    }

    private var bottomButton: some View {
        Button {
            if hasChecked {
                goToNextQuestion()
            } else {
                checkAnswers()
            }
        } label: {
            Text(hasChecked ? nextButtonTitle : "Check")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .disabled(!canUseBottomButton)
        .opacity(canUseBottomButton ? 1 : 0.5)
    }

    private var nextButtonTitle: String {
        questionIndex == questions.count - 1 ? "Finish" : "Next"
    }

    private func loadQuestion() {
        currentItems = questions[questionIndex].items
        hasChecked = false
    }

    private func checkAnswers() {
        hasChecked = true
        score += currentItems.filter { $0.selectedBin == $0.correctBin }.count
    }

    private func goToNextQuestion() {
        if questionIndex < questions.count - 1 {
            questionIndex += 1
            loadQuestion()
        } else {
            print("Animal Food Chain finished. Score: \(score)")
            dismiss()
        }
    }

    private func handleDrop(
        item: inout AnimalItem,
        dropPoint: CGPoint,
        screenWidth: CGFloat,
        screenHeight: CGFloat
    ) {
        let binTop = screenHeight * 0.45
        let binBottom = screenHeight * 0.63

        guard dropPoint.y >= binTop && dropPoint.y <= binBottom else {
            item.offset = .zero
            item.selectedBin = nil
            return
        }

        if dropPoint.x < screenWidth / 3 {
            item.selectedBin = .omnivore
            item.xRatio = 0.23
        } else if dropPoint.x < (screenWidth / 3) * 2 {
            item.selectedBin = .herbivore
            item.xRatio = 0.50
        } else {
            item.selectedBin = .carnivore
            item.xRatio = 0.77
        }

        item.yRatio = 0.54
        item.offset = .zero
    }
}

struct AnimalBinCard: View {
    let title: String
    let imageName: String
    let green: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .heavy))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 64)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 118)
        .background(green)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.22), radius: 0, x: 6, y: 7)
    }
}

struct AnimalResultLabel: View {
    let bin: AnimalBin
    let items: [AnimalItem]
    let hasChecked: Bool

    private var droppedItems: [AnimalItem] {
        items.filter { $0.selectedBin == bin }
    }

    var body: some View {
        VStack(spacing: 6) {
            ForEach(droppedItems) { item in
                Text(item.name)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(labelColor(for: item))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 36, alignment: .top)
    }

    private func labelColor(for item: AnimalItem) -> Color {
        guard hasChecked else {
            return Color.gray.opacity(0.55)
        }

        return item.selectedBin == item.correctBin ? .green : .red
    }
}

struct DraggableAnimalItem: View {
    @Binding var item: AnimalItem
    let screenSize: CGSize
    let isLocked: Bool
    let onDrop: (CGPoint) -> Void

    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 78, height: 78)
            .position(
                x: screenSize.width * item.xRatio + item.offset.width,
                y: screenSize.height * item.yRatio + item.offset.height
            )
            .gesture(
                isLocked ? nil :
                    DragGesture()
                    .onChanged { value in
                        item.offset = value.translation
                    }
                    .onEnded { value in
                        onDrop(value.location)
                    }
            )
    }
}

struct AnimalQuestion {
    let question: String
    let items: [AnimalItem]
}

struct AnimalItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let correctBin: AnimalBin
    var xRatio: CGFloat
    var yRatio: CGFloat
    var selectedBin: AnimalBin? = nil
    var offset: CGSize = .zero
}

enum AnimalBin {
    case omnivore
    case herbivore
    case carnivore
}

#Preview {
    NavigationStack {
        NatureAnimalFoodChainGameView()
    }
}
