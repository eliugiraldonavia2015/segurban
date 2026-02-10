//
//  AdminCommunityViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum ResidentType: String, Codable {
    case owner = "Propietario"
    case renter = "Inquilino"

    var color: Color {
        switch self {
        case .owner: return .cyan
        case .renter: return .purple
        }
    }
}

struct ResidentModel: Identifiable {
    let id = UUID()
    let name: String
    let manzana: String
    let villa: String
    let type: ResidentType
    let email: String
    let phone: String
}

struct StaffModel: Identifiable {
    let id = UUID()
    let name: String
    let role: String // e.g., "Jardinero", "Seguridad"
    let phone: String
    let isAvailable: Bool
}

class AdminCommunityViewModel: ObservableObject {
    @Published var selectedTab: Int = 0 // 0: Residents, 1: Staff
    @Published var searchText: String = ""
    
    @Published var residents: [ResidentModel] = []
    @Published var staff: [StaffModel] = []
    
    var filteredResidents: [ResidentModel] {
        if searchText.isEmpty { return residents }
        return residents.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) || 
            $0.villa.localizedCaseInsensitiveContains(searchText) ||
            $0.manzana.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredStaff: [StaffModel] {
        if searchText.isEmpty { return staff }
        return staff.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) || 
            $0.role.localizedCaseInsensitiveContains(searchText) 
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock Residents
        residents = [
            ResidentModel(name: "Roberto Gómez", manzana: "A", villa: "12", type: .owner, email: "roberto@email.com", phone: "555-0101"),
            ResidentModel(name: "Laura Martínez", manzana: "B", villa: "05", type: .renter, email: "laura@email.com", phone: "555-0102"),
            ResidentModel(name: "Carlos Ruiz", manzana: "C", villa: "08", type: .owner, email: "carlos@email.com", phone: "555-0103"),
            ResidentModel(name: "Ana Torres", manzana: "A", villa: "03", type: .owner, email: "ana@email.com", phone: "555-0104"),
            ResidentModel(name: "Sofia Herrera", manzana: "D", villa: "10", type: .renter, email: "sofia@email.com", phone: "555-0105"),
            ResidentModel(name: "Miguel Ángel", manzana: "E", villa: "01", type: .owner, email: "miguel@email.com", phone: "555-0106")
        ]
        
        // Mock Staff
        staff = [
            StaffModel(name: "Juan Pérez", role: "Jardinero Jefe", phone: "555-1001", isAvailable: true),
            StaffModel(name: "María Rodríguez", role: "Limpieza", phone: "555-1002", isAvailable: true),
            StaffModel(name: "Pedro Almodóvar", role: "Electricista", phone: "555-1003", isAvailable: false),
            StaffModel(name: "Luisa Lane", role: "Entrenadora Gym", phone: "555-1004", isAvailable: true),
            StaffModel(name: "Clark Kent", role: "Seguridad", phone: "555-1005", isAvailable: true)
        ]
    }
}
