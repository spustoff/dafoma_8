//
//  AddExpenseView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Add Expense View
struct AddExpenseView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: ExpenseCategory = .other
    @State private var date: Date = Date()
    @State private var isRecurring = false
    @State private var recurringFrequency: RecurringFrequency = .monthly
    
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
                    
                    Text("Add Expense")
                        .font(.headline)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveExpense()
                    }
                    .foregroundColor(.appYellow)
                    .disabled(amount.isEmpty || description.isEmpty)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Amount Input
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
                        
                        // Description Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            TextField("What did you spend on?", text: $description)
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
                        
                        // Date Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.appText)
                            
                            DatePicker("Select date", selection: $date, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(.appYellow)
                        }
                        
                        // Recurring Option
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Recurring Expense", isOn: $isRecurring)
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
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount), !description.isEmpty else { return }
        
        let expense = Expense(
            amount: amountValue,
            category: selectedCategory,
            description: description,
            date: date,
            isRecurring: isRecurring,
            recurringFrequency: isRecurring ? recurringFrequency : nil
        )
        
        dataManager.expenses.append(expense)
        dataManager.saveData()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(DataManager())
} 