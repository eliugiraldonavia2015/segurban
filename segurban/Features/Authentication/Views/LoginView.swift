//
//  LoginView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Namespace private var animation
    
    var body: some View {
        if viewModel.isAuthenticated {
            DashboardView()
                .transition(.opacity)
        } else {
            loginContent
        }
    }
    
    var loginContent: some View {
        ZStack {
            // Background
            Color(hex: "0D1B2A") // Dark Navy
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header / Logo
                VStack(spacing: 20) {
                    Image(systemName: "shield.checkerboard") // Logo placeholder
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 20, x: 0, y: 0)
                    
                    Text("SEGURBAN")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Text("Bienvenido. Ingresa tus datos para gestionar tu seguridad.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Content
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Urbanization Selector
                        UrbanizationSelector(
                            selection: $viewModel.selectedUrbanization,
                            searchText: $viewModel.searchText,
                            isSearching: $viewModel.isSearchingUrbanization
                        )
                        .zIndex(10) // Keep on top of other fields
                        
                        if !viewModel.isSearchingUrbanization {
                            // Dynamic Form Fields
                            VStack(spacing: 20) {
                                Group {
                                    switch viewModel.selectedRole {
                                    case .resident:
                                        residentFields
                                    case .guardRole:
                                        guardFields
                                    case .admin:
                                        adminFields
                                    }
                                }
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            }
                            .padding(.top, 10)
                            
                            // Action Button
                            Button(action: {
                                viewModel.login()
                            }) {
                                Text("INICIAR SESIÓN")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [Color.cyan, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(15)
                                    .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Role Switcher
                if !viewModel.isSearchingUrbanization {
                    HStack(spacing: 0) {
                        roleButton(role: .resident)
                        roleButton(role: .guardRole)
                        roleButton(role: .admin)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture {
            // hideKeyboard implementation is now global or can be handled differently
            // but for this view specifically we can use:
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            viewModel.isSearchingUrbanization = false
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - Subviews
    
    var residentFields: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                CustomTextField(placeholder: "Manzana (Mz)", text: $viewModel.manzana)
                CustomTextField(placeholder: "Villa", text: $viewModel.villa)
            }
            CustomSecureField(placeholder: "Contraseña", text: $viewModel.password)
        }
    }
    
    var guardFields: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "ID de Guardia", text: $viewModel.username, icon: "person.badge.shield")
            CustomSecureField(placeholder: "Contraseña", text: $viewModel.password)
        }
    }
    
    var adminFields: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "Correo Electrónico", text: $viewModel.email, icon: "envelope")
            CustomSecureField(placeholder: "Contraseña", text: $viewModel.password)
        }
    }
    
    func roleButton(role: UserRole) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.selectedRole = role
            }
        }) {
            VStack {
                Image(systemName: role.icon)
                    .font(.system(size: 20))
                    .padding(.bottom, 5)
                Text(role.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(viewModel.selectedRole == role ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    if viewModel.selectedRole == role {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.1))
                            .matchedGeometryEffect(id: "roleBackground", in: animation)
                    }
                }
            )
        }
    }
}

#Preview {
    LoginView()
}
