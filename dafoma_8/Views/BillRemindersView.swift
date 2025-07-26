//
//  BillRemindersView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Bill Reminders View
struct BillRemindersView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddBill = false
    @State private var selectedFilter: BillFilter = .upcoming
    
    enum BillFilter: String, CaseIterable {
        case upcoming = "Upcoming"
        case overdue = "Overdue"
        case paid = "Paid"
        case all = "All"
    }
    
    var filteredBills: [BillReminder] {
        switch selectedFilter {
        case .upcoming:
            return dataManager.upcomingBills
        case .overdue:
            return dataManager.overdueBills
        case .paid:
            return dataManager.bills.filter { $0.isPaid }
        case .all:
            return dataManager.bills.sorted { $0.dueDate < $1.dueDate }
        }
    }
    
    var upcomingThisWeek: [BillReminder] {
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return dataManager.upcomingBills.filter { $0.dueDate <= nextWeek }
    }
    
    var totalUpcomingAmount: Double {
        upcomingThisWeek.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bill Reminders")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appText)
                            Text("Never miss a payment")
                                .font(.subheadline)
                                .foregroundColor(.appSecondaryText)
                        }
                        Spacer()
                        
                        Button(action: { showingAddBill = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                        }
                    }
                    
                    // Summary Cards
                    HStack(spacing: 12) {
                        BillSummaryCard(
                            title: "This Week",
                            value: String(format: "$%.0f", totalUpcomingAmount),
                            subtitle: "\(upcomingThisWeek.count) bills",
                            color: .appYellow,
                            icon: "calendar.circle.fill"
                        )
                        
                        BillSummaryCard(
                            title: "Overdue",
                            value: "\(dataManager.overdueBills.count)",
                            subtitle: "Need attention",
                            color: .red,
                            icon: "exclamationmark.triangle.fill"
                        )
                        
                        BillSummaryCard(
                            title: "Paid",
                            value: "\(dataManager.bills.filter { $0.isPaid }.count)",
                            subtitle: "This month",
                            color: .appGreen,
                            icon: "checkmark.circle.fill"
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Filter Tabs
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(BillFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.appBackground.opacity(0.3))
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Bills List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if filteredBills.isEmpty {
                            EmptyBillsView(filter: selectedFilter) {
                                showingAddBill = true
                            }
                        } else {
                            ForEach(filteredBills) { bill in
                                BillRow(bill: bill) {
                                    markBillAsPaid(bill)
                                } onEdit: {
                                    // Edit bill action
                                }
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
        .sheet(isPresented: $showingAddBill) {
            AddBillView()
                .environmentObject(dataManager)
        }
    }
    
    private func markBillAsPaid(_ bill: BillReminder) {
        if let index = dataManager.bills.firstIndex(where: { $0.id == bill.id }) {
            dataManager.bills[index].isPaid = true
            dataManager.bills[index].paidDate = Date()
            dataManager.saveData()
        }
    }
}

#Preview {
    BillRemindersView()
        .environmentObject(DataManager())
} 