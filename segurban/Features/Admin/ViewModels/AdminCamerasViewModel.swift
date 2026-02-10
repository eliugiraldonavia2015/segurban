//
//  AdminCamerasViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

struct CameraModel: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let status: String // "En línea", "Grabando", "Offline"
    let isLive: Bool
    
    // In a real app, this would be a URL stream
    // Here we use SF Symbols or placeholder colors to simulate
    let placeholderIcon: String 
}

class AdminCamerasViewModel: ObservableObject {
    @Published var cameras: [CameraModel] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        cameras = [
            CameraModel(name: "Garita Frontal", location: "Entrada Principal", status: "En línea", isLive: true, placeholderIcon: "car.fill"),
            CameraModel(name: "Garita Salida", location: "Salida Principal", status: "En línea", isLive: true, placeholderIcon: "car.2.fill"),
            CameraModel(name: "Área Social Frontal", location: "Club House", status: "Grabando", isLive: true, placeholderIcon: "figure.socialdance"),
            CameraModel(name: "Área Social Trasera", location: "Piscina", status: "Grabando", isLive: true, placeholderIcon: "figure.pool.swim"),
            CameraModel(name: "Cancha de Básquet", location: "Deportes", status: "En línea", isLive: true, placeholderIcon: "basketball.fill"),
            CameraModel(name: "Parque Infantil", location: "Área Verde", status: "En línea", isLive: true, placeholderIcon: "figure.play"),
            CameraModel(name: "Perímetro Norte", location: "Muro Perimetral", status: "Offline", isLive: false, placeholderIcon: "exclamationmark.triangle"),
            CameraModel(name: "Gimnasio", location: "Club House", status: "En línea", isLive: true, placeholderIcon: "dumbbell.fill")
        ]
    }
}
