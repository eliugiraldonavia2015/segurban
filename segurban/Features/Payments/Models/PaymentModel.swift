//
//  PaymentModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum PaymentStatus: String, Codable {
    case pending = "Pendiente"
    case paid = "Pagado"
    case unpaid = "Sin Pago"
    case overdue = "Vencido"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .paid: return .green
        case .unpaid: return .red
        case .overdue: return .red
        }
    }
}

enum TransactionType: String, Codable {
    case alicuota = "Alícuota"
    case reservation = "Reserva"
    case fine = "Multa"
    case other = "Otro"
    
    var icon: String {
        switch self {
        case .alicuota: return "calendar"
        case .reservation: return "tennis.racket" // Generic sport/reservation icon
        case .fine: return "exclamationmark.triangle"
        case .other: return "doc.text"
        }
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let dueDate: Date?
    let type: TransactionType
    let status: PaymentStatus
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
    
    var formattedDueDate: String {
        guard let due = dueDate else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d MMM"
        return "Vence: \(formatter.string(from: due))"
    }
}
