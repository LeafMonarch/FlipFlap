//
//  DashboardView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject private var appSession: AppSession

    @Binding private var selectedTab: Int
    @Binding private var pendingGameTitleToOpen: String?
    
    @Query private var messages: [TeacherMessage]
    @Query private var progressRecords: [ProgressRecord]
    @Query private var savedScores: [GameScore]
    
    private let streakThreshold = 3

    init(
        selectedTab: Binding<Int> = .constant(0),
        pendingGameTitleToOpen: Binding<String?> = .constant(nil)
    ) {
        self._selectedTab = selectedTab
        self._pendingGameTitleToOpen = pendingGameTitleToOpen
    }
    
    private let gameCards: [GameCardItem] = [
        GameCardItem(
            title: "Nature",
            imageName: "game_environment",
            iconName: "leaf.fill",
            accentColor: .green,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn how to manage your waste; Food waste, Rubbish, Recyclables.",
                tip: "Tip: Where do these go?",
                options: [
                    [
                        OptionItem(title: "Plastic", color: .green, textColor: .white),
                        OptionItem(title: "Chicken", color: .green, textColor: .white)
                    ],
                    [
                        OptionItem(title: "Recyclable", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "Food Waste", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        ),
        GameCardItem(
            title: "Maths",
            imageName: "game_maths",
            iconName: "plus.forwardslash.minus",
            accentColor: .pink,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn how to add, subtract, multiply and divide two numbers!",
                tip: "Tip: What is 4 x 2?",
                options: [
                    [
                        OptionItem(title: "2", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "6", color: Color.blue.opacity(0.22), textColor: .blue)
                    ],
                    [
                        OptionItem(title: "8", color: .green, textColor: .white),
                        OptionItem(title: "4", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        ),
        GameCardItem(
            title: "Sports",
            imageName: "game_pe",
            iconName: "basketball.fill",
            accentColor: .orange,
            overlayContent: GameOverlayContent(
                description: "In this lesson, you will learn about sports, movement, and healthy activities.",
                tip: "Tip: Which one is a sport?",
                options: [
                    [
                        OptionItem(title: "Football", color: .orange, textColor: .white),
                        OptionItem(title: "Basketball", color: .orange, textColor: .white)
                    ],
                    [
                        OptionItem(title: "Reading", color: Color.blue.opacity(0.22), textColor: .blue),
                        OptionItem(title: "Sleeping", color: Color.blue.opacity(0.22), textColor: .blue)
                    ]
                ]
            )
        )
    ]
    
    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Home",
                onNotificationTap: {
                    print("Notification tapped in Dashboard")
                }
            ) {
                if let student = appSession.authenticatedStudent {
                    dashboardContent(for: student)
                } else {
                    Text("No student logged in")
                }
            }
        }
    }

    private func dashboardContent(for student: Student) -> some View {
        let isStreakActive = student.streak >= streakThreshold

        let primary = isStreakActive
            ? AppTheme.Colors.orangePrimary
            : AppTheme.Colors.blueSecondary

        let secondary = isStreakActive
            ? AppTheme.Colors.orangeSecondary
            : AppTheme.Colors.bluePrimary

        return ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                heroSection(
                    student: student,
                    primary: primary,
                    secondary: secondary,
                    isStreakActive: isStreakActive
                )

                Spacer()
                Spacer()
                
                gamesSection(primary: secondary, secondary: secondary)

                Spacer()
                
                VStack(spacing: 20) {
                    teacherMessageCard(for: student)
                    progressCard(for: student, primary: primary, secondary: secondary)
                }
                .padding(.horizontal, 28)
                .padding(.top, 32)
                .padding(.bottom, 100)
            }
        }
        .background(Color.white)
    }

    private func heroSection(
        student: Student,
        primary: Color,
        secondary: Color,
        isStreakActive: Bool
    ) -> some View {
        HStack(spacing: 12) {
            Image("MascotProfileHappy")
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))

            VStack(alignment: .leading, spacing: 2) {
                Text(isStreakActive ? "Top of the morning, \(student.name)!" : "Good morning, \(student.name)!")
                    .font(AppTheme.Typography.dashboardTitle)
                    .foregroundColor(.white)
                    .lineLimit(2)

                HStack(spacing: 10) {
                    Text(student.levelTitle)
                        .font(AppTheme.Typography.caption)

                    if isStreakActive {
                        var streakText: AttributedString {
                            var text = AttributedString("\(student.streak) Days Streak!")

                            if let range = text.range(of: "\(student.streak)") {
                                text[range].font = AppTheme.Typography.dashboardMessage
                            }
                            return text
                        }
                        Text(streakText)
                            .font(AppTheme.Typography.caption)

                        Image(systemName: "flame.fill")
                            .font(.caption)
                    }
                }
                .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 26)
        .padding(.bottom, 28)
        .background(
            LinearGradient(
                colors: [primary, secondary],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 60,
                bottomTrailingRadius: 60
            )
        )
    }

    private func gamesSection(primary: Color, secondary: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Games")
                .font(AppTheme.Typography.dashboardTitle)
                .foregroundColor(.white)

            HStack(spacing: 8) {
                ForEach(gameCards) { card in
                    GameCardView(card: card) {
                        pendingGameTitleToOpen = card.title
                        selectedTab = 1
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 18)
        .background(
            LinearGradient(
                colors: [primary, secondary],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private func teacherMessageCard(for student: Student) -> some View {
        let message = messages.first { $0.studentName == student.name }

        return HStack(spacing: 14) {
            Image("MascotProfileHandRaise")
                .resizable()
                .scaledToFill()
                .frame(width: 54, height: 54)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(red: 18/255, green: 47/255, blue: 82/255), lineWidth: 3))

            VStack(alignment: .leading, spacing: 4) {
                Text(message?.title ?? "A message from your teacher!")
                    .font(AppTheme.Typography.dashboardMessage)
                    .foregroundColor(Color(red: 18/255, green: 47/255, blue: 82/255))

                Text(message?.bodyText ?? "Hi \(student.name), you still have a week to complete homework's!")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(Color(red: 18/255, green: 47/255, blue: 82/255))
                    .lineLimit(2)
            }

            Spacer()

            Circle()
                .fill(Color.red)
                .frame(width: 14, height: 14)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 0, x: 4, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        )
    }

//    private func progressCard(for student: Student, primary: Color, secondary: Color) -> some View {
//        let records = progressRecords.filter { $0.studentName == student.name }
//
//        return VStack(spacing: 0) {
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Progress 35%")
//                        .font(AppTheme.Typography.semiBold)
//                        .foregroundColor(.white)
//
//                    Text("Keep track of your homework's!")
//                        .font(AppTheme.Typography.caption)
//                        .foregroundColor(.white)
//                }
//
//                Spacer()
//
//                Text("6 days left")
//                    .font(AppTheme.Typography.caption)
//                    .foregroundColor(.white)
//            }
//            .padding()
//            .background(
//                LinearGradient(
//                    colors: [primary, secondary],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//            )
//
//            VStack(spacing: 0) {
//                ForEach(records, id: \.id) { record in
//                    progressRow(record)
//                    Divider()
//                }
//            }
//            .background(Color(.systemGray6))
//        }
//        .clipShape(RoundedRectangle(cornerRadius: 8))
//        .shadow(color: .black.opacity(0.25), radius: 0, x: 4, y: 5)
//    }
//
//    private func progressRow(_ record: ProgressRecord) -> some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Text(record.subject)
//                        .font(AppTheme.Typography.caption)
//                        .foregroundColor(.gray)
//
//                    Spacer()
//
//                    Text("\(record.completed)/\(record.total)")
//                        .font(AppTheme.Typography.caption)
//                        .foregroundColor(.gray)
//                }
//
//                ProgressView(value: record.progressFraction)
//                    .tint(.green)
//            }
//
//            Image(systemName: "star.fill")
//                .foregroundColor(.yellow)
//                .font(.title2)
//                .overlay {
//                    Text("\(Int(record.progressFraction * 10))")
//                        .font(.caption2)
//                        .foregroundColor(.white)
//                }
//        }
//        .padding(.horizontal, 28)
//        .padding(.vertical, 12)
//    }
    private struct DashboardProgressItem: Identifiable {
        let id = UUID()
        let subject: String
        let completed: Int
        let total: Int
        let stars: Int

        var progressFraction: Double {
            guard total > 0 else { return 0 }
            return Double(completed) / Double(total)
        }
    }

    private func progressItems(for student: Student) -> [DashboardProgressItem] {
        let studentScores = savedScores.filter {
            $0.studentID == student.id
        }

        return [
            makeProgressItem(
                subject: "Natural Environment",
                gameNames: ["Waste Management", "Animal Food Chain"],
                scores: studentScores
            ),
            makeProgressItem(
                subject: "Maths",
                gameNames: ["Addition", "Subtraction"],
                scores: studentScores
            ),
            makeProgressItem(
                subject: "Physical Education",
                gameNames: ["Jumping Jacks", "Running In Place"],
                scores: studentScores
            )
        ]
    }

    private func makeProgressItem(
        subject: String,
        gameNames: [String],
        scores: [GameScore]
    ) -> DashboardProgressItem {
        let matchingScores = scores.filter {
            gameNames.contains($0.gameName)
        }

        let completed = Set(matchingScores.map { $0.gameName }).count
        let stars = matchingScores.reduce(0) { $0 + $1.starsEarned }

        return DashboardProgressItem(
            subject: subject,
            completed: completed,
            total: gameNames.count,
            stars: stars
        )
    }

    private func progressCard(for student: Student, primary: Color, secondary: Color) -> some View {
        let records = progressItems(for: student)

        let totalCompleted = records.reduce(0) { $0 + $1.completed }
        let totalPossible = records.reduce(0) { $0 + $1.total }

        let overallProgress = totalPossible == 0
            ? 0
            : Int((Double(totalCompleted) / Double(totalPossible)) * 100)

        return VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress \(overallProgress)%")
                        .font(AppTheme.Typography.semiBold)
                        .foregroundColor(.white)

                    Text("Keep track of your games!")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.white)
                }

                Spacer()

                Text("\(totalPossible - totalCompleted) games left")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [primary, secondary],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            VStack(spacing: 0) {
                ForEach(records) { record in
                    progressRow(record)
                    Divider()
                }
            }
            .background(Color(.systemGray6))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.25), radius: 0, x: 4, y: 5)
    }

    private func progressRow(_ record: DashboardProgressItem) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(record.subject)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("\(record.completed)/\(record.total)")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.gray)
                }

                ProgressView(value: record.progressFraction)
                    .tint(.green)
            }

            ZStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 28, weight: .bold))

                Text("\(record.stars)")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
            }
            .frame(width: 34)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

#Preview {
    let session = AppSession()
    session.authenticatedStudent = Student(
        name: "Jordan",
        age: 8,
        avatarName: "happy",
        loginType: .colour,
        favouriteColour: .red,
        streak: 11
    )

    return DashboardView()
        .environmentObject(session)
        .modelContainer(for: [
            Student.self,
            TeacherMessage.self,
            ProgressRecord.self
        ], inMemory: true)
}
