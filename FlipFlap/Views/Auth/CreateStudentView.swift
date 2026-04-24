//
//  CreateStudentView.swift
//  FlipFlap
//
//  Created by Yee Chean on 20/04/2026.
//

import SwiftUI
import SwiftData

struct CreateStudentView: View {
    @Binding var authenticatedStudent: Student?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var age = 8
    @State private var avatarName = "happy"
    @State private var loginType: LoginType = .colour
    @State private var favouriteColour: FavouriteColour? = .red
    @State private var favouriteSport: FavouriteSport? = nil
    @State private var errorMessage: String?

    private let authController = AuthController()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Create Student")
                        .font(AppTheme.Typography.screenTitle)
                        .foregroundColor(.black)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(AppTheme.Typography.caption)

                        TextField("Enter name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age")
                            .font(AppTheme.Typography.caption)

                        Stepper(value: $age, in: 5...12) {
                            Text("\(age)")
                                .font(AppTheme.Typography.body)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Secret Code Type")
                            .font(AppTheme.Typography.caption)

                        Picker("Login Type", selection: $loginType) {
                            Text("Colour").tag(LoginType.colour)
                            Text("Sport").tag(LoginType.sport)
                        }
                        .pickerStyle(.segmented)
                    }

                    if loginType == .colour {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favourite Colour")
                                .font(AppTheme.Typography.caption)

                            HStack(spacing: 16) {
                                ForEach(FavouriteColour.allCases, id: \.self) { colour in
                                    Button {
                                        favouriteColour = colour
                                    } label: {
                                        Circle()
                                            .fill(swiftUIColor(for: colour))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Circle()
                                                    .stroke(
                                                        favouriteColour == colour ? Color.black : Color.clear,
                                                        lineWidth: 3
                                                    )
                                            )
                                    }
                                }
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favourite Sport")
                                .font(AppTheme.Typography.caption)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(FavouriteSport.allCases, id: \.self) { sport in
                                    Button {
                                        favouriteSport = sport
                                    } label: {
                                        VStack(spacing: 8) {
                                            Text(emoji(for: sport))
                                                .font(.system(size: 30))

                                            Text(sport.rawValue)
                                                .font(AppTheme.Typography.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    favouriteSport == sport ? Color.black : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    Button(action: saveStudent) {
                        Text("Create Student")
                            .font(AppTheme.Typography.semiBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [
                                        AppTheme.Colors.blueSecondary,
                                        AppTheme.Colors.bluePrimary
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(24)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
            .onChange(of: loginType) { _, newValue in
                if newValue == .colour {
                    favouriteColour = favouriteColour ?? .red
                    favouriteSport = nil
                } else {
                    favouriteSport = favouriteSport ?? .football
                    favouriteColour = nil
                }
            }
        }
    }

    private func saveStudent() {
        do {
            let student = try authController.createStudent(
                name: name,
                age: age,
                avatarName: avatarName,
                loginType: loginType,
                favouriteColour: favouriteColour,
                favouriteSport: favouriteSport,
                modelContext: modelContext
            )

            authenticatedStudent = student
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func swiftUIColor(for colour: FavouriteColour) -> Color {
        switch colour {
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    private func emoji(for sport: FavouriteSport) -> String {
        switch sport {
        case .football:
            return "⚽️"
        case .basketball:
            return "🏀"
        case .badminton:
            return "🏸"
        case .skateboard:
            return "🛹"
        }
    }
}
