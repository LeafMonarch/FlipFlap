//
//  TopBarView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI

struct TopBarView: View {
    var title: String
    var onMenuTap: (() -> Void)? = nil
    var onNotificationTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button(action: {
                onMenuTap?()
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 44, alignment: .leading)
            }

            Spacer()

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Spacer()

            Button(action: {
                onNotificationTap?()
            }) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 44, alignment: .trailing)
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
