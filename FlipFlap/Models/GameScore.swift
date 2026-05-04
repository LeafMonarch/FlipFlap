//
//  GameScore.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 03/05/2026.
//

import Foundation
import SwiftData

@Model
final class GameScore {
    var gameName: String
    var correctAnswers: Int
    var wrongAnswers: Int
    var totalQuestions: Int
    var starsEarned: Int = 0
    var playedAt: Date

    var studentID: UUID
    var studentName: String

    init(
        gameName: String,
        correctAnswers: Int,
        wrongAnswers: Int,
        totalQuestions: Int,
        starsEarned: Int = 0,
        studentID: UUID,
        studentName: String
    ) {
        self.gameName = gameName
        self.correctAnswers = correctAnswers
        self.wrongAnswers = wrongAnswers
        self.totalQuestions = totalQuestions
        self.starsEarned = starsEarned
        self.studentID = studentID
        self.studentName = studentName
        self.playedAt = Date()
    }
}
