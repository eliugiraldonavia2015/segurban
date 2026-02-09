//
//  LoginViewModel.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

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
    
    func login() {
        // Implement login logic here
        print("Login with role: \(selectedRole)")
    }
}
