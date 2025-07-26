//
//  Models.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import Foundation
import SwiftUI

// MARK: - Expense Models
struct Expense: Identifiable, Codable {
    let id = UUID()
    var amount: Double
    var category: ExpenseCategory
    var description: String
    var date: Date
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
    var linkedTaskId: UUID?
    
    init(amount: Double, category: ExpenseCategory, description: String, date: Date = Date(), isRecurring: Bool = false, recurringFrequency: RecurringFrequency? = nil, linkedTaskId: UUID? = nil) {
        self.amount = amount
        self.category = category
        self.description = description
        self.date = date
        self.isRecurring = isRecurring
        self.recurringFrequency = recurringFrequency
        self.linkedTaskId = linkedTaskId
    }
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food & Dining"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case shopping = "Shopping"
    case education = "Education"
    case investment = "Investment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transportation: return "car.fill"
        case .entertainment: return "tv.fill"
        case .utilities: return "house.fill"
        case .healthcare: return "cross.fill"
        case .shopping: return "bag.fill"
        case .education: return "book.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .transportation: return .blue
        case .entertainment: return .purple
        case .utilities: return .appYellow
        case .healthcare: return .red
        case .shopping: return .pink
        case .education: return .appGreen
        case .investment: return .cyan
        case .other: return .gray
        }
    }
}

enum RecurringFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

// MARK: - Task Models
struct ProductivityTask: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var category: TaskCategory
    var priority: TaskPriority
    var dueDate: Date?
    var isCompleted: Bool
    var completedDate: Date?
    var estimatedDuration: TimeInterval
    var actualDuration: TimeInterval?
    var reward: TaskReward?
    var linkedExpenseId: UUID?
    var linkedSprintId: UUID?
    
    init(title: String, description: String = "", category: TaskCategory, priority: TaskPriority, dueDate: Date? = nil, estimatedDuration: TimeInterval = 3600, reward: TaskReward? = nil) {
        self.title = title
        self.description = description
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.isCompleted = false
        self.estimatedDuration = estimatedDuration
        self.reward = reward
    }
}

enum TaskCategory: String, CaseIterable, Codable {
    case financial = "Financial"
    case personal = "Personal"
    case work = "Work"
    case health = "Health"
    case learning = "Learning"
    case household = "Household"
    
    var icon: String {
        switch self {
        case .financial: return "dollarsign.circle.fill"
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .health: return "heart.fill"
        case .learning: return "book.fill"
        case .household: return "house.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .financial: return .appYellow
        case .personal: return .appGreen
        case .work: return .blue
        case .health: return .red
        case .learning: return .purple
        case .household: return .orange
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .urgent: return .red
        }
    }
}

struct TaskReward: Codable {
    var type: RewardType
    var amount: Double
    var description: String
}

enum RewardType: String, CaseIterable, Codable {
    case money = "Money"
    case points = "Points"
    case allowance = "Allowance"
    
    var icon: String {
        switch self {
        case .money: return "dollarsign.circle.fill"
        case .points: return "star.fill"
        case .allowance: return "gift.fill"
        }
    }
}

// MARK: - Financial Sprint Models
struct FinancialSprint: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var goalAmount: Double
    var currentAmount: Double
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var category: SprintCategory
    var linkedTaskIds: [UUID]
    var milestones: [SprintMilestone]
    
    var progress: Double {
        guard goalAmount > 0 else { return 0 }
        return min(currentAmount / goalAmount, 1.0)
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return max(components.day ?? 0, 0)
    }
    
    init(title: String, description: String, goalAmount: Double, startDate: Date = Date(), endDate: Date, category: SprintCategory) {
        self.title = title
        self.description = description
        self.goalAmount = goalAmount
        self.currentAmount = 0
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = true
        self.category = category
        self.linkedTaskIds = []
        self.milestones = []
    }
}

enum SprintCategory: String, CaseIterable, Codable {
    case saving = "Saving"
    case budgeting = "Budgeting"
    case investment = "Investment"
    case debtPayoff = "Debt Payoff"
    case emergencyFund = "Emergency Fund"
    
    var icon: String {
        switch self {
        case .saving: return "piggybank.fill"
        case .budgeting: return "chart.pie.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .debtPayoff: return "creditcard.fill"
        case .emergencyFund: return "shield.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .saving: return .appGreen
        case .budgeting: return .appYellow
        case .investment: return .blue
        case .debtPayoff: return .red
        case .emergencyFund: return .orange
        }
    }
}

struct SprintMilestone: Identifiable, Codable {
    let id = UUID()
    var title: String
    var targetAmount: Double
    var isCompleted: Bool
    var completedDate: Date?
    var reward: Double
    
    init(title: String, targetAmount: Double, reward: Double) {
        self.title = title
        self.targetAmount = targetAmount
        self.isCompleted = false
        self.reward = reward
    }
}

// MARK: - Bill Reminder Models
struct BillReminder: Identifiable, Codable {
    let id = UUID()
    var title: String
    var amount: Double
    var dueDate: Date
    var category: ExpenseCategory
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
    var isPaid: Bool
    var paidDate: Date?
    var linkedTaskId: UUID?
    var reminderDays: [Int] // Days before due date to remind
    
    var isOverdue: Bool {
        !isPaid && dueDate < Date()
    }
    
    var daysUntilDue: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
        return components.day ?? 0
    }
    
    init(title: String, amount: Double, dueDate: Date, category: ExpenseCategory, isRecurring: Bool = false, recurringFrequency: RecurringFrequency? = nil, reminderDays: [Int] = [7, 3, 1]) {
        self.title = title
        self.amount = amount
        self.dueDate = dueDate
        self.category = category
        self.isRecurring = isRecurring
        self.recurringFrequency = recurringFrequency
        self.isPaid = false
        self.reminderDays = reminderDays
    }
}

// MARK: - Data Manager
class DataManager: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var tasks: [ProductivityTask] = []
    @Published var sprints: [FinancialSprint] = []
    @Published var bills: [BillReminder] = []
    
    private let expensesKey = "SavedExpenses"
    private let tasksKey = "SavedTasks"
    private let sprintsKey = "SavedSprints"
    private let billsKey = "SavedBills"
    
    init() {
        loadData()
        createSampleData()
    }
    
    // MARK: - Data Persistence
    func saveData() {
        saveExpenses()
        saveTasks()
        saveSprints()
        saveBills()
    }
    
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: expensesKey)
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func saveSprints() {
        if let encoded = try? JSONEncoder().encode(sprints) {
            UserDefaults.standard.set(encoded, forKey: sprintsKey)
        }
    }
    
    private func saveBills() {
        if let encoded = try? JSONEncoder().encode(bills) {
            UserDefaults.standard.set(encoded, forKey: billsKey)
        }
    }
    
    private func loadData() {
        loadExpenses()
        loadTasks()
        loadSprints()
        loadBills()
    }
    
    private func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: expensesKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([ProductivityTask].self, from: data) {
            tasks = decoded
        }
    }
    
    private func loadSprints() {
        if let data = UserDefaults.standard.data(forKey: sprintsKey),
           let decoded = try? JSONDecoder().decode([FinancialSprint].self, from: data) {
            sprints = decoded
        }
    }
    
    private func loadBills() {
        if let data = UserDefaults.standard.data(forKey: billsKey),
           let decoded = try? JSONDecoder().decode([BillReminder].self, from: data) {
            bills = decoded
        }
    }
    
    // MARK: - Sample Data
    private func createSampleData() {
        if expenses.isEmpty {
            createSampleExpenses()
        }
        if tasks.isEmpty {
            createSampleTasks()
        }
        if sprints.isEmpty {
            createSampleSprints()
        }
        if bills.isEmpty {
            createSampleBills()
        }
    }
    
    private func createSampleExpenses() {
        expenses = [
            Expense(amount: 5.40, category: .food, description: "Starbucks Coffee"),
            Expense(amount: 45.99, category: .transportation, description: "Gas Station Fill-up"),
            Expense(amount: 12.99, category: .entertainment, description: "Netflix Subscription"),
            Expense(amount: 89.50, category: .utilities, description: "Electric Bill"),
            Expense(amount: 25.00, category: .shopping, description: "Online Purchase")
        ]
        saveExpenses()
    }
    
    private func createSampleTasks() {
        tasks = [
            ProductivityTask(title: "Review Monthly Budget", category: .financial, priority: .high, reward: TaskReward(type: .money, amount: 10, description: "Budget review reward")),
            ProductivityTask(title: "Update Investment Portfolio", category: .financial, priority: .medium, reward: TaskReward(type: .money, amount: 15, description: "Investment task reward")),
            ProductivityTask(title: "Pay Credit Card Bill", category: .financial, priority: .urgent, reward: TaskReward(type: .money, amount: 5, description: "Bill payment reward")),
            ProductivityTask(title: "Organize Financial Documents", category: .financial, priority: .low, reward: TaskReward(type: .money, amount: 8, description: "Organization reward"))
        ]
        saveTasks()
    }
    
    private func createSampleSprints() {
        var sprint = FinancialSprint(
            title: "Emergency Fund Goal",
            description: "Build up emergency savings to $1000",
            goalAmount: 1000,
            startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 23, to: Date()) ?? Date(),
            category: .emergencyFund
        )
        sprint.currentAmount = 750
        sprints = [sprint]
        saveSprints()
    }
    
    private func createSampleBills() {
        bills = [
            BillReminder(title: "Rent Payment", amount: 1200, dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(), category: .utilities),
            BillReminder(title: "Phone Bill", amount: 65, dueDate: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(), category: .utilities),
            BillReminder(title: "Internet Service", amount: 79.99, dueDate: Calendar.current.date(byAdding: .day, value: 8, to: Date()) ?? Date(), category: .utilities)
        ]
        saveBills()
    }
    
    // MARK: - Computed Properties
    var totalMonthlyExpenses: Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        return expenses.filter { expense in
            let expenseMonth = calendar.component(.month, from: expense.date)
            let expenseYear = calendar.component(.year, from: expense.date)
            return expenseMonth == currentMonth && expenseYear == currentYear
        }.reduce(0) { $0 + $1.amount }
    }
    
    var activeTasks: [ProductivityTask] {
        tasks.filter { !$0.isCompleted }
    }
    
    var completedTasks: [ProductivityTask] {
        tasks.filter { $0.isCompleted }
    }
    
    var activeSprints: [FinancialSprint] {
        sprints.filter { $0.isActive && $0.endDate >= Date() }
    }
    
    var upcomingBills: [BillReminder] {
        bills.filter { !$0.isPaid && $0.dueDate >= Date() }
            .sorted { $0.dueDate < $1.dueDate }
    }
    
    var overdueBills: [BillReminder] {
        bills.filter { $0.isOverdue }
    }
} 