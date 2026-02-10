//
//  AdminDashboardViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct AdminStat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let percentage: String
    let isPositive: Bool
    let icon: String
    let color: Color
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let image: String // For background effect
}

struct AdminActivity: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let type: ActivityType
    let value: String?
}

enum ActivityType {
    case payment
    case alert
    case access
    case maintenance
    
    var icon: String {
        switch self {
        case .payment: return "dollarsign.circle.fill"
        case .alert: return "exclamationmark.triangle.fill"
        case .access: return "slash.circle.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .payment: return .green
        case .alert: return .red
        case .access: return .gray
        case .maintenance: return .blue
        }
    }
}

class AdminDashboardViewModel: ObservableObject {
    @Published var stats: [AdminStat] = []
    @Published var quickActions: [QuickAction] = []
    @Published var recentActivities: [AdminActivity] = []
    @Published var showFabMenu: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock Data
        stats = [
            AdminStat(title: "COBRANZA", value: "85%", percentage: "+5%", isPositive: true, icon: "banknote", color: .blue),
            AdminStat(title: "RESIDENTES", value: "142", percentage: "+2%", isPositive: true, icon: "person.2.fill", color: .purple),
            AdminStat(title: "VISITAS", value: "45", percentage: "-1%", isPositive: false, icon: "car.fill", color: .orange)
        ]
        
        quickActions = [
            QuickAction(title: "Comunidad", subtitle: "Residentes y Staff", icon: "person.3.fill", image: "community_bg"),
            QuickAction(title: "Panel Pagos", subtitle: "Control Financiero", icon: "creditcard.fill", image: "payments_bg"),
            QuickAction(title: "Avisos", subtitle: "Enviar Alertas", icon: "megaphone.fill", image: "alerts_bg"),
            QuickAction(title: "Auditoría", subtitle: "Historial y Logs", icon: "doc.text.magnifyingglass", image: "audit_bg")
        ]
        
        recentActivities = [
            AdminActivity(title: "Pago Recibido", subtitle: "Casa 4B • Mantenimiento", time: "2 min", type: .payment, value: "+$150.00"),
            AdminActivity(title: "Queja: Ruido", subtitle: "Torre A • Reportado por Guardia", time: "20 min", type: .alert, value: "Nueva"),
            AdminActivity(title: "Acceso Denegado", subtitle: "Portón Principal • Código Inválido", time: "1 h", type: .access, value: nil),
            AdminActivity(title: "Mantenimiento", subtitle: "Piscina • Limpieza finalizada", time: "3 h", type: .maintenance, value: nil)
        ]
    }
}
