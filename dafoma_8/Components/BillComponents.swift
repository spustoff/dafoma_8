//
//  BillComponents.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Bill Components
struct BillSummaryCard: View {
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

struct EmptyBillsView: View {
    let filter: BillRemindersView.BillFilter
    let onAddBill: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: emptyStateIcon)
                .font(.title)
                .foregroundColor(.appSecondaryText)
            
            VStack(spacing: 8) {
                Text(emptyStateTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appText)
                
                Text(emptyStateMessage)
                    .font(.caption)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if filter == .upcoming || filter == .all {
                Button("Add First Bill") {
                    onAddBill()
                }
                .foregroundColor(.appYellow)
            }
        }
        .padding(.vertical, 40)
    }
    
    private var emptyStateIcon: String {
        switch filter {
        case .upcoming: return "calendar"
        case .overdue: return "checkmark.circle"
        case .paid: return "checkmark.circle.fill"
        case .all: return "doc.text"
        }
    }
    
    private var emptyStateTitle: String {
        switch filter {
        case .upcoming: return "No Upcoming Bills"
        case .overdue: return "All Caught Up!"
        case .paid: return "No Paid Bills"
        case .all: return "No Bills Yet"
        }
    }
    
    private var emptyStateMessage: String {
        switch filter {
        case .upcoming: return "Add your first bill to get reminders"
        case .overdue: return "Great job staying on top of your bills"
        case .paid: return "Paid bills will appear here"
        case .all: return "Start by adding your recurring bills"
        }
    }
}

struct BillRow: View {
    let bill: BillReminder
    let onMarkPaid: () -> Void
    let onEdit: () -> Void
    
    var urgencyColor: Color {
        if bill.isOverdue {
            return .red
        } else if bill.daysUntilDue <= 1 {
            return .orange
        } else if bill.daysUntilDue <= 3 {
            return .appYellow
        } else {
            return .appGreen
        }
    }
    
    var urgencyText: String {
        if bill.isOverdue {
            return "Overdue"
        } else if bill.daysUntilDue == 0 {
            return "Due Today"
        } else if bill.daysUntilDue == 1 {
            return "Due Tomorrow"
        } else {
            return "\(bill.daysUntilDue) days"
        }
    }
    
    var body: some View {
        HStack {
            // Bill Icon
            Image(systemName: bill.category.icon)
                .foregroundColor(bill.category.color)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(bill.category.color.opacity(0.2))
                )
            
            // Bill Details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(bill.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appText)
                        .strikethrough(bill.isPaid)
                    
                    Spacer()
                    
                    if !bill.isPaid {
                        Text(urgencyText)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(urgencyColor)
                            )
                    }
                }
                
                HStack {
                    Text(bill.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.appSecondaryText)
                    
                    if bill.isPaid {
                        if let paidDate = bill.paidDate {
                            Text("Paid \(DateFormatter.shortDate.string(from: paidDate))")
                                .font(.caption)
                                .foregroundColor(.appGreen)
                        }
                    } else {
                        Text("Due \(DateFormatter.shortDate.string(from: bill.dueDate))")
                            .font(.caption)
                            .foregroundColor(.appSecondaryText)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "$%.2f", bill.amount))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(bill.isPaid ? .appGreen : .appText)
                }
            }
            
            // Action Buttons
            VStack(spacing: 8) {
                if !bill.isPaid {
                    Button(action: onMarkPaid) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.appGreen)
                            .font(.title3)
                    }
                }
                
                Button(action: onEdit) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.appSecondaryText)
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
                        .stroke(bill.isPaid ? Color.appGreen.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
} 