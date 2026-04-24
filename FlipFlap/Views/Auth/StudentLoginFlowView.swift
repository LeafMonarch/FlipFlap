//
//  StudentLoginFlowView.swift
//  FlipFlap
//
//  Created by Yee Chean on 19/04/2026.
//

import SwiftUI
import SwiftData

struct StudentLoginFlowView: View {
    // That binding connects directly to: $appSession.authenticatedStudent from the AuthRootView.swift.
    @Binding var authenticatedStudent: Student?

    @Environment(\.modelContext) private var modelContext
    
    // SwiftData automatically fetches all students from the database and keeps this array updated.
    // So this view does not manually fetch students.
    @Query(sort: \Student.createdAt) private var students: [Student]

    // Local view state
    @State private var selectedStudent: Student?
    @State private var selectedColour: FavouriteColour?
    @State private var selectedSport: FavouriteSport?
    @State private var errorMessage: String?
    @State private var showingCreateStudent = false

    private let authController = AuthController()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if selectedStudent == nil {
                    chooseStudentSection
                } else {
                    secretCodeSection
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .background(Color.white.ignoresSafeArea())
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
            .sheet(isPresented: $showingCreateStudent) {
                CreateStudentView(authenticatedStudent: $authenticatedStudent)
            }
        }
    }

    private var chooseStudentSection: some View {
        VStack(spacing: 24) {
            Image("MascotDancing")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 260)
                .padding(.top, 8)
            
            Text("Who is Learning Today?")
                .font(AppTheme.Typography.screenTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)

            if students.isEmpty {
                VStack(spacing: 12) {
                    Text("No student accounts yet.")
                        .font(AppTheme.Typography.body)

                    Text("Create one first so login can work.")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.gray)
                    
                    Button("Add New Student") {
                        showingCreateStudent = true
                    }
                    .font(AppTheme.Typography.semiBold)
                    .padding(.top, 8)
                }
                .padding(.top, 40)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 24) {
                    ForEach(students, id: \.id) { student in
                        StudentAvatarCard(student: student) {
                            selectedStudent = student
                            selectedColour = nil
                            selectedSport = nil
                        }
                    }
                    AddStudentCard {
                        showingCreateStudent = true
                    }
                }
            }
        }
    }

    private var secretCodeSection: some View {
        VStack(spacing: 24) {
            Image("MascotDancing")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 260)
                .padding(.top, 8)
            
            Text("Enter Your Secret Code")
                .font(AppTheme.Typography.screenTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)

            loginTypeTabs

            if let student = selectedStudent {
                switch student.loginType {
                case .colour:
                    colourPickerSection
                case .sport:
                    sportPickerSection
                }
            }

            Button(action: validateLogin) {
                Text("Continue")
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
            .padding(.top, 16)

            Button("Back") {
                selectedStudent = nil
                selectedColour = nil
                selectedSport = nil
            }
            .font(AppTheme.Typography.body)
            .foregroundColor(.gray)
        }
    }

    private var loginTypeTabs: some View {
        HStack(spacing: 0) {
            tabItem(title: "Color", isSelected: selectedStudent?.loginType == .colour)
            tabItem(title: "Sport", isSelected: selectedStudent?.loginType == .sport)
        }
        .padding(4)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }

    private func tabItem(title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(AppTheme.Typography.caption)
            .foregroundColor(isSelected ? .black : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.white : Color.clear)
            )
    }

    private var colourPickerSection: some View {
        VStack(spacing: 20) {
            Text("What’s your favourite colour?")
                .font(AppTheme.Typography.sectionTitle)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                ForEach(FavouriteColour.allCases, id: \.self) { colour in
                    Button {
                        selectedColour = colour
                    } label: {
                        Circle()
                            .fill(swiftUIColor(for: colour))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedColour == colour ? Color.black : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                    }
                }
            }
        }
    }

    private var sportPickerSection: some View {
        VStack(spacing: 20) {
            Text("What’s your favourite sport?")
                .font(AppTheme.Typography.sectionTitle)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                ForEach(FavouriteSport.allCases, id: \.self) { sport in
                    Button {
                        selectedSport = sport
                    } label: {
                        VStack(spacing: 8) {
                            Text(emoji(for: sport))
                                .font(.system(size: 40))

                            Text(sport.rawValue)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(.black)
                        }
                        .frame(width: 72)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedSport == sport ? Color.black : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                }
            }
        }
    }

    private func validateLogin() {
        guard let student = selectedStudent else { return }

        do {
            switch student.loginType {
            case .colour:
                try authController.validateColourLogin(student: student, selected: selectedColour)
            case .sport:
                try authController.validateSportLogin(student: student, selected: selectedSport)
            }

            authenticatedStudent = student
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
