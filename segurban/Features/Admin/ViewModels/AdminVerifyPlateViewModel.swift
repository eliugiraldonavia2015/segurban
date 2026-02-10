//
//  AdminVerifyPlateViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

enum DriverType: String {
    case resident = "Residente"
    case visitor = "Visita"
    case staff = "Personal"
    case service = "Servicio"
    
    var color: Color {
        switch self {
        case .resident: return .cyan
        case .visitor: return .purple
        case .staff: return .orange
        case .service: return .yellow
        }
    }
}

enum EntryMethod: String {
    case qr = "QR"
    case code = "Código"
    case call = "Llamada"
    case tag = "Tag"
    
    var icon: String {
        switch self {
        case .qr: return "qrcode"
        case .code: return "number.square"
        case .call: return "phone.fill"
        case .tag: return "sensor.tag.radiowaves.forward.fill"
        }
    }
}

struct VehicleResult: Identifiable {
    let id = UUID()
    let plate: String
    let type: DriverType
    let manzana: String
    let villa: String
    let driverName: String
    let driverID: String? // Cédula (Only for visitors/staff)
    let entryTime: String
    let entryMethod: EntryMethod
    let vehicleModel: String // e.g., "Toyota Corolla"
}

class AdminVerifyPlateViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: VehicleResult? = nil
    @Published var isSearching: Bool = false
    @Published var hasSearched: Bool = false
    
    // Mock Database
    private let mockDatabase: [VehicleResult] = [
        VehicleResult(plate: "ABC-123", type: .resident, manzana: "10", villa: "3", driverName: "Juan Pérez", driverID: nil, entryTime: "08:15 AM", entryMethod: .tag, vehicleModel: "Toyota Corolla"),
        VehicleResult(plate: "XYZ-999", type: .visitor, manzana: "15", villa: "2", driverName: "Pedro Visitante", driverID: "0923456789", entryTime: "10:30 AM", entryMethod: .qr, vehicleModel: "Chevrolet Spark"),
        VehicleResult(plate: "LMN-456", type: .service, manzana: "5", villa: "10", driverName: "Rappi Moto", driverID: "0912345678", entryTime: "11:45 AM", entryMethod: .code, vehicleModel: "Moto Suzuki"),
        VehicleResult(plate: "KIA-101", type: .resident, manzana: "20", villa: "5", driverName: "Lucía Fernández", driverID: nil, entryTime: "12:00 PM", entryMethod: .tag, vehicleModel: "Kia Sportage"),
        VehicleResult(plate: "BMW-333", type: .visitor, manzana: "A", villa: "1", driverName: "Carlos Amigo", driverID: "0987654321", entryTime: "01:15 PM", entryMethod: .call, vehicleModel: "BMW X5")
    ]
    
    func searchPlate() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        hasSearched = true
        searchResult = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.searchResult = self.mockDatabase.first { 
                $0.plate.localizedCaseInsensitiveContains(self.searchText)
            }
            self.isSearching = false
        }
    }
    
    func reset() {
        searchText = ""
        searchResult = nil
        hasSearched = false
    }
}
