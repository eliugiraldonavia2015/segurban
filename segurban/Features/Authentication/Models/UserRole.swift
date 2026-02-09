//
//  UserRole.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import Foundation

enum UserRole: String, CaseIterable, Identifiable {
    case resident = "Residente"
    case guardRole = "Guardia"
    case admin = "Administrador"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .resident: return "Soy Residente"
        case .guardRole: return "Soy Guardia"
        case .admin: return "Soy Admin"
        }
    }
    
    var icon: String {
        switch self {
        case .resident: return "house"
        case .guardRole: return "shield"
        case .admin: return "person.badge.key"
        }
    }
}
