//
//  OnboardingModels.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Onboarding Models
struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let iconName: String
    let backgroundColor: Color
    let accentColor: Color
    let features: [String]
}

// MARK: - Onboarding Data
extension OnboardingSlide {
    static let slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Welcome to FinFlow",
            subtitle: "Your Financial Productivity Hub",
            description: "Take control of your finances while boosting your productivity. Track expenses, complete tasks, and achieve your financial goals.",
            iconName: "chart.pie.fill",
            backgroundColor: .appBackground,
            accentColor: .appYellow,
            features: [
                "Smart expense tracking",
                "Productivity task management", 
                "Financial goal achievement",
                "Automated insights"
            ]
        ),
        
        OnboardingSlide(
            title: "Track Every Expense",
            subtitle: "Know Where Your Money Goes",
            description: "Effortlessly categorize and monitor your spending patterns. Get detailed insights into your financial habits.",
            iconName: "creditcard.fill",
            backgroundColor: .appBackground,
            accentColor: .appYellow,
            features: [
                "Quick expense entry",
                "Smart categorization",
                "Monthly summaries",
                "Spending insights"
            ]
        ),
        
        OnboardingSlide(
            title: "Productive Tasks, Real Rewards",
            subtitle: "Earn While You Achieve",
            description: "Complete productivity tasks and earn real financial rewards. Turn your daily achievements into monetary gains.",
            iconName: "checkmark.circle.fill",
            backgroundColor: .appBackground,
            accentColor: .appGreen,
            features: [
                "Task-based rewards",
                "Priority management",
                "Progress tracking",
                "Achievement badges"
            ]
        ),
        
        OnboardingSlide(
            title: "Financial Sprints",
            subtitle: "Time-Bounded Goal Achievement",
            description: "Set financial goals with deadlines. Our unique sprint system helps you achieve targets faster with focused motivation.",
            iconName: "target",
            backgroundColor: .appBackground,
            accentColor: .appYellow,
            features: [
                "Goal-oriented sprints",
                "Milestone tracking",
                "Deadline motivation",
                "Progress visualization"
            ]
        ),
        
        OnboardingSlide(
            title: "Never Miss a Payment",
            subtitle: "Smart Bill Reminders",
            description: "Stay on top of your bills with intelligent reminders. Avoid late fees and maintain your credit score effortlessly.",
            iconName: "bell.fill",
            backgroundColor: .appBackground,
            accentColor: .red,
            features: [
                "Automated reminders",
                "Recurring bill tracking",
                "Payment confirmations",
                "Late fee prevention"
            ]
        ),
        
        OnboardingSlide(
            title: "Ready to Transform Your Finances?",
            subtitle: "Let's Get Started!",
            description: "You're all set to begin your journey towards better financial health and increased productivity. Welcome aboard!",
            iconName: "rocket.fill",
            backgroundColor: .appBackground,
            accentColor: .appGreen,
            features: [
                "Personalized dashboard",
                "Smart recommendations",
                "Achievement tracking",
                "Financial freedom"
            ]
        )
    ]
}

// MARK: - User Preferences Manager
class UserPreferences: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var isFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
    }
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch") == nil ? true : UserDefaults.standard.bool(forKey: "isFirstLaunch")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        isFirstLaunch = false
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        isFirstLaunch = true
    }
} 