//
//  AccountStatusViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

class AccountStatusViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedTab: Int = 0 // 0: Pendientes, 1: Historial
    
    // Header Data
    @Published var totalPendingAmount: Double = 100.00
    @Published var nextDueDate: String = "30 Nov, 2023"
    @Published var overallStatus: PaymentStatus = .overdue
    
    var filteredTransactions: [String: [Transaction]] {
        let filtered = transactions.filter { transaction in
            if selectedTab == 0 {
                // Pendientes: Status is pending, unpaid, or overdue
                return transaction.status == .pending || transaction.status == .unpaid || transaction.status == .overdue
            } else {
                // Historial: Status is paid (or maybe all past transactions)
                return transaction.status == .paid
            }
        }
        
        // Group by Month Year
        let grouped = Dictionary(grouping: filtered) { transaction in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_ES")
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: transaction.date).capitalized
        }
        
        return grouped
    }
    
    var sortedMonths: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "MMMM yyyy"
        
        return filteredTransactions.keys.sorted {
            guard let date1 = formatter.date(from: $0),
                  let date2 = formatter.date(from: $1) else { return false }
            return date1 > date2
        }
    }
    
    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        // Mock Data based on image
        // Current Month (Nov 2023)
        let novDate = Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 15))!
        let novDue = Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 30))!
        
        // Past Month (Oct 2023)
        let octDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 12))!
        let octDue = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 30))!
        
        // Future/Recent
        let tennisDate = Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 12, hour: 18))!
        
        self.transactions = [
            Transaction(
                title: "Alícuota Noviembre",
                amount: 60.00,
                date: novDate,
                dueDate: novDue,
                type: .alicuota,
                status: .pending
            ),
            Transaction(
                title: "Reserva Cancha Tenis",
                amount: 20.00,
                date: tennisDate,
                dueDate: nil,
                type: .reservation,
                status: .paid
            ),
            Transaction(
                title: "Alícuota Octubre",
                amount: 40.00,
                date: octDate,
                dueDate: octDue,
                type: .alicuota,
                status: .unpaid // Represented as "Sin Pago" in image but could be unpaid/overdue
            )
        ]
        
        // Recalculate total pending
        calculateTotalPending()
    }
    
    func calculateTotalPending() {
        let pending = transactions.filter { $0.status != .paid }
        totalPendingAmount = pending.reduce(0) { $0 + $1.amount }
        
        // Determine status based on dates
        // Simple logic for demo
        if pending.contains(where: { $0.status == .unpaid || $0.status == .overdue }) {
            overallStatus = .overdue
        } else if !pending.isEmpty {
            overallStatus = .pending
        } else {
            overallStatus = .paid
        }
    }
}
