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
    @State private var startTime: Date = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var endTime: Date = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var isAccessGenerated: Bool = false
    
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
                                Text(calculateDuration())
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
                    
                    // Time Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Horario permitido")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 20) {
                            // Start Time
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Desde")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            // End Time
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Hasta")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "152636"))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Generate Access Button (Visible when not generated)
                    if !isAccessGenerated {
                        Button(action: {
                            withAnimation {
                                isAccessGenerated = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Generar Acceso")
                            }
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .cornerRadius(15)
                            .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 10)
                    }
                    
                    if isAccessGenerated {
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
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            
            // Bottom Action
            if isAccessGenerated {
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
                .transition(.move(edge: .bottom))
            }
        }
    }
    .navigationBarHidden(true)
}

func calculateDuration() -> String {
    let diff = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: endTime)
    let hours = diff.hour ?? 0
    let minutes = diff.minute ?? 0
    
    if hours < 0 {
        return "0h 0m"
    }
    
    if minutes == 0 {
        return "\(hours) horas"
    } else {
        return "\(hours)h \(minutes)m"
    }
}
}

#Preview {
    GenerateAccessView()
}
