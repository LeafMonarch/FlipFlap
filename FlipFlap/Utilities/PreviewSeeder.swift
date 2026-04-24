//
//  PreviewSeeder.swift
//  FlipFlap
//
//  Created by Yee Chean on 19/04/2026.
//

import Foundation
import SwiftData

// In this case, the enum is not being used for different cases like normal enums often are.
// Instead, it is being used as a namespace — just a neat way to group related helper code.
// So PreviewSeeder is basically acting like a utility container for seeding sample data.
enum PreviewSeeder {
    // static means you do not need to create an instance of PreviewSeeder to use it
    static func seedStudentsIfNeeded(modelContext: ModelContext) {
        // This creates a fetch request descriptor for the Student model.
        // A FetchDescriptor<Student>() is basically the instruction used when asking the database for student records.
        // Since there is nothing extra inside the parentheses, it means:
        // - fetch all students
        // - no filter
        // - no sort
        // - no limit
        let descriptor = FetchDescriptor<Student>()

        guard let existing = try? modelContext.fetch(descriptor),
              existing.isEmpty else {
            return
        }

        let jordan = Student(
            name: "Jordan",
            age: 8,
            avatarName: "happy",
            loginType: .colour,
            favouriteColour: .red
        )

        let layla = Student(
            name: "Layla",
            age: 10,
            avatarName: "mischievious",
            loginType: .sport,
            favouriteSport: .basketball
        )

        modelContext.insert(jordan)
        modelContext.insert(layla)

        try? modelContext.save()
    }
}
