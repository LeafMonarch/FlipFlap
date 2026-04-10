//
//  ProgressRecord.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import Foundation
import SwiftData

@Model
final class ProgressRecord {
    var id: UUID
    var studentName: String
    var subject: String
    var completed: Int
    var total: Int

    init(studentName: String, subject: String, completed: Int, total: Int) {
        self.id = UUID()
        self.studentName = studentName
        self.subject = subject
        self.completed = completed
        self.total = total
    }

    var progressFraction: Double {
        // Prevent division by 0
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
}
