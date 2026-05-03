//
//  MainTabView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var pendingGameTitleToOpen: String? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                DashboardView(
                    selectedTab: $selectedTab,
                    pendingGameTitleToOpen: $pendingGameTitleToOpen
                )
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Home")
            }
            .tag(0)

            NavigationStack {
                GamesView(pendingGameTitleToOpen: $pendingGameTitleToOpen)
            }
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Games")
            }
            .tag(1)

            NavigationStack {
                RewardsView()
            }
            .tabItem {
                Image(systemName: "trophy.fill")
                Text("Rewards")
            }
            .tag(2)
        }
        .tint(Color.blue) // selected icon/text colour
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)
    }
}

#Preview {
    MainTabView()
}
