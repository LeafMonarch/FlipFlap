//
//  GameCompletionView.swift
//  FlipFlap
//
//  Created by Raph on 04/05/2026.
//

import SwiftUI

struct GameCompletionView: View {
    let gameName: String
    let correctAnswers: Int
    let totalQuestions: Int
    let starsEarned: Int
    let accentColor: Color
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 26) {
                Text("FINISHED")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.top, 78)

                Spacer()

                HStack(spacing: 10) {
                    ForEach(1...3, id: \.self) { star in
                        Image(systemName: star <= starsEarned ? "star.fill" : "star")
                            .font(.system(size: star == 2 ? 86 : 58, weight: .heavy))
                            .foregroundColor(.yellow)
                            .shadow(color: .black.opacity(0.18), radius: 5, y: 4)
                    }
                }

                Text(message)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)

                scoreCard
                    .offset(y: 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 430)
            .background(accentColor)

            VStack(spacing: 24) {
                Text("\(correctAnswers) correct, \(totalQuestions - correctAnswers) incorrect")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.blue)

                Text("You earned \(starsEarned) out of 3 stars")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue.opacity(0.75))

                Spacer()
            }
            .padding(.top, 58)
            .frame(maxWidth: .infinity)
            .background(Color.white)

            Button(action: onNext) {
                Text("NEXT")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 96)
                    .background(
                        LinearGradient(
                            colors: [Color.green, Color.green.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private var scoreCard: some View {
        HStack(spacing: 10) {
            Text("+ \(starsEarned)")
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.yellow)

            Image(systemName: "star.fill")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.yellow)
        }
        .frame(width: 290, height: 76)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.16), radius: 12, y: 8)
    }

    private var message: String {
        switch starsEarned {
        case 3:
            return "GREAT JOB!"
        case 2:
            return "WELL DONE!"
        case 1:
            return "KEEP TRYING!"
        default:
            return "NEXT TIME!"
        }
    }
}
