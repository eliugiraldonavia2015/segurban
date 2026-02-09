//
//  LoginViewModel.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var selectedRole: UserRole = .resident
    @Published var selectedUrbanization: String = ""
    @Published var searchText: String = ""
    @Published var isSearchingUrbanization: Bool = false
    
    // Form Fields
    @Published var manzana: String = ""
    @Published var villa: String = ""
    @Published var password: String = ""
    @Published var username: String = "" // For Guard/Admin
    @Published var email: String = "" // For Admin
    
    @Published var isAuthenticated: Bool = false
    
    func login() {
        // Mock Login Logic
        // In a real app, this would validate credentials with a backend
        isAuthenticated = true
        print("Login with role: \(selectedRole)")
    }
}
