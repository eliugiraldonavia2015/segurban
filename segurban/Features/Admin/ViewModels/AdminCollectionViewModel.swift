//
//  AdminCollectionViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

// Use the PaymentStatus from PaymentModel.swift instead of redefining it
// or rename this if it has different semantics. 
// Given the user error "Invalid redeclaration", we should remove this enum 
// and use the one in PaymentModel if appropriate, or rename it.
// Looking at the values: "Al Día", "Deuda", "Pendiente".
// PaymentModel has: "Pendiente", "Pagado", "Sin Pago", "Vencido".
// They are slightly different. Let's rename this one to CollectionStatus to avoid conflict.

enum CollectionStatus: String {
    case upToDate = "Al Día"
    case overdue = "Deuda"
    case pending = "Pendiente"
    
    var color: Color {
        switch self {
        case .upToDate: return .green
        case .overdue: return .red
        case .pending: return .orange
        }
    }
}

struct HouseDebtModel: Identifiable {
    let id = UUID()
    let manzana: String
    let villa: String
    let ownerName: String
    let status: CollectionStatus
    let totalDebt: Double
    let pendingMaintenanceMonths: Int // Cantidad de alícuotas pendientes
    let pendingReservations: Int // Cantidad de reservas sin pagar
    let lastPaymentDate: String
}

class AdminCollectionViewModel: ObservableObject {
    @Published var houses: [HouseDebtModel] = []
    @Published var searchText: String = ""
    @Published var selectedStatusFilter: CollectionStatus? = nil
    
    var filteredHouses: [HouseDebtModel] {
        houses.filter { house in
            let matchesSearch = searchText.isEmpty || 
                                house.ownerName.localizedCaseInsensitiveContains(searchText) ||
                                house.manzana.localizedCaseInsensitiveContains(searchText) ||
                                house.villa.localizedCaseInsensitiveContains(searchText)
            
            let matchesStatus = selectedStatusFilter == nil || house.status == selectedStatusFilter
            
            return matchesSearch && matchesStatus
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock Data
        houses = [
            HouseDebtModel(manzana: "A", villa: "1", ownerName: "Carlos Pérez", status: .upToDate, totalDebt: 0, pendingMaintenanceMonths: 0, pendingReservations: 0, lastPaymentDate: "01 Oct 2026"),
            HouseDebtModel(manzana: "A", villa: "2", ownerName: "María López", status: .overdue, totalDebt: 150.00, pendingMaintenanceMonths: 2, pendingReservations: 1, lastPaymentDate: "15 Ago 2026"),
            HouseDebtModel(manzana: "B", villa: "5", ownerName: "Juan Rodriguez", status: .pending, totalDebt: 75.00, pendingMaintenanceMonths: 1, pendingReservations: 0, lastPaymentDate: "05 Sep 2026"),
            HouseDebtModel(manzana: "C", villa: "10", ownerName: "Ana Martínez", status: .overdue, totalDebt: 450.00, pendingMaintenanceMonths: 5, pendingReservations: 2, lastPaymentDate: "10 May 2026"),
            HouseDebtModel(manzana: "D", villa: "3", ownerName: "Pedro Sánchez", status: .upToDate, totalDebt: 0, pendingMaintenanceMonths: 0, pendingReservations: 0, lastPaymentDate: "02 Oct 2026"),
            HouseDebtModel(manzana: "E", villa: "8", ownerName: "Lucía Fernández", status: .overdue, totalDebt: 25.00, pendingMaintenanceMonths: 0, pendingReservations: 1, lastPaymentDate: "20 Sep 2026")
        ]
    }
}
