//
//  AddStudentCard.swift
//  FlipFlap
//
//  Created by Yee Chean on 20/04/2026.
//

import SwiftUI

struct AddStudentCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 104, height: 104)

                    Image(systemName: "plus")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundColor(.black)
                }

                Text("Add New")
                    .font(AppTheme.Typography.semiBold)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(.plain)
    }
}
