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

    private let mainRed = Color.red

    private let questions: [AdditionQuestion] = [
        AdditionQuestion(question: "2 + 3", options: [4, 5, 6, 7], correctAnswer: 5),
        AdditionQuestion(question: "4 + 4", options: [6, 7, 8, 9], correctAnswer: 8),
        AdditionQuestion(question: "6 + 2", options: [7, 8, 9, 10], correctAnswer: 8),
        AdditionQuestion(question: "3 + 5", options: [6, 7, 8, 9], correctAnswer: 8)
    ]

    var body: some View {
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
                    if !hasChecked {
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
        .disabled(selectedAnswer == nil)
        .opacity(selectedAnswer == nil ? 0.5 : 1)
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
            saveGameScore(
                gameName: "Addition",
                correct: score,
                total: questions.count
            )

            dismiss()
        }
    }
}

#Preview {
    MathsAdditionGameView()
}
