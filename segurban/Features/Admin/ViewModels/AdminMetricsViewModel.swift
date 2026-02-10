//
//  AdminMetricsViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct CollectionMetric: Identifiable {
    let id = UUID()
    let month: String
    let percentage: Double
}

struct MaintenanceStat: Identifiable {
    let id = UUID()
    let title: String
    let count: Int
    let icon: String
    let color: Color
}

class AdminMetricsViewModel: ObservableObject {
    // Collection Metrics
    @Published var currentCollectionPercentage: Double = 0.0
    @Published var previousCollectionPercentage: Double = 0.0
    @Published var collectionHistory: [CollectionMetric] = []
    
    // Maintenance Metrics
    @Published var maintenanceStats: [MaintenanceStat] = []
    
    // Security/Access Metrics
    @Published var totalVisits: Int = 0
    @Published var activeAlerts: Int = 0
    
    // Animation triggers
    @Published var isAnimated: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock Data
        
        // Collection: 85% this month, 78% last month
        currentCollectionPercentage = 0.85
        previousCollectionPercentage = 0.78
        
        collectionHistory = [
            CollectionMetric(month: "Jun", percentage: 0.75),
            CollectionMetric(month: "Jul", percentage: 0.82),
            CollectionMetric(month: "Ago", percentage: 0.80),
            CollectionMetric(month: "Sep", percentage: 0.78),
            CollectionMetric(month: "Oct", percentage: 0.85)
        ]
        
        maintenanceStats = [
            MaintenanceStat(title: "Podas de Jardín", count: 12, icon: "leaf.fill", color: .green),
            MaintenanceStat(title: "Limpieza Piscina", count: 8, icon: "drop.fill", color: .cyan),
            MaintenanceStat(title: "Reparación Luces", count: 3, icon: "lightbulb.fill", color: .yellow),
            MaintenanceStat(title: "Recolección Basura", count: 20, icon: "trash.fill", color: .orange)
        ]
        
        totalVisits = 1250
        activeAlerts = 2
    }
    
    var collectionGrowth: Double {
        return currentCollectionPercentage - previousCollectionPercentage
    }
}
