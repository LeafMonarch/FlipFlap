//
//  NatureWasteGameView.swift
//  FlipFlap
//
//  Created by Raph on 03/05/2026.
//

import SwiftUI

struct NatureWasteGameView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var questionIndex = 0
    @State private var score = 0
    @State private var currentItems: [WasteItem] = []

    private let mainGreen = Color(red: 0.31, green: 0.78, blue: 0.31)

    private let questions: [WasteQuestion] = [
        WasteQuestion(
            question: "Where do these waste go?",
            items: [
                WasteItem(name: "Straws", imageName: "trash_straws", correctBin: .rubbish, xRatio: 0.23, yRatio: 0.70),
                WasteItem(name: "Bottle", imageName: "trash_bottle", correctBin: .recycle, xRatio: 0.50, yRatio: 0.75),
                WasteItem(name: "Banana", imageName: "trash_banana", correctBin: .organic, xRatio: 0.77, yRatio: 0.70)
            ]
        ),
        WasteQuestion(
            question: "Sort these into the correct bins!",
            items: [
                WasteItem(name: "Paper Ball", imageName: "trash_paper", correctBin: .rubbish, xRatio: 0.23, yRatio: 0.70),
                WasteItem(name: "Bone", imageName: "trash_bone", correctBin: .organic, xRatio: 0.50, yRatio: 0.75),
                WasteItem(name: "Cardboard", imageName: "trash_cardboard", correctBin: .recycle, xRatio: 0.77, yRatio: 0.70)
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

                    binsRow
                        .padding(.top, 32)

                    Spacer()

                    checkButton
                }
                .ignoresSafeArea(edges: .top)

                ForEach($currentItems) { $item in
                    if !item.isPlaced {
                        DraggableWasteItem(
                            item: $item,
                            screenSize: geo.size
                        ) { dropPoint in
                            handleDrop(
                                item: &item,
                                dropPoint: dropPoint,
                                screenWidth: geo.size.width
                            )
                        }
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

                Text("Waste\nManagement")
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

    private var binsRow: some View {
        HStack(spacing: 14) {
            BinCard(title: "Rubbish", imageName: "bin_rubbish", green: mainGreen)
            BinCard(title: "Organic", imageName: "bin_organic", green: mainGreen)
            BinCard(title: "Recycle", imageName: "bin_recycle", green: mainGreen)
        }
        .padding(.horizontal, 48)
    }

    private var checkButton: some View {
        Button {
            goToNextQuestion()
        } label: {
            Text(questionIndex == questions.count - 1 ? "Finish" : "Check")
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
    }

    private func loadQuestion() {
        currentItems = questions[questionIndex].items
    }

    private func goToNextQuestion() {
        if questionIndex < questions.count - 1 {
            questionIndex += 1
            loadQuestion()
        } else {
            print("Game finished. Score: \(score)")
            dismiss()
        }
    }

    private func handleDrop(item: inout WasteItem, dropPoint: CGPoint, screenWidth: CGFloat) {
        let binTop: CGFloat = 360
        let binBottom: CGFloat = 510

        guard dropPoint.y >= binTop && dropPoint.y <= binBottom else {
            item.offset = .zero
            return
        }

        let selectedBin: WasteBin

        if dropPoint.x < screenWidth / 3 {
            selectedBin = .rubbish
        } else if dropPoint.x < (screenWidth / 3) * 2 {
            selectedBin = .organic
        } else {
            selectedBin = .recycle
        }

        if selectedBin == item.correctBin {
            item.isPlaced = true
            score += 1
        } else {
            item.offset = .zero
        }
    }
}

struct BinCard: View {
    let title: String
    let imageName: String
    let green: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 72)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 118)
        .background(green)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.22), radius: 0, x: 6, y: 7)
    }
}

struct DraggableWasteItem: View {
    @Binding var item: WasteItem
    let screenSize: CGSize
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

struct WasteQuestion {
    let question: String
    let items: [WasteItem]
}

struct WasteItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let correctBin: WasteBin
    let xRatio: CGFloat
    let yRatio: CGFloat
    var offset: CGSize = .zero
    var isPlaced = false
}

enum WasteBin {
    case rubbish
    case organic
    case recycle
}

#Preview {
    NavigationStack {
        NatureWasteGameView()
    }
}
