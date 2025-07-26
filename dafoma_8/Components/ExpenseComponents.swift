//
//  ExpenseComponents.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Expense Components
struct CategorySummaryCard: View {
    let category: ExpenseCategory
    let amount: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: category.icon)
                        .foregroundColor(category.color)
                        .font(.title3)
                    Spacer()
                }
                
                Text(String(format: "$%.0f", amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(.appSecondaryText)
            }
            .padding()
            .frame(width: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color.opacity(0.2) : Color.appBackground.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? category.color : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            // Category Icon
            Image(systemName: expense.category.icon)
                .foregroundColor(expense.category.color)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(expense.category.color.opacity(0.2))
                )
            
            // Expense Details
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.appText)
                
                HStack {
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                    
                    Text(expense.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                }
            }
            
            Spacer()
            
            // Amount and Edit
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "-$%.2f", expense.amount))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.caption)
                        .foregroundColor(.appYellow)
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

struct CategorySelectionButton: View {
    let category: ExpenseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.rawValue.split(separator: " ").first?.description ?? category.rawValue)
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