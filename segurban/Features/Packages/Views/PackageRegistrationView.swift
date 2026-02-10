//
//  PackageRegistrationView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct PackageRegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PackageRegistrationViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // Icon / Hero
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.cyan.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.cyan)
                            }
                            .shadow(color: .cyan.opacity(0.3), radius: 10)
                            
                            Text("Registro de Paquetería")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Notifica a recepción sobre tu próxima entrega para agilizar el ingreso.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .offset(y: showContent ? 0 : 30)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        
                        // Form Fields
                        VStack(spacing: 25) {
                            
                            // Company Name
                            customTextField(
                                title: "Empresa de Reparto",
                                placeholder: "Ej. FedEx, Uber Eats, Amazon...",
                                icon: "building.2.fill",
                                text: $viewModel.companyName
                            )
                            .offset(y: showContent ? 0 : 40)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                            
                            // Instructions
                            customTextField(
                                title: "Instrucciones de Entrega",
                                placeholder: "Ej. Dejar en recepción, llamar al llegar...",
                                icon: "text.bubble.fill",
                                text: $viewModel.deliveryInstructions
                            )
                            .offset(y: showContent ? 0 : 50)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                            
                            // Contents Section
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Contenido del Paquete")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .tracking(1)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $viewModel.includeContents)
                                        .labelsHidden()
                                        .toggleStyle(SwitchToggleStyle(tint: .cyan))
                                }
                                
                                // Conditional Field
                                ZStack {
                                    // Background when disabled
                                    if !viewModel.includeContents {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.black.opacity(0.3))
                                            .overlay(
                                                Text("Detalle desactivado")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.gray.opacity(0.5))
                                            )
                                    }
                                    
                                    HStack(alignment: .top, spacing: 15) {
                                        Image(systemName: "cube.box.fill")
                                            .foregroundColor(viewModel.includeContents ? .cyan : .gray.opacity(0.3))
                                            .frame(width: 24, height: 24)
                                            .padding(.top, 5)
                                        
                                        ZStack(alignment: .topLeading) {
                                            if viewModel.packageContents.isEmpty {
                                                Text("Ej. Ropa, Electrónicos, Comida...")
                                                    .foregroundColor(.gray.opacity(0.5))
                                                    .padding(.top, 8)
                                            }
                                            
                                            TextEditor(text: $viewModel.packageContents)
                                                .frame(minHeight: 80)
                                                .scrollContentBackground(.hidden)
                                                .foregroundColor(viewModel.includeContents ? .white : .gray.opacity(0.5))
                                        }
                                    }
                                    .padding()
                                    .background(viewModel.includeContents ? Color(hex: "152636") : Color.clear)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(viewModel.includeContents ? 0.1 : 0.05), lineWidth: 1)
                                    )
                                    .opacity(viewModel.includeContents ? 1 : 0.5) // "Grisoso" visual effect
                                    .grayscale(viewModel.includeContents ? 0 : 1)
                                }
                                .disabled(!viewModel.includeContents)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.includeContents)
                            }
                            .offset(y: showContent ? 0 : 60)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 50)
                        
                    }
                    .padding(.bottom, 100)
                }
            }
            
            // Bottom Button
            VStack {
                Spacer()
                
                Button(action: {
                    viewModel.registerPackage()
                }) {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Image(systemName: "paperplane.fill")
                            Text("Registrar Entrega")
                        }
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.isValid ? Color.cyan : Color.gray.opacity(0.3))
                    .cornerRadius(20)
                    .shadow(color: viewModel.isValid ? .cyan.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                }
                .disabled(!viewModel.isValid || viewModel.isSubmitting)
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "0D1B2A").opacity(0), Color(hex: "0D1B2A")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .offset(y: showContent ? 0 : 100)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showContent)
            }
            
            // Success Overlay
            if viewModel.showSuccess {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 80, height: 80)
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.green)
                        }
                        .scaleEffect(1.2)
                        
                        Text("¡Registro Exitoso!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Recepción ha sido notificada de tu espera.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.reset()
                            dismiss()
                        }) {
                            Text("Entendido")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .padding(.top, 10)
                    }
                    .padding(30)
                    .background(Color(hex: "152636"))
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .padding(40)
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(10)
            }
            
            Spacer()
            
            Text("Paquetería")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(hex: "0D1B2A"))
    }
    
    func customTextField(title: String, placeholder: String, icon: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .tracking(1)
            
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                    .frame(width: 24)
                
                TextField(placeholder, text: text)
                    .foregroundColor(.white)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder).foregroundColor(.gray.opacity(0.5))
                    }
            }
            .padding()
            .background(Color(hex: "152636"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview {
    PackageRegistrationView()
}
