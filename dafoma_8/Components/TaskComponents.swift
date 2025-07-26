//
//  TaskComponents.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Task Components
struct TaskStatsCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.appText)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.appSecondaryText)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.appSecondaryText)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
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

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .appYellow
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .black : .appText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? color : Color.appBackground.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? color : Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
}

struct TaskRow: View {
    let task: ProductivityTask
    let onToggle: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            // Completion Button
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .appGreen : .appSecondaryText)
                    .font(.title2)
            }
            
            // Task Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.appText)
                        .strikethrough(task.isCompleted)
                    
                    Spacer()
                    
                    // Priority Badge
                    Text(task.priority.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(task.priority.color)
                        )
                }
                
                HStack {
                    // Category
                    HStack(spacing: 4) {
                        Image(systemName: task.category.icon)
                            .foregroundColor(task.category.color)
                            .font(.caption)
                        Text(task.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                    }
                    
                    if let dueDate = task.dueDate {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                        
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                    }
                    
                    Spacer()
                    
                    // Reward
                    if let reward = task.reward {
                        HStack(spacing: 2) {
                            Image(systemName: reward.type.icon)
                                .foregroundColor(.appYellow)
                                .font(.caption)
                            Text(String(format: "$%.0f", reward.amount))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.appYellow)
                        }
                    }
                }
            }
            
            // Edit Button
            Button(action: onEdit) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.appSecondaryText)
                    .font(.caption)
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

struct TaskCategoryButton: View {
    let category: TaskCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .appText)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 60)
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