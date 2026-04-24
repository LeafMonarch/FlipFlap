//
//  RewardsView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct RewardsView: View {
    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Rewards",
                onNotificationTap: {
                    print("Notification tapped in Dashboard")
                }
            ) {
                VStack {
                    Spacer()

                    Text("Rewards Content")
                        .font(.title2)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    RewardsView()
}
