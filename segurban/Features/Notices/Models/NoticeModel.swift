//
//  NoticeModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum NoticeCategory: String, CaseIterable, Codable {
    case all = "Todos"
    case urgent = "Urgente"
    case maintenance = "Mantenimiento"
    case events = "Eventos"
    case services = "Servicios"
    case rules = "Reglamento"
    case reception = "Recepción"
}

enum NoticePriority: String, Codable {
    case high
    case normal
    case low
}

struct Notice: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let category: NoticeCategory
    let priority: NoticePriority
    let imageName: String?
    let tags: [String]
    let isRead: Bool
    
    // For UI customization
    var iconName: String {
        switch category {
        case .urgent: return "exclamationmark.triangle.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        case .events: return "calendar"
        case .services: return "clock.arrow.circlepath"
        case .rules: return "book.closed.fill" // or swim icon for specific rule
        case .reception: return "shippingbox.fill"
        default: return "bell.fill"
        }
    }
    
    var iconBackgroundColor: Color {
        switch category {
        case .urgent: return .red
        case .maintenance: return .orange
        case .events: return .purple
        case .services: return .green
        case .rules: return .blue
        case .reception: return .orange
        default: return .gray
        }
    }
}
