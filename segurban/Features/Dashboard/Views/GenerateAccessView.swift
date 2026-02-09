//
//  GenerateAccessView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct GenerateAccessView: View {
    @Environment(\.dismiss) var dismiss
    @State private var guestName: String = "María González"
    @State private var visitDate: Date = Date()
    @State private var duration: String = "4 horas"
    @State private var timeRange: ClosedRange<Double> = 18...22
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Generar Acceso")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Guest Input
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Invitado")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack {
                                TextField("Nombre del invitado", text: $guestName)
                                    .foregroundColor(.white)
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Date and Duration
                        HStack(spacing: 15) {
                            // Date
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Fecha")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text("Hoy, 15 Oct") // Mock date for now
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(hex: "152636"))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            
                            // Duration
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Duración")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(duration)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(hex: "152636"))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .frame(width: 120)
                        }
                        
                        // Time Range Slider
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Horario permitido")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(formatTime(timeRange.lowerBound)) - \(formatTime(timeRange.upperBound))")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.cyan)
                            }
                            
                            RangeSlider(range: $timeRange, bounds: 0...24)
                                .padding(.vertical, 10)
                            
                            HStack {
                                Text("12:00")
                                    .font(.caption2)
                                    .foregroundColor(.gray.opacity(0.5))
                                Spacer()
                                Text("00:00")
                                    .font(.caption2)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        .padding()
                        .background(Color(hex: "152636"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // QR Code Card
                        VStack(spacing: 20) {
                            Text("ACCESO GENERADO")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                                .tracking(1)
                            
                            Text("Código de Entrada")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            // QR Image Placeholder
                            Image(systemName: "qrcode")
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .foregroundColor(.black)
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .cyan.opacity(0.5), radius: 20, x: 0, y: 0)
                            
                            // Backup Code
                            VStack(spacing: 5) {
                                Text("Código de respaldo")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 10) {
                                    Text("829 104")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.cyan)
                                        .tracking(2)
                                    
                                    Button(action: {}) {
                                        Image(systemName: "doc.on.doc")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "152636"), Color(hex: "0D1B2A")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [.cyan.opacity(0.5), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1
                                )
                        )
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal)
                }
                
                // Bottom Action
                VStack(spacing: 15) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill") // WhatsApp like icon
                            Text("Compartir por WhatsApp")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green) // WhatsApp Green
                        .cornerRadius(15)
                        .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 5) {
                            Text("Ver historial de visitas")
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .background(Color(hex: "0D1B2A"))
            }
        }
        .navigationBarHidden(true)
    }
    
    func formatTime(_ value: Double) -> String {
        let hours = Int(value)
        let minutes = Int((value - Double(hours)) * 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
}

#Preview {
    GenerateAccessView()
}
