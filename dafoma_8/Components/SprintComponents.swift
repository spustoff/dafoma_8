//
//  SprintComponents.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Sprint Components
struct SprintStatsCard: View {
    let sprint: FinancialSprint
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: sprint.category.icon)
                        .foregroundColor(sprint.category.color)
                        .font(.title2)
                    Spacer()
                    Text("\(sprint.daysRemaining)d")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.appSecondaryText)
                }
                
                // Title and Progress
                VStack(alignment: .leading, spacing: 8) {
                    Text(sprint.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appText)
                        .lineLimit(2)
                    
                    // Progress Bar
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(format: "$%.0f", sprint.currentAmount))
                                .font(.caption)
                                .foregroundColor(.appText)
                            Spacer()
                            Text(String(format: "$%.0f", sprint.goalAmount))
                                .font(.caption)
                                .foregroundColor(.appSecondaryText)
                        }
                        
                        ProgressView(value: sprint.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: sprint.category.color))
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        
                        Text(String(format: "%.0f%% Complete", sprint.progress * 100))
                            .font(.caption2)
                            .foregroundColor(.appSecondaryText)
                    }
                }
            }
            .padding()
            .frame(width: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appBackground.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(sprint.category.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct EmptySprintCard: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: "target")
                    .font(.title)
                    .foregroundColor(.appYellow)
                
                VStack(spacing: 8) {
                    Text("Start Your First Sprint")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appText)
                    
                    Text("Create time-bounded financial goals and track your progress")
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                        .multilineTextAlignment(.center)
                }
                
                Text("Tap to Begin")
                    .font(.caption)
                    .foregroundColor(.appYellow)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appBackground.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appYellow.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct SprintCategoryCard: View {
    let category: SprintCategory
    let count: Int
    let totalProgress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(category.color)
                    .font(.title3)
                Spacer()
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
            }
            
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.appText)
            
            ProgressView(value: totalProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: category.color))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
            
            Text(String(format: "%.0f%% Avg Progress", totalProgress * 100))
                .font(.caption2)
                .foregroundColor(.appSecondaryText)
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
}

struct SprintRow: View {
    let sprint: FinancialSprint
    var isCompleted: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Sprint Icon
                Image(systemName: sprint.category.icon)
                    .foregroundColor(sprint.category.color)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(sprint.category.color.opacity(0.2))
                    )
                
                // Sprint Details
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(sprint.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.appText)
                        Spacer()
                        if !isCompleted {
                            Text("\(sprint.daysRemaining) days left")
                                .font(.caption)
                                .foregroundColor(.appSecondaryText)
                        }
                    }
                    
                    HStack {
                        Text(sprint.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                        
                        Text(String(format: "$%.0f / $%.0f", sprint.currentAmount, sprint.goalAmount))
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                    }
                    
                    // Progress Bar
                    ProgressView(value: sprint.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: sprint.category.color))
                        .scaleEffect(x: 1, y: 1.2, anchor: .center)
                }
                
                // Progress Percentage
                VStack {
                    Text(String(format: "%.0f%%", sprint.progress * 100))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(sprint.category.color)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.appGreen)
                            .font(.caption)
                    }
                }
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
    }
}

struct SprintCategorySelectionButton: View {
    let category: SprintCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .appText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color : Color.appBackground.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? category.color : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
} 