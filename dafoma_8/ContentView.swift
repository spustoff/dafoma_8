//
//  ContentView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            ExpenseTrackingView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
                .tag(1)
            
            ProductivityView()
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Tasks")
                }
                .tag(2)
            
            FinancialSprintsView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Sprints")
                }
                .tag(3)
            
            BillRemindersView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Bills")
                }
                .tag(4)
        }
        .background(Color.appBackground)
        .accentColor(.appYellow)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
}
