//
//  Student.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import Foundation   // Apple's basic functionalities. E.g., UUID, Date.
import SwiftData    // Apple's persistence framework. E.g., @Model.

// Each enum case backed by String, can be endcoded/decoded, and all cases provided automatically.
enum LoginType: String, Codable, CaseIterable {
    case colour
    case sport
}

enum FavouriteColour: String, Codable, CaseIterable {
    case red = "Red"
    case yellow = "Yellow"
    case green = "Green"
    case purple = "Purple"
}

enum FavouriteSport: String, Codable, CaseIterable {
    case football = "Football"
    case basketball = "Basketball"
    case badminton = "Badminton"
    case skateboard = "Skateboard"
}

@Model  // @Model informs SwiftData this Student class should be stored as app data.
final class Student {
    var id: UUID
    var name: String
    var age: Int
    var avatarName: String
    var loginTypeRaw: String
    var favouriteColourRaw: String?
    var favouriteSportRaw: String?
    var streak: Int
    var levelTitle: String
    var createdAt: Date

    init(
        name: String,
        age: Int,
        avatarName: String,
        loginType: LoginType,
        favouriteColour: FavouriteColour? = nil,
        favouriteSport: FavouriteSport? = nil,
        streak: Int = 0,
        levelTitle: String = "Challenger",
        createdAt: Date = Date()
    ) {
        // Required params currently: name, age, avatarName, and loginType.
        self.id = UUID()
        self.name = name
        self.age = age
        self.avatarName = avatarName
        self.loginTypeRaw = loginType.rawValue
        self.favouriteColourRaw = favouriteColour?.rawValue
        self.favouriteSportRaw = favouriteSport?.rawValue
        self.streak = streak
        self.levelTitle = levelTitle
        self.createdAt = createdAt
    }
    
    // Computed property: Doesnt store values separately, instead, calc enum version from `loginTypeRaw`.
    var loginType: LoginType {
        LoginType(rawValue: loginTypeRaw) ?? .colour
    }

    var favouriteColour: FavouriteColour? {
        guard let favouriteColourRaw else { return nil }
        return FavouriteColour(rawValue: favouriteColourRaw)
    }

    var favouriteSport: FavouriteSport? {
        guard let favouriteSportRaw else { return nil }
        return FavouriteSport(rawValue: favouriteSportRaw)
    }
}
