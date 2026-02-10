//
//  AdminMetricsViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct DelinquencyMetric: Identifiable {
    let id = UUID()
    let status: String
    let count: Int
    let color: Color
}

struct MaintenanceStat: Identifiable {
    let id = UUID()
    var title: String
    var count: Int
}

class AdminMetricsViewModel: ObservableObject {
    // Collection Metrics
    @Published var currentCollectionPercentage: Double = 0.0
    @Published var previousCollectionPercentage: Double = 0.0
    
    // Delinquency Metrics (Replacing Trend)
    @Published var delinquencyStats: [DelinquencyMetric] = []
    
    // Maintenance Metrics
    @Published var maintenanceStats: [MaintenanceStat] = []
    
    // Operational Metrics (Replacing Visits/Alerts)
    @Published var openReports: Int = 0
    @Published var monthlyFines: Int = 0
    
    // Animation triggers
    @Published var isAnimated: Bool = false
    
    // Edit State
    @Published var isEditingMaintenance: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock Data
        
        // Collection: 85% this month, 78% last month
        currentCollectionPercentage = 0.85
        previousCollectionPercentage = 0.78
        
        // Delinquency Breakdown
        delinquencyStats = [
            DelinquencyMetric(status: "Al Día", count: 120, color: .green),
            DelinquencyMetric(status: "Pendiente", count: 15, color: .orange),
            DelinquencyMetric(status: "Moroso", count: 7, color: .red)
        ]
        
        // Maintenance - No icons/colors as requested, simplified
        maintenanceStats = [
            MaintenanceStat(title: "Podas de Jardín", count: 12),
            MaintenanceStat(title: "Limpieza Piscina", count: 8),
            MaintenanceStat(title: "Reparación Luces", count: 3),
            MaintenanceStat(title: "Recolección Basura", count: 20)
        ]
        
        // New Operational Stats
        openReports = 5
        monthlyFines = 3
    }
    
    var collectionGrowth: Double {
        return currentCollectionPercentage - previousCollectionPercentage
    }
    
    // Maintenance Actions
    func addMaintenanceItem(title: String, count: Int) {
        maintenanceStats.append(MaintenanceStat(title: title, count: count))
    }
    
    func removeMaintenanceItem(at index: Int) {
        maintenanceStats.remove(at: index)
    }
    
    func updateMaintenanceItem(id: UUID, title: String, count: Int) {
        if let index = maintenanceStats.firstIndex(where: { $0.id == id }) {
            maintenanceStats[index].title = title
            maintenanceStats[index].count = count
        }
    }
}
