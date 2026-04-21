//
//  SideMenuView.swift
//  FlipFlap
//
//  Created by Yee Chean on 20/04/2026.
//

import SwiftUI

struct SideMenuView: View {
    let onHelpTap: () -> Void
    let onAboutTap: () -> Void
    let onSettingsTap: () -> Void
    let onLogoutTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("FlipFlap")
                .font(AppTheme.Typography.extraBold)
                .foregroundColor(Color(red: 18/255, green: 47/255, blue: 82/255))
                .padding(.top, 20)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)

            Divider()

            VStack(alignment: .leading, spacing: 28) {
                sideMenuItem(
                    systemImage: "headphones",
                    title: "Help & Support",
                    color: Color(red: 18/255, green: 47/255, blue: 82/255),
                    action: onHelpTap
                )

                sideMenuItem(
                    systemImage: "info.circle.fill",
                    title: "About",
                    color: Color(red: 18/255, green: 47/255, blue: 82/255),
                    action: onAboutTap
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)

            Spacer()

            Divider()

            VStack(alignment: .leading, spacing: 28) {
                sideMenuItem(
                    systemImage: "gearshape.fill",
                    title: "Settings",
                    color: Color(red: 143/255, green: 159/255, blue: 184/255),
                    action: onSettingsTap
                )

                sideMenuItem(
                    systemImage: "rectangle.portrait.and.arrow.right",
                    title: "Log Out",
                    color: Color.red.opacity(0.7),
                    action: onLogoutTap
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
        .frame(maxWidth: 300, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
    }

    private func sideMenuItem(
        systemImage: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 18) {
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 28)

                Text(title)
                    .font(AppTheme.Typography.semiBold)
                    .foregroundColor(color)
            }
        }
        .buttonStyle(.plain)
    }
}
