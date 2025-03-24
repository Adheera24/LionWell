//
//  gamification.swift
//  LionWell real
//
//  Created by Adheera Chilamkurthi on 3/11/25.
import SwiftUI

// Gamification Code
struct CheckInQuestion {
    let question: String
    let options: [String]
}

class CheckInManager: ObservableObject {
    @Published var userRank: Int = 0
    @Published var responses: [Int] = []
    
    let questions = [
        CheckInQuestion(
            question: "How has the plan been working for you?",
            options: ["Very Effective", "Somewhat Effective", "Not Effective"]
        ),
        CheckInQuestion(
            question: "How confident are you in following your plan today?",
            options: ["Very Confident", "Somewhat Confident", "Not Confident"]
        ),
        CheckInQuestion(
            question: "How satisfied are you with your progress so far?",
            options: ["Very Satisfied", "Somewhat Satisfied", "Not Satisfied"]
        ),
        CheckInQuestion(
            question: "How likely are you to meet your goals this week?",
            options: ["Very Likely", "Somewhat Likely", "Not Likely"]
        ),
        CheckInQuestion(
            question: "Have you implemented any part of your plan today?",
            options: ["Yes", "Somewhat", "No"]
        )
    ]
    
    func calculateRank() {
        let score = responses.reduce(0, +)
        
        // Score range: 0-10 where lower is better
        if score <= 3 {
            userRank = Int.random(in: 1...5) // Top 5
        } else if score <= 7 {
            userRank = Int.random(in: 20...30) // Middle tier
        } else {
            userRank = Int.random(in: 40...50) // Bottom tier
        }
    }
}

struct CheckInView: View {
    @StateObject private var manager = CheckInManager()
    @State private var currentQuestionIndex = 0
    @State private var showingResults = false
    @State private var showingLeaderboard = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if !showingResults {
                    // Question Section
                    VStack(spacing: 16) {
                        Text("Daily Check-In")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color.red)
                        
                        Text(manager.questions[currentQuestionIndex].question)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            // Dynamically generate buttons based on the number of options
                            ForEach(0..<manager.questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    manager.responses.append(index)
                                    if currentQuestionIndex < manager.questions.count - 1 {
                                        currentQuestionIndex += 1
                                    } else {
                                        manager.calculateRank()
                                        showingResults = true
                                    }
                                }) {
                                    Text(manager.questions[currentQuestionIndex].options[index])
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.purple)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                } else {
                    // Results Section
                    VStack(spacing: 20) {
                        Text("Your Current Ranking")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("#\(manager.userRank)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color.green)
                        
                        if manager.userRank <= 5 {
                            VStack {
                                Text("🎉 Congratulations! 🎉")
                                    .font(.system(size: 24, weight: .bold))
                                
                                Text("You've earned a swag bag of merchandise and healthy snacks!")
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingLeaderboard = true
                        }) {
                            Text("View Leaderboard")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            currentQuestionIndex = 0
                            manager.responses.removeAll()
                            showingResults = false
                        }) {
                            Text("Start New Check-In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        
                        // Navigation Link to HealthChatView
                        NavigationLink(destination: HealthChatView()) {
                            Text("Go to Health Chat")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Check-In")
            .sheet(isPresented: $showingLeaderboard) {
                LeaderboardView()
            }
        }
    }
}

struct LeaderboardView: View {
    // Create a sample leaderboard with specific names for the top 5 ranks
    let rankings: [(Int, String)] = [
        (1, "User     1001"),
        (2, "User     1002"),
        (3, "User     1003"),
        (4, "User     1004"),
        (5, "User     1005")
    ] + (6...50).map { rank -> (Int, String) in
        let name = "User     \(Int.random(in: 1000...9999))"
        return (rank, name)
    }
    
    var body: some View {
        List {
            ForEach(rankings, id: \.0) { rank, name in
                HStack {
                    Text("#\(rank)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(rank <= 5 ? Color("4A90E2") : .primary)
                        .frame(width: 50)
                    
                    Text(name)
                        .font(.system(size: 16))
                    
                    if rank <= 5 {
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.pink)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Leaderboard")
    }
}

