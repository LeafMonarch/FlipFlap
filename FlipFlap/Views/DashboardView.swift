//
//  DashboardView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Home",
                onNotificationTap: {
                    print("Notification tapped in Dashboard")
                }
            ) {
                VStack {
                    Spacer()

                    Text("Dashboard Content")
                        .font(.title2)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
