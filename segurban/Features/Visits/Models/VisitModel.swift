//
//  VisitModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum VisitStatus: String, Codable {
    case all = "Todos"
    case used = "Usado"
    case overdue = "Vencido"
    case active = "Activo"
    case rejected = "Rechazado" // For completeness based on image
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .used: return .green
        case .overdue: return .orange
        case .active: return .cyan
        case .rejected: return .gray
        }
    }
}

enum AccessMethod: String, Codable {
    case qr = "QR"
    case code = "Código"
    case normal = "Normal"
    
    var icon: String {
        switch self {
        case .qr: return "qrcode"
        case .code: return "number.square"
        case .normal: return "person.text.rectangle"
        }
    }
}

struct Visit: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let status: VisitStatus
    let accessMethod: AccessMethod
    let accessCode: String? // e.g., #A284
    let licensePlate: String?
    let cedula: String = "0924251698" // Hardcoded as requested
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        if let first = components.first?.first, let last = components.last?.first {
            return "\(first)\(last)".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var timeDescription: String {
        switch status {
        case .used:
            return "Entrada \(formattedTime)"
        case .overdue:
            return "Vence \(formattedTime)"
        case .active:
            return "Válido hasta \(formattedTime)"
        case .rejected:
            return "Intento \(formattedTime)"
        default:
            return formattedTime
        }
    }
}
