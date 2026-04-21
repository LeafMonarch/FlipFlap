//
//  AuthRootView.swift
//  FlipFlap
//
//  Created by Yee Chean on 19/04/2026.
//

import SwiftUI
import SwiftData

struct AuthRootView: View {
    // Grabs the "Model Context" (the active connection to the database) from the app's environment
    @Environment(\.modelContext) private var modelContext
    
    // @StateObject: A property wrapper type that instantiates an observable object.
    // Creates and manages an 'AppSession' object to track the user's login state throughout the app
    @StateObject private var appSession = AppSession()
    
    // A simple boolean flag to make sure we don't accidentally add "seed" (test) data more than once
    // @State: A property wrapper type that can read and write a value managed by SwiftUI.
    @State private var hasSeeded = false

    var body: some View {
        // A container used to wrap the conditional logic below/
        Group {
            if appSession.authenticatedStudent != nil {
                MainTabView()
                    .environmentObject(appSession)  // Pass the session info down so sub-views can use it
            } else {
                StudentLoginFlowView(authenticatedStudent: $appSession.authenticatedStudent)    //binding
                    .environmentObject(appSession)  // Also pass the session info here to update it on login
            }
        }
        .onAppear {
            guard !hasSeeded else { return }
            PreviewSeeder.seedStudentsIfNeeded(modelContext: modelContext)
            hasSeeded = true
        }
    }
}
