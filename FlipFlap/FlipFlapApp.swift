//
//  FlipFlapApp.swift
//  FlipFlap
//
//  Created by Yee Chean on 10/04/2026.
//

import SwiftUI      // Framework for UI Building
import SwiftData    // Framework for saving data and app data management. The DB

@main               // Init and runs the app
struct FlipFlapApp: App {
    // Creates a "Container" (a storage box) to hold FlipFlap's data, initialised immediately
    var sharedModelContainer: ModelContainer = {
        
        // Defines the 'Schema', essentially a list of what types of data (like Students) we want to save
        let schema = Schema([
            Student.self    // Tells SwiftData that the 'Student' model should be stored in the database
        ])

        // Sets up how the data is stored (e.g., should it be saved to disk or just kept in temporary memory?)
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() // The '()' executes this block of code as soon as the app starts

    var body: some Scene {
        WindowGroup {       // Creates a window for the app's content to live in
            AuthRootView()  // The very first screen the user will see when opening the app
        }
        .modelContainer(sharedModelContainer)
        // Attaches the data storage box to the entire app so all screens can access the data
    }
}
