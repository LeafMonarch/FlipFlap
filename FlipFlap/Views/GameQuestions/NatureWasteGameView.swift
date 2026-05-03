//
//  NatureAnimalFoodChainGameView.swift
//  FlipFlap
//
//  Created by Raph on 02/05/2026.
//

import SwiftUI
import SwiftData

struct NatureWasteGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appSession: AppSession
    
    @Query(sort: \GameScore.playedAt, order: .reverse) private var savedScores: [GameScore]

    @State private var questionIndex = 0
    @State private var score = 0
    @State private var currentItems: [WasteItem] = []
    @State private var hasChecked = false
    
    private func saveGameScore(gameName: String, correct: Int, total: Int) {
        guard let student = appSession.authenticatedStudent else {
            print("No logged in student")
            return
        }

        let gameScore = GameScore(
            gameName: gameName,
            correctAnswers: correct,
            wrongAnswers: total - correct,
            totalQuestions: total,
            studentID: student.id,
            studentName: student.name
        )

        modelContext.insert(gameScore)

        do {
            try modelContext.save()
            print("Score saved")

            print("----- RAW SAVED SCORES -----")

            for score in savedScores {
                print("""
                Game: \(score.gameName)
                Correct: \(score.correctAnswers)
                Wrong: \(score.wrongAnswers)
                Total: \(score.totalQuestions)
                Student ID: \(score.studentID)
                Student Name: \(score.studentName)
                Played At: \(score.playedAt)
                -------------------------
                """)
            }

        } catch {
            print("Could not save score: \(error.localizedDescription)")
        }
    }

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

                    resultsRow
                        .padding(.top, 12)

                    Spacer()

                    bottomButton
                }
                .ignoresSafeArea(edges: .top)

                ForEach($currentItems) { $item in
                    DraggableWasteItem(
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

    private var resultsRow: some View {
        HStack(spacing: 14) {
            ResultLabel(bin: .rubbish, items: currentItems, hasChecked: hasChecked)
            ResultLabel(bin: .organic, items: currentItems, hasChecked: hasChecked)
            ResultLabel(bin: .recycle, items: currentItems, hasChecked: hasChecked)
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
            let totalItems = questions.reduce(0) { $0 + $1.items.count }

            saveGameScore(
                gameName: "Waste Management",
                correct: score,
                total: totalItems
            )

            dismiss()
        }
    }

    private func handleDrop(
        item: inout WasteItem,
        dropPoint: CGPoint,
        screenWidth: CGFloat,
        screenHeight: CGFloat
    ) {
        let binTop = screenHeight * 0.46
        let binBottom = screenHeight * 0.61

        guard dropPoint.y >= binTop && dropPoint.y <= binBottom else {
            item.offset = .zero
            item.selectedBin = nil
            return
        }

        let selectedBin: WasteBin

        if dropPoint.x < screenWidth / 3 {
            selectedBin = .rubbish
            item.xRatio = 0.23
        } else if dropPoint.x < (screenWidth / 3) * 2 {
            selectedBin = .organic
            item.xRatio = 0.50
        } else {
            selectedBin = .recycle
            item.xRatio = 0.77
        }

        item.selectedBin = selectedBin
        item.yRatio = 0.55
        item.offset = .zero
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

struct ResultLabel: View {
    let bin: WasteBin
    let items: [WasteItem]
    let hasChecked: Bool

    private var droppedItems: [WasteItem] {
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

    private func labelColor(for item: WasteItem) -> Color {
        guard hasChecked else {
            return Color.gray.opacity(0.55)
        }

        return item.selectedBin == item.correctBin ? .green : .red
    }
}

struct DraggableWasteItem: View {
    @Binding var item: WasteItem
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

struct WasteQuestion {
    let question: String
    let items: [WasteItem]
}

struct WasteItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let correctBin: WasteBin
    var xRatio: CGFloat
    var yRatio: CGFloat
    var selectedBin: WasteBin? = nil
    var offset: CGSize = .zero
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
