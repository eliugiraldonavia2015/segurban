//
//  PackageRegistrationViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

class PackageRegistrationViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var deliveryInstructions: String = ""
    @Published var includeContents: Bool = true
    @Published var packageContents: String = ""
    
    // UI State
    @Published var isSubmitting: Bool = false
    @Published var showSuccess: Bool = false
    
    var isValid: Bool {
        if companyName.isEmpty || deliveryInstructions.isEmpty {
            return false
        }
        if includeContents && packageContents.isEmpty {
            return false
        }
        return true
    }
    
    func registerPackage() {
        guard isValid else { return }
        
        withAnimation {
            isSubmitting = true
        }
        
        // Mock network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                self.isSubmitting = false
                self.showSuccess = true
            }
        }
    }
    
    func reset() {
        companyName = ""
        deliveryInstructions = ""
        includeContents = true
        packageContents = ""
        showSuccess = false
    }
}
