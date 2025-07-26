//
//  FinancialSprintsView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Financial Sprints View
struct FinancialSprintsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddSprint = false
    @State private var selectedSprint: FinancialSprint? = nil
    
    var activeSprints: [FinancialSprint] {
        dataManager.activeSprints
    }
    
    var completedSprints: [FinancialSprint] {
        dataManager.sprints.filter { !$0.isActive || $0.endDate < Date() }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Financial Sprints")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appText)
                            Text("Time-bounded financial goals")
                                .font(.subheadline)
                                .foregroundColor(.appSecondaryText)
                        }
                        Spacer()
                        
                        Button(action: { showingAddSprint = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                        }
                    }
                    
                    // Sprint Stats
                    if !activeSprints.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(activeSprints) { sprint in
                                    SprintStatsCard(sprint: sprint) {
                                        selectedSprint = sprint
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        EmptySprintCard {
                            showingAddSprint = true
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Sprint Categories Overview
                if !activeSprints.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Active Sprint Categories")
                                .font(.headline)
                                .foregroundColor(.appText)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(SprintCategory.allCases, id: \.self) { category in
                                let sprintsInCategory = activeSprints.filter { $0.category == category }
                                if !sprintsInCategory.isEmpty {
                                    SprintCategoryCard(
                                        category: category,
                                        count: sprintsInCategory.count,
                                        totalProgress: sprintsInCategory.map { $0.progress }.reduce(0, +) / Double(sprintsInCategory.count)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                // All Sprints List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if !activeSprints.isEmpty {
                            ForEach(activeSprints) { sprint in
                                SprintRow(sprint: sprint) {
                                    selectedSprint = sprint
                                }
                            }
                        }
                        
                        if !completedSprints.isEmpty {
                            Section(header: HStack {
                                Text("Completed Sprints")
                                    .font(.headline)
                                    .foregroundColor(.appSecondaryText)
                                Spacer()
                            }.padding(.horizontal)) {
                                ForEach(completedSprints) { sprint in
                                    SprintRow(sprint: sprint, isCompleted: true) {
                                        selectedSprint = sprint
                                    }
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
        .sheet(isPresented: $showingAddSprint) {
            AddSprintView()
                .environmentObject(dataManager)
        }
        .sheet(item: $selectedSprint) { sprint in
            SprintDetailView(sprint: sprint)
                .environmentObject(dataManager)
        }
    }
}

#Preview {
    FinancialSprintsView()
        .environmentObject(DataManager())
} 