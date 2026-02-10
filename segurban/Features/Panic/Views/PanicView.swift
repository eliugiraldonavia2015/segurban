//
//  PanicView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct PanicView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PanicViewModel()
    
    // Animation States
    @State private var pulseEffect = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            if viewModel.isAlertSent {
                successView
                    .transition(.opacity.combined(with: .scale))
            } else {
                mainView
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Main Panic Interface
    
    var mainView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(10)
                }
                Spacer()
                Text("Seguridad")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("Botón de Pánico")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Mantén presionado el botón para enviar una alerta inmediata a la garita.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Panic Button
            ZStack {
                // Background Glow
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .scaleEffect(pulseEffect ? 1.1 : 1.0)
                    .opacity(pulseEffect ? 0.5 : 0.2)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseEffect)
                
                // Progress Circle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 10)
                    .frame(width: 220, height: 220)
                
                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(
                        LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                
                // Button
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF3B30"), Color(hex: "D70015")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 200, height: 200)
                    .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 10)
                    .scaleEffect(viewModel.isPressed ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isPressed)
                    .overlay(
                        VStack(spacing: 5) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("SOS")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            Text("Presionar")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
                    .onLongPressGesture(minimumDuration: 100.0, pressing: { isPressing in
                        if isPressing {
                            viewModel.startPress()
                        } else {
                            viewModel.cancelPress()
                        }
                    }) {
                        // Action completed handled by timer
                    }
            }
            .onAppear {
                pulseEffect = true
            }
            
            Spacer()
            
            // Status Badge
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("SISTEMA CONECTADO")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .tracking(1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(20)
            
            Spacer()
            
            // Location Card
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: "location.fill")
                        .foregroundColor(.red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ubicación Actual")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Detectada automáticamente")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Map Placeholder
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "map.fill")
                            .foregroundColor(.white.opacity(0.5))
                    )
            }
            .padding(20)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Success / Sent Interface
    
    var successView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success Animation
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            .scaleEffect(1.1)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: viewModel.isAlertSent)
            
            VStack(spacing: 15) {
                Text("¡Alerta Enviada!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("La emergencia ha sido notificada a los guardias y a las 3 unidades más cercanas.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("La ayuda está en camino.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            
            VStack(spacing: 10) {
                Text("Enviando ayuda a:")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text("\(viewModel.urbanization)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(viewModel.locationName)
                    .font(.headline)
                    .foregroundColor(.cyan)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    viewModel.reset()
                    dismiss()
                }
            }) {
                Text("Cerrar")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PanicView()
}
