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
            Group {
                if viewModel.isAlertSent {
                    Color(hex: "2A0A0A") // Deep Red for urgency
                } else {
                    Color(hex: "0D1B2A") // Dark Blue for normal
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: viewModel.isAlertSent)
            
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
            
            // Success Animation (Urgent Pulse)
            ZStack {
                // Outer Pulse
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .scaleEffect(pulseEffect ? 1.2 : 1.0)
                    .opacity(pulseEffect ? 0 : 0.5)
                    .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: pulseEffect)
                
                // Inner Pulse
                Circle()
                    .fill(Color.red.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulseEffect ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseEffect)
                
                // Icon Container
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF3B30"), Color(hex: "D70015")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 150, height: 150)
                    .shadow(color: .red.opacity(0.6), radius: 20, x: 0, y: 10)
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
            }
            .onAppear {
                pulseEffect = true
            }
            
            VStack(spacing: 15) {
                Text("¡ALERTA ENVIADA!")
                    .font(.system(size: 28, weight: .black)) // More urgent font
                    .foregroundColor(.white)
                    .tracking(1)
                
                Text("La emergencia ha sido notificada a los guardias y a las 3 UPS más cercanas.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9)) // Higher contrast
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineSpacing(4)
                
                Text("LA AYUDA ESTÁ EN CAMINO")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.red) // Urgent Red
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color.red.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.top, 10)
            }
            
            VStack(spacing: 10) {
                Text("Enviando ayuda a:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text("\(viewModel.urbanization)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(viewModel.locationName)
                    .font(.headline)
                    .foregroundColor(.red) // Red for location urgency
            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "1A0505")) // Dark Red tint background
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    viewModel.reset()
                    dismiss()
                }
            }) {
                Text("Cerrar")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .background(
            // Subtle red gradient background for urgency
            RadialGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.15), Color.clear]),
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
        )
    }
}

#Preview {
    PanicView()
}
