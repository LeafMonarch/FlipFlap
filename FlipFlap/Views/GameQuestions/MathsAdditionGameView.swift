//
//  MathSubtractionGameView.swift
//  FlipFlap
//
//  Created by Raph on 03/05/2026.
//

import SwiftUI
import SwiftData

struct MathsAdditionGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appSession: AppSession
    
    @Query(sort: \GameScore.playedAt, order: .reverse) private var savedScores: [GameScore]

    struct AdditionQuestion {
        let question: String
        let options: [Int]
        let correctAnswer: Int
    }

    @State private var questionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var hasChecked = false
    @State private var score = 0
    
    @State private var showCompletion = false
    @State private var finalStars = 0
    
    private func saveGameScore(gameName: String, correct: Int, total: Int) {
        guard let student = appSession.authenticatedStudent else {
            print("No logged in student")
            return
        }

        let stars = calculateStars(correct: correct, total: total)

        let gameScore = GameScore(
            gameName: gameName,
            correctAnswers: correct,
            wrongAnswers: total - correct,
            totalQuestions: total,
            starsEarned: stars,
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
                Stars: \(score.starsEarned)
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

    private let mainRed = Color.red

    private let questions: [AdditionQuestion] = [
        AdditionQuestion(question: "2 + 3", options: [4, 5, 6, 7], correctAnswer: 5),
        AdditionQuestion(question: "4 + 4", options: [6, 7, 8, 9], correctAnswer: 8),
        AdditionQuestion(question: "6 + 2", options: [7, 8, 9, 10], correctAnswer: 8),
        AdditionQuestion(question: "3 + 5", options: [6, 7, 8, 9], correctAnswer: 8)
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                    .frame(height: 180)

                questionCard
                    .padding(.top, 42)

                answerGrid
                    .padding(.top, 42)

                Spacer()

                bottomButton
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .top)

            if showCompletion {
                GameCompletionView(
                    gameName: "Addition",
                    correctAnswers: score,
                    totalQuestions: questions.count,
                    starsEarned: finalStars,
                    accentColor: mainRed
                ) {
                    dismiss()
                }
                .transition(.opacity)
                .zIndex(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private var header: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 6) {
                Text("\(questionIndex + 1) / \(questions.count)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                Text("Addition")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.white)
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
        .background(mainRed)
    }

    private var questionCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(mainRed)
                .frame(height: 150)
                .shadow(color: .black.opacity(0.22), radius: 0, x: 6, y: 7)

            VStack(spacing: 24) {
                Text("Question \(questionIndex + 1):")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("What is \(questions[questionIndex].question)?")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 48)
    }

    private var answerGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 18),
                GridItem(.flexible(), spacing: 18)
            ],
            spacing: 18
        ) {
            ForEach(questions[questionIndex].options, id: \.self) { answer in
                Button {
                    if !hasChecked && !showCompletion {
                        selectedAnswer = answer
                    }
                } label: {
                    Text("\(answer)")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .background(answerColor(answer))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.22), radius: 0, x: 5, y: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(selectedAnswer == answer && !hasChecked ? Color.blue : Color.clear, lineWidth: 5)
                        )
                }
                .buttonStyle(.plain)
                .disabled(showCompletion)
            }
        }
        .padding(.horizontal, 48)
    }

    private var bottomButton: some View {
        Button {
            if hasChecked {
                goToNextQuestion()
            } else {
                checkAnswer()
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
        .disabled(selectedAnswer == nil || showCompletion)
        .opacity(selectedAnswer == nil || showCompletion ? 0.5 : 1)
    }

    private var nextButtonTitle: String {
        questionIndex == questions.count - 1 ? "Finish" : "Next"
    }

    private func answerColor(_ answer: Int) -> Color {
        if !hasChecked {
            return mainRed
        }

        if answer == questions[questionIndex].correctAnswer {
            return .green
        }

        if answer == selectedAnswer {
            return .red
        }

        return .gray.opacity(0.6)
    }

    private func checkAnswer() {
        hasChecked = true

        if selectedAnswer == questions[questionIndex].correctAnswer {
            score += 1
        }
    }

    private func goToNextQuestion() {
        if questionIndex < questions.count - 1 {
            questionIndex += 1
            selectedAnswer = nil
            hasChecked = false
        } else {
            finalStars = calculateStars(correct: score, total: questions.count)

            saveGameScore(
                gameName: "Addition",
                correct: score,
                total: questions.count
            )

            withAnimation {
                showCompletion = true
            }
        }
    }

    private func calculateStars(correct: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }

        if correct == total {
            return 3
        } else if correct >= total / 2 {
            return 2
        } else if correct > 0 {
            return 1
        } else {
            return 0
        }
    }
}

#Preview {
    MathsAdditionGameView()
}
