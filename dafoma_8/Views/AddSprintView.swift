//
//  AddSprintView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Add Sprint View
struct AddSprintView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var goalAmount: String = ""
    @State private var selectedCategory: SprintCategory = .saving
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var duration: Int = 30 // days
    
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
                    
                    Text("New Financial Sprint")
                        .font(.headline)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button("Create") {
                        createSprint()
                    }
                    .foregroundColor(.appYellow)
                    .disabled(title.isEmpty || goalAmount.isEmpty)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Sprint Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sprint Title")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("e.g., Emergency Fund Challenge", text: $title)
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
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("Describe your financial goal...", text: $description)
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
                        
                        // Goal Amount
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal Amount")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            HStack {
                                Text("$")
                                    .font(.title2)
                                    .foregroundColor(.appText)
                                TextField("1000", text: $goalAmount)
                                    .font(.title2)
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
                        }
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sprint Category")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(SprintCategory.allCases, id: \.self) { category in
                                    SprintCategorySelectionButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sprint Duration: \(duration) days")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            HStack {
                                Text("7 days")
                                    .font(.caption)
                                    .foregroundColor(.appSecondaryText)
                                
                                Slider(value: Binding(
                                    get: { Double(duration) },
                                    set: { duration = Int($0) }
                                ), in: 7...365, step: 1)
                                .accentColor(.appYellow)
                                .onChange(of: duration) { newValue in
                                    endDate = Calendar.current.date(byAdding: .day, value: newValue, to: Date()) ?? Date()
                                }
                                
                                Text("365 days")
                                    .font(.caption)
                                    .foregroundColor(.appSecondaryText)
                            }
                            
                            HStack {
                                Text("End Date:")
                                    .font(.caption)
                                    .foregroundColor(.appSecondaryText)
                                Spacer()
                                Text(endDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.appText)
                            }
                        }
                        
                        // Sprint Tips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💡 Sprint Tips")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appYellow)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("• Break large goals into smaller milestones")
                                Text("• Link productivity tasks to your sprint")
                                Text("• Review progress weekly")
                                Text("• Celebrate milestone achievements")
                            }
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.appYellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.appYellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
    
    private func createSprint() {
        guard !title.isEmpty, !goalAmount.isEmpty, let amount = Double(goalAmount) else { return }
        
        let sprint = FinancialSprint(
            title: title,
            description: description.isEmpty ? "Financial sprint goal" : description,
            goalAmount: amount,
            endDate: endDate,
            category: selectedCategory
        )
        
        dataManager.sprints.append(sprint)
        dataManager.saveData()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddSprintView()
        .environmentObject(DataManager())
} 