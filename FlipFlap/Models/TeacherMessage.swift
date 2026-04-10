//
//  TeacherMessage.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import Foundation
import SwiftData

@Model
final class TeacherMessage {
    var id: UUID
    var studentName: String
    var title: String
    var bodyText: String
    var isUnread: Bool
    var createdAt: Date

    init(
        studentName: String,
        title: String,
        bodyText: String,
        isUnread: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.studentName = studentName
        self.title = title
        self.bodyText = bodyText
        self.isUnread = isUnread
        self.createdAt = createdAt
    }
}
