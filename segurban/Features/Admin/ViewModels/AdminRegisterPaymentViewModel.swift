//
//  AdminRegisterPaymentViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct DebtItem: Identifiable {
    let id = UUID()
    let manzana: String
    let villa: String
    let owner: String
    let concept: String // e.g., "Alícuota Octubre"
    let amount: Double
    let dueDate: String
    var isSelected: Bool = false
}

class AdminRegisterPaymentViewModel: ObservableObject {
    @Published var debts: [DebtItem] = []
    @Published var searchText: String = ""
    @Published var showSuccessAlert: Bool = false
    
    var filteredDebts: [DebtItem] {
        if searchText.isEmpty { return debts }
        
        return debts.filter { debt in
            let location = "\(debt.manzana)-\(debt.villa)"
            return location.contains(searchText) ||
                   debt.manzana.localizedCaseInsensitiveContains(searchText) ||
                   debt.villa.localizedCaseInsensitiveContains(searchText) ||
                   debt.owner.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        debts = [
            DebtItem(manzana: "10", villa: "3", owner: "Juan Pérez", concept: "Alícuota Octubre 2026", amount: 50.00, dueDate: "05/10/2026"),
            DebtItem(manzana: "10", villa: "3", owner: "Juan Pérez", concept: "Reserva Cancha Tenis", amount: 20.00, dueDate: "10/10/2026"),
            DebtItem(manzana: "15", villa: "2", owner: "María González", concept: "Alícuota Septiembre 2026", amount: 50.00, dueDate: "05/09/2026"),
            DebtItem(manzana: "15", villa: "2", owner: "María González", concept: "Alícuota Octubre 2026", amount: 50.00, dueDate: "05/10/2026"),
            DebtItem(manzana: "5", villa: "10", owner: "Carlos Ruiz", concept: "Multa Mal Estacionamiento", amount: 30.00, dueDate: "12/10/2026"),
            DebtItem(manzana: "A", villa: "1", owner: "Ana Torres", concept: "Alícuota Octubre 2026", amount: 50.00, dueDate: "05/10/2026"),
            DebtItem(manzana: "B", villa: "5", owner: "Pedro Sánchez", concept: "Alícuota Octubre 2026", amount: 50.00, dueDate: "05/10/2026")
        ]
    }
    
    func registerPayment(for debt: DebtItem) {
        // Simulate API call
        if let index = debts.firstIndex(where: { $0.id == debt.id }) {
            // In a real app, we would mark it as paid or remove it
            // For animation demo, let's remove it
            withAnimation {
                debts.remove(at: index)
                showSuccessAlert = true
            }
            
            // Auto hide alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSuccessAlert = false
            }
        }
    }
}
