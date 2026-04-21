//
//  AppSession.swift
//  FlipFlap
//
//  Created by Yee Chean on 20/04/2026.
//

import Foundation
import Combine

// 'ObservableObject' means it can announce changes
final class AppSession: ObservableObject {
    
    // '@Published' tells the app: "If this variable changes, refresh any screen watching it!"
    // 'Student?' means it's optional—it's either a Student object or 'nil' (nobody is logged in)
    @Published var authenticatedStudent: Student?

    func logIn(student: Student) {
        // Sets the current student to the one provided
        authenticatedStudent = student
    }

    func logOut() {
        // Sets the current student to 'nil', effectively clearing the session
        authenticatedStudent = nil
    }
}
