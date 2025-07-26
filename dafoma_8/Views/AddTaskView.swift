//
//  AddTaskView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Add Task View
struct AddTaskView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: TaskCategory = .personal
    @State private var selectedPriority: TaskPriority = .medium
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var estimatedDuration: Double = 1 // in hours
    @State private var hasReward = false
    @State private var rewardAmount: String = ""
    @State private var rewardType: RewardType = .money
    @State private var rewardDescription: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appSecondaryText)
                    
                    Spacer()
                    
                    Text("Add Task")
                        .font(.headline)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(.appYellow)
                    .disabled(title.isEmpty)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("What needs to be done?", text: $title)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appBackground.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.appText)
                        }
                        
                        // Description Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("Additional details...", text: $description)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appBackground.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.appText)
                        }
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    TaskCategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        // Priority Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            Picker("Priority", selection: $selectedPriority) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    Text(priority.rawValue).tag(priority)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .background(Color.appBackground.opacity(0.3))
                        }
                        
                        // Due Date
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Set Due Date", isOn: $hasDueDate)
                                .foregroundColor(.appText)
                                .toggleStyle(SwitchToggleStyle(tint: .appYellow))
                            
                            if hasDueDate {
                                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .accentColor(.appYellow)
                            }
                        }
                        
                        // Estimated Duration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Estimated Duration: \(String(format: "%.1f", estimatedDuration)) hours")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            Slider(value: $estimatedDuration, in: 0.5...8, step: 0.5)
                                .accentColor(.appYellow)
                        }
                        
                        // Reward Section
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Add Reward", isOn: $hasReward)
                                .foregroundColor(.appText)
                                .toggleStyle(SwitchToggleStyle(tint: .appYellow))
                            
                            if hasReward {
                                VStack(spacing: 12) {
                                    Picker("Reward Type", selection: $rewardType) {
                                        ForEach(RewardType.allCases, id: \.self) { type in
                                            Text(type.rawValue).tag(type)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .background(Color.appBackground.opacity(0.3))
                                    
                                    HStack {
                                        Text("$")
                                            .foregroundColor(.appText)
                                        TextField("Amount", text: $rewardAmount)
                                            .keyboardType(.decimalPad)
                                            .foregroundColor(.appText)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.appBackground.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                    
                                    TextField("Reward description...", text: $rewardDescription)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.appBackground.opacity(0.3))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                        )
                                        .foregroundColor(.appText)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
    
    private func saveTask() {
        guard !title.isEmpty else { return }
        
        let reward: TaskReward? = hasReward && !rewardAmount.isEmpty ? TaskReward(
            type: rewardType,
            amount: Double(rewardAmount) ?? 0,
            description: rewardDescription.isEmpty ? "Task completion reward" : rewardDescription
        ) : nil
        
        let task = ProductivityTask(
            title: title,
            description: description,
            category: selectedCategory,
            priority: selectedPriority,
            dueDate: hasDueDate ? dueDate : nil,
            estimatedDuration: estimatedDuration * 3600, // Convert to seconds
            reward: reward
        )
        
        dataManager.tasks.append(task)
        dataManager.saveData()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddTaskView()
        .environmentObject(DataManager())
} 