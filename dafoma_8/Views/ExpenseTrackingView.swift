//
//  ExpenseTrackingView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Expense Tracking View
struct ExpenseTrackingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddExpense = false
    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var searchText = ""
    
    var filteredExpenses: [Expense] {
        var expenses = dataManager.expenses
        
        if let category = selectedCategory {
            expenses = expenses.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            expenses = expenses.filter { 
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return expenses.sorted { $0.date > $1.date }
    }
    
    var categoryTotals: [(category: ExpenseCategory, total: Double)] {
        let groupedExpenses = Dictionary(grouping: dataManager.expenses) { $0.category }
        return groupedExpenses.map { (category, expenses) in
            (category: category, total: expenses.reduce(0) { $0 + $1.amount })
        }.sorted { $0.total > $1.total }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with Stats
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Expense Tracking")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appText)
                            Text("Manage your spending wisely")
                                .font(.subheadline)
                                .foregroundColor(.appSecondaryText)
                        }
                        Spacer()
                        
                        Button(action: { showingAddExpense = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                        }
                    }
                    
                    // Monthly Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Monthly Summary")
                                .font(.headline)
                                .foregroundColor(.appText)
                            Spacer()
                            Text(String(format: "$%.2f", dataManager.totalMonthlyExpenses))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appYellow)
                        }
                        
                        // Category breakdown
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categoryTotals.prefix(4), id: \.category) { item in
                                    CategorySummaryCard(
                                        category: item.category,
                                        amount: item.total,
                                        isSelected: selectedCategory == item.category
                                    ) {
                                        selectedCategory = selectedCategory == item.category ? nil : item.category
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appBackground.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Search and Filter
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appSecondaryText)
                        TextField("Search expenses...", text: $searchText)
                            .foregroundColor(.appText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appBackground.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    
                    Button(action: { selectedCategory = nil; searchText = "" }) {
                        Text("Clear")
                            .foregroundColor(.appYellow)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Expenses List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredExpenses) { expense in
                            ExpenseRow(expense: expense) {
                                // Edit action
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
                .environmentObject(dataManager)
        }
    }
}

#Preview {
    ExpenseTrackingView()
        .environmentObject(DataManager())
} 