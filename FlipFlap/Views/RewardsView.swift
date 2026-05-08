//
//  RewardsView.swift
//  FlipFlap
//
//  Created by Raphael Frogoso on 18/04/2026.
//
//


import SwiftUI
import SwiftData

struct RewardsView: View {
    @EnvironmentObject private var appSession: AppSession

    @Query private var savedScores: [GameScore]
    
    private let milestones: [RewardMilestone] = [
        RewardMilestone(title: "Starter", subtitle: "Begin your journey", starsRequired: 0, color: .green, icon: "leaf.fill"),
        RewardMilestone(title: "Explorer", subtitle: "Earn 3 stars", starsRequired: 3, color: .blue, icon: "safari.fill"),
        RewardMilestone(title: "Thinker", subtitle: "Earn 7 stars", starsRequired: 7, color: .pink, icon: "brain.head.profile"),
        RewardMilestone(title: "Challenger", subtitle: "Earn 12 stars", starsRequired: 12, color: .orange, icon: "flame.fill"),
        RewardMilestone(title: "Champion", subtitle: "Earn 18 stars", starsRequired: 18, color: .purple, icon: "crown.fill")
    ]
    
//    private var totalStars: Int {
//        guard let student = appSession.authenticatedStudent else { return 0 }
//        return progressRecords
//            .filter { $0.studentName == student.name }
//            .reduce(0) { $0 + Int($1.progressFraction * 10) }
//    }
    
    private var totalStars: Int {
        guard let student = appSession.authenticatedStudent else { return 0 }

        return savedScores
            .filter { $0.studentID == student.id }
            .reduce(0) { $0 + $1.starsEarned }
    }
    
    private var isStreakActive: Bool {
        guard let student = appSession.authenticatedStudent else { return false }
        return student.streak >= 3
    }

    private var summaryGradientColors: [Color] {
        isStreakActive
            ? [
                AppTheme.Colors.orangePrimary,
                AppTheme.Colors.orangeSecondary
            ]
            : [
                Color(red: 0.12, green: 0.55, blue: 0.86),
                Color(red: 0.11, green: 0.76, blue: 0.95)
            ]
    }

    private var currentMilestone: RewardMilestone {
        milestones.last { totalStars >= $0.starsRequired } ?? milestones[0]
    }

    var body: some View {
        NavigationStack {
            PageLayoutView(
                title: "Rewards",
                onNotificationTap: {
                    print("Notification tapped in Rewards")
                }
            ) {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 0.77, green: 0.93, blue: 1.0),
                            Color(red: 0.90, green: 0.98, blue: 1.0),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    IceDecorationView()

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 22) {
                            rewardSummaryCard

                            GeometryReader { geometry in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let points = rewardPoints(width: width, height: height)
                                let currentIndex = milestones.firstIndex(where: { $0.id == currentMilestone.id }) ?? 0

                                ZStack {
                                    RewardRoadPath(points: points)

                                    ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                                        RewardNode(
                                            milestone: milestone,
                                            isUnlocked: totalStars >= milestone.starsRequired,
                                            isCurrent: milestone.id == currentMilestone.id
                                        )
                                        .position(points[index])
                                    }

                                    Image("MascotProfileHappy")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 54, height: 54)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(color: .black.opacity(0.18), radius: 5, x: 0, y: 4)
                                        .position(
                                            x: points[currentIndex].x + 42,
                                            y: points[currentIndex].y - 38
                                        )
                                }
                            }
                            .frame(height: 640)
                            .padding(.horizontal, 10)
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 110)
                    }
                }
            }
        }
    }

    private var rewardSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentMilestone.title)
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)

                    Text("Current Title")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.yellow)

                    Text("\(totalStars)")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.white)
                }
            }

            Text("Keep earning stars to unlock new titles on your reward journey.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: summaryGradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 22)
    }
    
    private func rewardPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        [
            CGPoint(x: width * 0.25, y: height * 0.85), // Start (Bottom Left)
            CGPoint(x: width * 0.75, y: height * 0.70), // Right
            CGPoint(x: width * 0.25, y: height * 0.50), // Left
            CGPoint(x: width * 0.75, y: height * 0.30), // Right
            CGPoint(x: width * 0.35, y: height * 0.10)  // End (Top Leftish)
        ]
    }
}

struct RewardMilestone: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let starsRequired: Int
    let color: Color
    let icon: String
}

struct RewardRoadPath: View {
    let points: [CGPoint]

    var body: some View {
        ZStack {
            roadPath
                .stroke(
                    Color(red: 0.46, green: 0.78, blue: 0.91),
                    style: StrokeStyle(lineWidth: 54, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 5)

            roadPath
                .stroke(
                    Color.white.opacity(0.90),
                    style: StrokeStyle(lineWidth: 38, lineCap: .round, lineJoin: .round)
                )
        }
    }
    
    private var roadPath: Path {
        var path = Path()
        guard points.count >= 5 else { return path }

        let hOffset = 180.0 // The "strength" of the curve flatness

        path.move(to: points[0])

        // Curve to Point 1 (Right)
        path.addCurve(
            to: points[1],
            control1: CGPoint(x: points[0].x + hOffset, y: points[0].y),
            control2: CGPoint(x: points[1].x + hOffset, y: points[1].y)
        )

        // Curve to Point 2 (Left)
        path.addCurve(
            to: points[2],
            control1: CGPoint(x: points[1].x - hOffset, y: points[1].y),
            control2: CGPoint(x: points[2].x - hOffset, y: points[2].y)
        )

        // Curve to Point 3 (Right)
        path.addCurve(
            to: points[3],
            control1: CGPoint(x: points[2].x + hOffset, y: points[2].y),
            control2: CGPoint(x: points[3].x + hOffset, y: points[3].y)
        )

        // Curve to Point 4 (Top Left)
        path.addCurve(
            to: points[4],
            control1: CGPoint(x: points[3].x - hOffset, y: points[3].y),
            control2: CGPoint(x: points[4].x - hOffset, y: points[4].y)
        )

        return path
    }
}

struct RewardNode: View {
    let milestone: RewardMilestone
    let isUnlocked: Bool
    let isCurrent: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(isUnlocked ? milestone.color : Color.gray.opacity(0.35))
                    .frame(width: isCurrent ? 92 : 80, height: isCurrent ? 92 : 80)
                    .overlay(Circle().stroke(Color.white, lineWidth: 7))
                    .shadow(color: .black.opacity(0.18), radius: 5, x: 0, y: 4)

                Image(systemName: milestone.icon)
                    .font(.system(size: isCurrent ? 32 : 28, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: isCurrent ? 92 : 80, height: isCurrent ? 92 : 80)

                Text("\(milestone.starsRequired)")
                    .font(.system(size: milestone.starsRequired >= 100 ? 13 : 15, weight: .heavy))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
                    .frame(width: 48, height: 48)
                    .background(Color.yellow)
                    .clipShape(StarBadgeShape())
                    .offset(x: 14, y: -14)
            }

            VStack(spacing: 1) {
                Text(milestone.title)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(Color(red: 0.07, green: 0.16, blue: 0.24))

                Text(milestone.subtitle)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct IceDecorationView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 150, height: 150)
                .offset(x: -160, y: -260)

            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 90, height: 90)
                .offset(x: 150, y: -120)

            Image(systemName: "snowflake")
                .font(.system(size: 38))
                .foregroundColor(.white.opacity(0.7))
                .offset(x: -130, y: 170)

            Image(systemName: "snowflake")
                .font(.system(size: 28))
                .foregroundColor(.white.opacity(0.7))
                .offset(x: 145, y: 260)
        }
    }
}

struct StarBadgeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 5
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.5

        for i in 0..<(points * 2) {
            let angle = Double(i) * .pi / Double(points) - .pi / 2
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}
