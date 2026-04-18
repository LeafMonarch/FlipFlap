//
//  MainTabView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            DashboardView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Home")
                }

            GamesView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Games")
                }

            RewardsView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Rewards")
                }
        }
        .tint(Color.blue) // selected icon/text colour
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)
    }
}

#Preview {
    MainTabView()
}
