//
//  AddBillView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Add Bill View
struct AddBillView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedCategory: ExpenseCategory = .utilities
    @State private var isRecurring = false
    @State private var recurringFrequency: RecurringFrequency = .monthly
    @State private var reminderDays: [Int] = [7, 3, 1]
    
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
                    
                    Text("Add Bill Reminder")
                        .font(.headline)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveBill()
                    }
                    .foregroundColor(.appYellow)
                    .disabled(title.isEmpty || amount.isEmpty)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Bill Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bill Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("e.g., Electric Bill, Rent", text: $title)
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
                        
                        // Amount
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            HStack {
                                Text("$")
                                    .font(.title2)
                                    .foregroundColor(.appText)
                                TextField("0.00", text: $amount)
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
                        
                        // Due Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due Date")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            DatePicker("Select due date", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(.appYellow)
                        }
                        
                        // Category
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
                                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                    CategorySelectionButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        // Recurring Settings
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Recurring Bill", isOn: $isRecurring)
                                .foregroundColor(.appText)
                                .toggleStyle(SwitchToggleStyle(tint: .appYellow))
                            
                            if isRecurring {
                                Picker("Frequency", selection: $recurringFrequency) {
                                    ForEach(RecurringFrequency.allCases, id: \.self) { frequency in
                                        Text(frequency.rawValue).tag(frequency)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(Color.appBackground.opacity(0.3))
                            }
                        }
                        
                        // Reminder Settings
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Remind me")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            VStack(spacing: 8) {
                                ForEach([1, 3, 7, 14], id: \.self) { days in
                                    HStack {
                                        Button(action: {
                                            if reminderDays.contains(days) {
                                                reminderDays.removeAll { $0 == days }
                                            } else {
                                                reminderDays.append(days)
                                            }
                                        }) {
                                            Image(systemName: reminderDays.contains(days) ? "checkmark.square.fill" : "square")
                                                .foregroundColor(reminderDays.contains(days) ? .appYellow : .appSecondaryText)
                                        }
                                        
                                        Text("\(days) day\(days == 1 ? "" : "s") before")
                                            .font(.subheadline)
                                            .foregroundColor(.appText)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        // Bill Tips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💡 Tip")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appYellow)
                            
                            Text("Set up recurring bills to automatically track your monthly expenses and never miss a payment.")
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
    
    private func saveBill() {
        guard !title.isEmpty, !amount.isEmpty, let amountValue = Double(amount) else { return }
        
        let bill = BillReminder(
            title: title,
            amount: amountValue,
            dueDate: dueDate,
            category: selectedCategory,
            isRecurring: isRecurring,
            recurringFrequency: isRecurring ? recurringFrequency : nil,
            reminderDays: reminderDays
        )
        
        dataManager.bills.append(bill)
        dataManager.saveData()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddBillView()
        .environmentObject(DataManager())
} 