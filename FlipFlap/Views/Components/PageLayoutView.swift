//
//  PageLayoutView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct PageLayoutView<Content: View>: View {
    @EnvironmentObject private var appSession: AppSession
    @State private var isMenuOpen = false

    var title: String
    var onMenuTap: (() -> Void)? = nil
    var onNotificationTap: (() -> Void)? = nil
    let content: Content

    init(
        title: String,
        onMenuTap: (() -> Void)? = nil,
        onNotificationTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.onMenuTap = onMenuTap
        self.onNotificationTap = onNotificationTap
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                TopBarView(
                    title: title,
                    onMenuTap: {
                        if let onMenuTap {
                            onMenuTap()
                        } else {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isMenuOpen = true
                            }
                        }
                    },
                    onNotificationTap: onNotificationTap
                )

                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
            .disabled(isMenuOpen)

            if isMenuOpen {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isMenuOpen = false
                        }
                    }

                SideMenuView(
                    onHelpTap: {
                        print("Help tapped")
                    },
                    onAboutTap: {
                        print("About tapped")
                    },
                    onSettingsTap: {
                        print("Settings tapped")
                    },
                    onLogoutTap: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isMenuOpen = false
                        }

                        appSession.logOut()
                    }
                )
                .frame(width: 300)
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
    }
}
