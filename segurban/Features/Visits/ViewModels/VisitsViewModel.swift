//
//  VisitsViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

class VisitsViewModel: ObservableObject {
    @Published var visits: [Visit] = []
    @Published var searchText: String = ""
    @Published var selectedStatus: VisitStatus = .all
    
    var filteredVisits: [String: [Visit]] {
        var result = visits
        
        // Filter by Status
        if selectedStatus != .all {
            result = result.filter { $0.status == selectedStatus }
        }
        
        // Filter by Search
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Group by Day (Today, Yesterday, Older)
        let grouped = Dictionary(grouping: result) { visit -> String in
            if Calendar.current.isDateInToday(visit.date) {
                return "HOY"
            } else if Calendar.current.isDateInYesterday(visit.date) {
                return "AYER"
            } else {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "es_ES")
                formatter.dateFormat = "d MMMM"
                return formatter.string(from: visit.date).uppercased()
            }
        }
        
        return grouped
    }
    
    var sortedSections: [String] {
        let sections = filteredVisits.keys.sorted { section1, section2 in
            if section1 == "HOY" { return true }
            if section2 == "HOY" { return false }
            if section1 == "AYER" { return true }
            if section2 == "AYER" { return false }
            // For other dates, simple string sort (not ideal but works for demo if dates are recent)
            // Ideally we'd map back to date, but for now this suffices or we can improve sort logic
            return section1 > section2 
        }
        return sections
    }
    
    init() {
        loadVisits()
    }
    
    func loadVisits() {
        // Mock Data
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        self.visits = [
            Visit(
                name: "Roberto Mendez",
                date: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: today)!,
                status: .used,
                accessMethod: .qr,
                accessCode: "#A284",
                licensePlate: "GBA-1234"
            ),
            Visit(
                name: "María Gonzalez",
                date: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: today)!,
                status: .overdue, // Representing "Vencido" from image
                accessMethod: .qr,
                accessCode: "#B102",
                licensePlate: nil
            ),
            Visit(
                name: "Ana Torres",
                date: Calendar.current.date(bySettingHour: 18, minute: 45, second: 0, of: yesterday)!,
                status: .used,
                accessMethod: .normal, // No QR code shown in image implies normal/manual
                accessCode: nil,
                licensePlate: "PCH-9876"
            ),
            Visit(
                name: "Juan Pérez",
                date: Calendar.current.date(bySettingHour: 9, minute: 15, second: 0, of: yesterday)!,
                status: .used,
                accessMethod: .code,
                accessCode: "8294",
                licensePlate: nil
            ),
            Visit(
                name: "Carlos Ruiz",
                date: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: yesterday)!,
                status: .rejected,
                accessMethod: .normal,
                accessCode: nil,
                licensePlate: "GTD-5521"
            ),
            Visit(
                name: "Pedro Alcantara",
                date: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!, // Future/Pending
                status: .active,
                accessMethod: .qr,
                accessCode: "#C991",
                licensePlate: nil
            ),
            Visit(
                name: "Lucia Méndez",
                date: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!, // Future/Pending
                status: .active,
                accessMethod: .code,
                accessCode: "9912",
                licensePlate: "ABC-1234"
            )
        ]
    }
}
