//
//  DashboardView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Dashboard View
struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    statsCardsSection
                    recentActivitySection
                    insightsSection
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome to FinFlow")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
                Text("Your Financial Productivity Hub")
                    .font(.subheadline)
                    .foregroundColor(.appSecondaryText)
            }
            Spacer()
            
            Menu {
                Button("Reset Onboarding") {
                    userPreferences.resetOnboarding()
                }
                Button("Settings") {
                    // Future settings implementation
                }
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.appYellow)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Stats Cards Section
    private var statsCardsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            DashboardCard(
                title: "This Month",
                value: String(format: "$%.0f", dataManager.totalMonthlyExpenses),
                subtitle: "Expenses",
                color: .appYellow,
                icon: "dollarsign.circle.fill"
            )
            
            DashboardCard(
                title: "Active Tasks",
                value: "\(dataManager.activeTasks.count)",
                subtitle: "Pending",
                color: .appGreen,
                icon: "checkmark.circle.fill"
            )
            
            DashboardCard(
                title: "Financial Sprint",
                value: dataManager.activeSprints.first.map { String(format: "%.0f%%", $0.progress * 100) } ?? "0%",
                subtitle: "Progress",
                color: .appYellow,
                icon: "target"
            )
            
            DashboardCard(
                title: "Bills Due",
                value: "\(dataManager.upcomingBills.prefix(7).count)",
                subtitle: "This Week",
                color: .red,
                icon: "bell.fill"
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .foregroundColor(.appText)
                Spacer()
                Button("View All") {
                    // Action
                }
                .foregroundColor(.appYellow)
            }
            
            VStack(spacing: 10) {
                // Show recent expenses
                ForEach(dataManager.expenses.prefix(2)) { expense in
                    ActivityRow(
                        icon: "minus.circle.fill",
                        title: expense.description,
                        subtitle: "\(expense.category.rawValue) • \(DateFormatter.shortDate.string(from: expense.date))",
                        amount: String(format: "-$%.2f", expense.amount),
                        color: .red
                    )
                }
                
                // Show completed tasks
                ForEach(dataManager.completedTasks.prefix(1)) { task in
                    ActivityRow(
                        icon: "checkmark.circle.fill",
                        title: "Task Completed: \(task.title)",
                        subtitle: task.category.rawValue,
                        amount: task.reward != nil ? String(format: "+$%.0f", task.reward!.amount) : "+$0",
                        color: .appGreen
                    )
                }
                
                // Show sprint progress
                if let firstSprint = dataManager.activeSprints.first {
                    ActivityRow(
                        icon: "target",
                        title: "Sprint Progress: \(firstSprint.title)",
                        subtitle: String(format: "%.0f%% Complete", firstSprint.progress * 100),
                        amount: String(format: "$%.0f", firstSprint.currentAmount),
                        color: .appYellow
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Smart Insights")
                    .font(.headline)
                    .foregroundColor(.appText)
                Spacer()
            }
            
            VStack(spacing: 8) {
                if dataManager.overdueBills.count > 0 {
                    InsightCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Bills Need Attention",
                        description: "You have \(dataManager.overdueBills.count) overdue bill\(dataManager.overdueBills.count == 1 ? "" : "s")",
                        color: .red,
                        actionText: "Pay Now"
                    )
                }
                
                if dataManager.activeTasks.count > 5 {
                    InsightCard(
                        icon: "clock.fill",
                        title: "Task Overload",
                        description: "Consider prioritizing your \(dataManager.activeTasks.count) active tasks",
                        color: .orange,
                        actionText: "Organize"
                    )
                }
                
                if let sprint = dataManager.activeSprints.first, sprint.progress > 0.8 {
                    InsightCard(
                        icon: "target",
                        title: "Sprint Almost Complete!",
                        description: "You're \(String(format: "%.0f%%", sprint.progress * 100)) done with '\(sprint.title)'",
                        color: .appGreen,
                        actionText: "Finish Strong"
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
        .environmentObject(DataManager())
}