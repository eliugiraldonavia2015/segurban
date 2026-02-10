//
//  AdminSearchVillaViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct ResidentDetail: Identifiable {
    let id = UUID()
    let name: String
    let role: String // Propietario, Inquilino, Esposa, Hijo, etc.
    let phone: String
    let email: String
    let isPrimary: Bool
}

struct VillaModel: Identifiable {
    let id = UUID()
    let manzana: String
    let villa: String
    let residents: [ResidentDetail]
    let vehicles: [String] // Placas
    let pets: [String]
}

class AdminSearchVillaViewModel: ObservableObject {
    @Published var villas: [VillaModel] = []
    @Published var searchText: String = ""
    
    var filteredVillas: [VillaModel] {
        if searchText.isEmpty { return villas }
        
        return villas.filter { villa in
            let location = "\(villa.manzana)-\(villa.villa)"
            let residentMatch = villa.residents.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            
            return location.contains(searchText) || 
                   villa.manzana.localizedCaseInsensitiveContains(searchText) || 
                   villa.villa.localizedCaseInsensitiveContains(searchText) ||
                   residentMatch
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        villas = [
            VillaModel(
                manzana: "10",
                villa: "3",
                residents: [
                    ResidentDetail(name: "Juan Pérez", role: "Propietario", phone: "555-0101", email: "juan@email.com", isPrimary: true),
                    ResidentDetail(name: "Ana Pérez", role: "Hija", phone: "555-0102", email: "ana.p@email.com", isPrimary: false)
                ],
                vehicles: ["ABC-123 (Sedán)", "XYZ-999 (SUV)"],
                pets: ["Max (Perro)"]
            ),
            VillaModel(
                manzana: "15",
                villa: "2",
                residents: [
                    ResidentDetail(name: "María González", role: "Inquilino", phone: "555-0201", email: "maria@email.com", isPrimary: true)
                ],
                vehicles: ["LMN-456 (Moto)"],
                pets: []
            ),
            VillaModel(
                manzana: "5",
                villa: "10",
                residents: [
                    ResidentDetail(name: "Carlos Ruiz", role: "Propietario", phone: "555-0301", email: "carlos@email.com", isPrimary: true),
                    ResidentDetail(name: "Elena Ruiz", role: "Esposa", phone: "555-0302", email: "elena@email.com", isPrimary: false)
                ],
                vehicles: ["BMW-333 (Sedán)"],
                pets: ["Luna (Gato)", "Sol (Gato)"]
            ),
            VillaModel(
                manzana: "A",
                villa: "1",
                residents: [
                    ResidentDetail(name: "Pedro Sánchez", role: "Propietario", phone: "555-0401", email: "pedro@email.com", isPrimary: true)
                ],
                vehicles: [],
                pets: []
            ),
            VillaModel(
                manzana: "20",
                villa: "5",
                residents: [
                    ResidentDetail(name: "Lucía Fernández", role: "Propietario", phone: "555-0501", email: "lucia@email.com", isPrimary: true),
                    ResidentDetail(name: "Roberto Fernández", role: "Padre", phone: "555-0502", email: "roberto@email.com", isPrimary: false)
                ],
                vehicles: ["KIA-101 (SUV)"],
                pets: ["Rocky (Perro)"]
            )
        ]
    }
}
