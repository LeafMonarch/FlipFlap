//
//  AuthController.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import Foundation
import SwiftData

// Represents the different potential authentication/sign-up errors that may occur.
enum AuthError: LocalizedError {
    // LocalizedError: Allow devs to provide customisable, human-readable, error msgs for each error.
    case emptyName
    case invalidAge
    case missingColour
    case missingSport
    case wrongSecretCode

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Please enter the student's name."
        case .invalidAge:
            return "Please enter a valid age between 5 and 12."
        case .missingColour:
            return "Please choose a favourite colour."
        case .missingSport:
            return "Please choose a favourite sport."
        case .wrongSecretCode:
            return "That secret code is incorrect. Try again."
        }
    }
}

// final key used: class cannot be inherited, ensure separation of concern. Keeps things simpler.
final class AuthController {
    func createStudent(
        name: String,
        age: Int,
        avatarName: String,
        loginType: LoginType,
        favouriteColour: FavouriteColour?,
        favouriteSport: FavouriteSport?,
        modelContext: ModelContext  // SwiftData model context. Required to interact with storage.
    ) throws -> Student {
        // Remove spaces and line breaks from the start and end of entered name.
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw AuthError.emptyName
        }

        guard (5...12).contains(age) else {
            throw AuthError.invalidAge
        }

        switch loginType {
        case .colour:
            guard favouriteColour != nil else {
                throw AuthError.missingColour
            }
        case .sport:
            guard favouriteSport != nil else {
                throw AuthError.missingSport
            }
        }

        let student = Student(
            name: trimmedName,
            age: age,
            avatarName: avatarName,
            loginType: loginType,
            favouriteColour: favouriteColour,
            favouriteSport: favouriteSport
        )

        modelContext.insert(student)
        try modelContext.save()
        return student
    }

    func validateColourLogin(student: Student, selected: FavouriteColour?) throws {
        guard student.favouriteColour == selected else {
            throw AuthError.wrongSecretCode
        }
    }

    func validateSportLogin(student: Student, selected: FavouriteSport?) throws {
        guard student.favouriteSport == selected else {
            throw AuthError.wrongSecretCode
        }
    }
}
