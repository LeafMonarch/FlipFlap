//
//  StudentAvatarCard.swift
//  FlipFlap
//
//  Created by Yee Chean on 19/04/2026.
//

import SwiftUI

struct StudentAvatarCard: View {
    let student: Student
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 110, height: 110)
                    
                    avatarImage(for: student.avatarName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 3)
                        )
                }

                Text(student.name)
                    .onAppear {
                            print(student.name, student.avatarName)
                        }
                    .font(AppTheme.Typography.semiBold)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(.plain)
    }

    private func avatarImage(for avatarName: String) -> Image {
        switch avatarName {
        case "happy":
            return Image("MascotProfileHappy")
        case "mischievious":
            return Image("MascotProfileMischevious")
        default:
            return Image("MascotProfileHappy")
        }
    }
}
