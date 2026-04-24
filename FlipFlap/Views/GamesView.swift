//
//  GamesView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct GamesView: View {
    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Games",
//                onMenuTap: {
//                    print("Menu tapped in Dashboard")
//                },
                onNotificationTap: {
                    print("Notification tapped in Dashboard")
                }
            ) {
                VStack {
                    Spacer()

                    Text("Games Content")
                        .font(.title2)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GamesView()
}
