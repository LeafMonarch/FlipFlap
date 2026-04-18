//
//  PageLayoutView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct PageLayoutView<Content: View>: View {
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
        VStack(spacing: 0) {
            TopBarView(
                title: title,
                onMenuTap: onMenuTap,
                onNotificationTap: onNotificationTap
            )

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarHidden(true)
    }
}
