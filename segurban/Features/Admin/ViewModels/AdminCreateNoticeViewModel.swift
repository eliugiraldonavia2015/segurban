//
//  AdminCreateNoticeViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

class AdminCreateNoticeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCategory: NoticeCategory = .maintenance
    @Published var isUrgent: Bool = false
    @Published var isScheduled: Bool = false
    @Published var scheduledDate: Date = Date()
    @Published var selectedImage: String? = nil // Placeholder for image logic
    
    // Status
    @Published var isSubmitting: Bool = false
    @Published var showSuccess: Bool = false
    
    // Validation
    var isValid: Bool {
        !title.isEmpty && !description.isEmpty
    }
    
    func createNotice() {
        guard isValid else { return }
        
        isSubmitting = true
        
        // Simulate Network Call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isSubmitting = false
            self.showSuccess = true
            
            // Reset after success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        title = ""
        description = ""
        selectedCategory = .maintenance
        isUrgent = false
        isScheduled = false
        scheduledDate = Date()
        selectedImage = nil
        showSuccess = false
    }
}
