//
//  AdminLogbookViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum LogEntryType: String {
    case visitor = "Visita"
    case staff = "Personal"
    case service = "Servicio"
    
    var color: Color {
        switch self {
        case .visitor: return .cyan
        case .staff: return .orange
        case .service: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .visitor: return "person.fill"
        case .staff: return "hammer.fill"
        case .service: return "truck.box.fill"
        }
    }
}

struct LogEntry: Identifiable {
    let id = UUID()
    let name: String
    let type: LogEntryType
    let manzana: Int
    let villa: Int
    let timeIn: String
    let plate: String?
}

class AdminLogbookViewModel: ObservableObject {
    @Published var logEntries: [LogEntry] = []
    @Published var searchText: String = ""
    
    var filteredEntries: [LogEntry] {
        if searchText.isEmpty { return logEntries }
        
        return logEntries.filter { entry in
            let locationString = "\(entry.manzana)-\(entry.villa)"
            return entry.name.localizedCaseInsensitiveContains(searchText) ||
                   locationString.contains(searchText)
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Generate 20 Mock Items
        logEntries = [
            LogEntry(name: "Juan Pérez", type: .visitor, manzana: 10, villa: 3, timeIn: "08:15 AM", plate: "ABC-123"),
            LogEntry(name: "María González", type: .staff, manzana: 15, villa: 2, timeIn: "08:30 AM", plate: nil),
            LogEntry(name: "Carlos Ruiz", type: .service, manzana: 5, villa: 10, timeIn: "09:00 AM", plate: "XYZ-789"),
            LogEntry(name: "Ana Torres", type: .visitor, manzana: 10, villa: 3, timeIn: "09:15 AM", plate: "LMN-456"),
            LogEntry(name: "Pedro Sánchez", type: .staff, manzana: 8, villa: 4, timeIn: "09:45 AM", plate: nil),
            LogEntry(name: "Lucía Fernández", type: .visitor, manzana: 12, villa: 1, timeIn: "10:00 AM", plate: "QWE-101"),
            LogEntry(name: "Jardinero José", type: .staff, manzana: 1, villa: 1, timeIn: "10:10 AM", plate: nil),
            LogEntry(name: "Uber Eats", type: .service, manzana: 14, villa: 5, timeIn: "10:30 AM", plate: "MOTO-22"),
            LogEntry(name: "Sofía Herrera", type: .visitor, manzana: 3, villa: 8, timeIn: "11:00 AM", plate: "CAR-555"),
            LogEntry(name: "Electricista Luis", type: .staff, manzana: 15, villa: 3, timeIn: "11:15 AM", plate: "VAN-88"),
            LogEntry(name: "Miguel Ángel", type: .visitor, manzana: 10, villa: 3, timeIn: "11:45 AM", plate: "KIA-99"),
            LogEntry(name: "Amazon Delivery", type: .service, manzana: 7, villa: 7, timeIn: "12:00 PM", plate: "TRK-001"),
            LogEntry(name: "Laura Martínez", type: .visitor, manzana: 20, villa: 2, timeIn: "12:30 PM", plate: "BMW-33"),
            LogEntry(name: "Limpieza Rosa", type: .staff, manzana: 14, villa: 5, timeIn: "12:45 PM", plate: nil),
            LogEntry(name: "Roberto Gómez", type: .visitor, manzana: 10, villa: 3, timeIn: "01:00 PM", plate: "HON-12"),
            LogEntry(name: "Instalador TV", type: .service, manzana: 9, villa: 9, timeIn: "01:15 PM", plate: "CAB-44"),
            LogEntry(name: "Carmen López", type: .visitor, manzana: 15, villa: 3, timeIn: "01:30 PM", plate: "CHE-77"),
            LogEntry(name: "Piscina Tech", type: .staff, manzana: 1, villa: 1, timeIn: "02:00 PM", plate: nil),
            LogEntry(name: "Rappi", type: .service, manzana: 14, villa: 5, timeIn: "02:15 PM", plate: "MOTO-99"),
            LogEntry(name: "Visita Familiar", type: .visitor, manzana: 10, villa: 3, timeIn: "02:30 PM", plate: "FAM-00")
        ]
    }
}
