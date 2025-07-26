//
//  SprintDetailView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Sprint Detail View
struct SprintDetailView: View {
    let sprint: FinancialSprint
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.appSecondaryText)
                        
                        Spacer()
                        
                        Text("Sprint Details")
                            .font(.headline)
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Button("Edit") {
                            // Edit action
                        }
                        .foregroundColor(.appYellow)
                    }
                    .padding()
                    
                    // Sprint Overview
                    VStack(spacing: 16) {
                        // Title and Category
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sprint.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appText)
                                
                                Text(sprint.category.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.appSecondaryText)
                            }
                            
                            Spacer()
                            
                            Image(systemName: sprint.category.icon)
                                .font(.title)
                                .foregroundColor(sprint.category.color)
                        }
                        
                        // Progress Overview
                        VStack(spacing: 12) {
                            HStack {
                                Text(String(format: "$%.2f", sprint.currentAmount))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appText)
                                
                                Text("of \(String(format: "$%.0f", sprint.goalAmount))")
                                    .font(.headline)
                                    .foregroundColor(.appSecondaryText)
                                
                                Spacer()
                                
                                Text(String(format: "%.0f%%", sprint.progress * 100))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(sprint.category.color)
                            }
                            
                            ProgressView(value: sprint.progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: sprint.category.color))
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            HStack {
                                Text("\(sprint.daysRemaining) days remaining")
                                    .font(.caption)
                                    .foregroundColor(.appSecondaryText)
                                
                                Spacer()
                                
                                Text("Started \(DateFormatter.shortDate.string(from: sprint.startDate))")
                                    .font(.caption)
                                    .foregroundColor(.appSecondaryText)
                            }
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
                    .padding(.horizontal)
                    
                    // Description
                    if !sprint.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.appText)
                            
                            Text(sprint.description)
                                .font(.body)
                                .foregroundColor(.appSecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            // Add progress action
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Progress")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.appYellow)
                            )
                        }
                        
                        Button(action: {
                            // Link task action
                        }) {
                            HStack {
                                Image(systemName: "link")
                                Text("Link Productivity Task")
                            }
                            .font(.headline)
                            .foregroundColor(.appText)
                            .frame(maxWidth: .infinity)
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
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SprintDetailView(sprint: FinancialSprint(
        title: "Emergency Fund",
        description: "Build emergency savings",
        goalAmount: 1000,
        endDate: Date(),
        category: .emergencyFund
    ))
    .environmentObject(DataManager())
} 