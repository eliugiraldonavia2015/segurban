//
//  NoticeBoardViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

class NoticeBoardViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var selectedCategory: NoticeCategory = .all
    @Published var searchText: String = ""
    
    var filteredNotices: [Notice] {
        var result = notices
        
        // Filter by Category
        if selectedCategory != .all {
            result = result.filter { $0.category == selectedCategory }
        }
        
        // Filter by Search (if implemented later)
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.date > $1.date }
    }
    
    var featuredNotice: Notice? {
        // For now, return the first urgent/high priority notice or just a specific one
        // Matching the image: "Mantenimiento de Ascensores"
        return notices.first { $0.title.contains("Ascensores") }
    }
    
    var recentNotices: [Notice] {
        // Return all except the featured one
        guard let featured = featuredNotice else { return filteredNotices }
        return filteredNotices.filter { $0.id != featured.id }
    }
    
    init() {
        loadNotices()
    }
    
    func loadNotices() {
        // Mock Data
        self.notices = [
            Notice(
                title: "Mantenimiento de Ascensores",
                description: "Se realizará mantenimiento preventivo en los ascensores principales. Favor de usar las escaleras de emergencia durante el periodo de 10:00 AM a 2:00 PM.",
                date: Date(), // Today
                category: .maintenance,
                priority: .high,
                imageName: "elevator_maintenance", // Placeholder
                tags: ["URGENTE", "Torre B"],
                isRead: false
            ),
            Notice(
                title: "Reunión anual de vecinos",
                description: "Discusión sobre el presupuesto 2024 y votación para las nuevas reformas del reglamento interno.",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, // 15 Nov approx
                category: .events,
                priority: .normal,
                imageName: nil,
                tags: ["Eventos"],
                isRead: true
            ),
            Notice(
                title: "Horario de basura",
                description: "Cambio temporal en el horario de recolección por días festivos. Pasará a las 8:00 AM.",
                date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, // 30 Oct approx
                category: .services,
                priority: .normal,
                imageName: nil,
                tags: ["Servicios"],
                isRead: true
            ),
            Notice(
                title: "Nueva normativa piscina",
                description: "Se actualizan las reglas de uso para invitados los fines de semana. Máximo 2 invitados por familia.",
                date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, // 12 Oct approx
                category: .rules,
                priority: .normal,
                imageName: nil,
                tags: ["Reglamento"],
                isRead: true
            ),
            Notice(
                title: "Paquetería en recepción",
                description: "Recordatorio: Los paquetes deben recogerse antes de las 8:00 PM.",
                date: Calendar.current.date(byAdding: .day, value: -22, to: Date())!, // 10 Oct approx
                category: .reception,
                priority: .normal,
                imageName: nil,
                tags: ["Recepción"],
                isRead: false
            )
        ]
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "'Hoy', h:mm a"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
    }
}
