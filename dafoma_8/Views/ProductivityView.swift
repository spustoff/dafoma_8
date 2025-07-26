//
//  ProductivityView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Productivity Tasks View
struct ProductivityView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddTask = false
    @State private var selectedPriority: TaskPriority? = nil
    @State private var selectedCategory: TaskCategory? = nil
    @State private var showCompletedTasks = false
    
    var filteredTasks: [ProductivityTask] {
        var tasks = showCompletedTasks ? dataManager.tasks : dataManager.activeTasks
        
        if let priority = selectedPriority {
            tasks = tasks.filter { $0.priority == priority }
        }
        
        if let category = selectedCategory {
            tasks = tasks.filter { $0.category == category }
        }
        
        return tasks.sorted { task1, task2 in
            if task1.priority != task2.priority {
                let priority1 = TaskPriority.allCases.firstIndex(of: task1.priority) ?? 0
                let priority2 = TaskPriority.allCases.firstIndex(of: task2.priority) ?? 0
                return priority1 > priority2
            }
            return (task1.dueDate ?? Date.distantFuture) < (task2.dueDate ?? Date.distantFuture)
        }
    }
    
    var totalPotentialRewards: Double {
        dataManager.activeTasks.compactMap { $0.reward?.amount }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Productivity Tasks")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appText)
                            Text("Complete tasks, earn rewards")
                                .font(.subheadline)
                                .foregroundColor(.appSecondaryText)
                        }
                        Spacer()
                        
                        Button(action: { showingAddTask = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                        }
                    }
                    
                    // Stats Cards
                    HStack(spacing: 12) {
                        TaskStatsCard(
                            title: "Active Tasks",
                            value: "\(dataManager.activeTasks.count)",
                            subtitle: "Pending",
                            color: .appYellow,
                            icon: "clock.fill"
                        )
                        
                        TaskStatsCard(
                            title: "Potential Rewards",
                            value: String(format: "$%.0f", totalPotentialRewards),
                            subtitle: "Available",
                            color: .appGreen,
                            icon: "dollarsign.circle.fill"
                        )
                        
                        TaskStatsCard(
                            title: "Completed",
                            value: "\(dataManager.completedTasks.count)",
                            subtitle: "This Month",
                            color: .blue,
                            icon: "checkmark.circle.fill"
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Filter Controls
                VStack(spacing: 12) {
                    // View Toggle
                    Picker("View", selection: $showCompletedTasks) {
                        Text("Active").tag(false)
                        Text("Completed").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.appBackground.opacity(0.3))
                    
                    // Priority Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "All Priorities",
                                isSelected: selectedPriority == nil
                            ) {
                                selectedPriority = nil
                            }
                            
                            ForEach(TaskPriority.allCases, id: \.self) { priority in
                                FilterChip(
                                    title: priority.rawValue,
                                    isSelected: selectedPriority == priority,
                                    color: priority.color
                                ) {
                                    selectedPriority = selectedPriority == priority ? nil : priority
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "All Categories",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(TaskCategory.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category,
                                    color: category.color
                                ) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Tasks List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTasks) { task in
                            TaskRow(task: task) {
                                toggleTaskCompletion(task)
                            } onEdit: {
                                // Edit task action
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
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .environmentObject(dataManager)
        }
    }
    
    private func toggleTaskCompletion(_ task: ProductivityTask) {
        if let index = dataManager.tasks.firstIndex(where: { $0.id == task.id }) {
            dataManager.tasks[index].isCompleted.toggle()
            if dataManager.tasks[index].isCompleted {
                dataManager.tasks[index].completedDate = Date()
            } else {
                dataManager.tasks[index].completedDate = nil
            }
            dataManager.saveData()
        }
    }
}

#Preview {
    ProductivityView()
        .environmentObject(DataManager())
} 