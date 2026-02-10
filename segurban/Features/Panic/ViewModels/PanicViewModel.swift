//
//  PanicViewModel.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI
import Combine

class PanicViewModel: ObservableObject {
    @Published var isPressed: Bool = false
    @Published var progress: CGFloat = 0.0
    @Published var isAlertSent: Bool = false
    
    // Timer for the 3 seconds press
    private var timer: Timer?
    private let pressDuration: TimeInterval = 3.0
    private var currentDuration: TimeInterval = 0.0
    
    // Location Data
    @Published var locationName: String = "Manzana B, Lote 12"
    @Published var urbanization: String = "Urbanización La Brisa"
    
    func startPress() {
        isPressed = true
        startTimer()
    }
    
    func cancelPress() {
        isPressed = false
        stopTimer()
        withAnimation {
            progress = 0.0
        }
    }
    
    private func startTimer() {
        currentDuration = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentDuration += 0.05
            withAnimation(.linear(duration: 0.05)) {
                self.progress = CGFloat(self.currentDuration / self.pressDuration)
            }
            
            if self.currentDuration >= self.pressDuration {
                self.triggerAlert()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func triggerAlert() {
        stopTimer()
        withAnimation {
            isPressed = false
            isAlertSent = true
        }
        
        // Auto-dismiss or reset after some time could be added here
    }
    
    func reset() {
        isAlertSent = false
        progress = 0.0
    }
}
