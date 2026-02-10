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
    @State private var showSplash = false
    @State private var isAnimatingLogin = false
    @State private var isKeyboardVisible = false // Track keyboard visibility
    
    var body: some View {
        if viewModel.isAuthenticated && !showSplash && !isAnimatingLogin {
            DashboardView()
                .environmentObject(viewModel)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
        } else {
            ZStack {
                if showSplash {
                    splashScreen
                } else {
                    loginContent
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation { isKeyboardVisible = true }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation { isKeyboardVisible = false }
            }
        }
    }
    
    var splashScreen: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack {
                Image(systemName: "shield.checkerboard")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .matchedGeometryEffect(id: "logo", in: animation)
                    .scaleEffect(1.2)
                    .shadow(color: .cyan.opacity(0.8), radius: 30, x: 0, y: 0)
                    .onAppear {
                        // Move to Dashboard after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showSplash = false
                                viewModel.isAuthenticated = true // Confirm authentication state visually
                                isAnimatingLogin = false // Reset animation state
                            }
                        }
                    }
                
                Text("Bienvenido")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
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
                    if !isAnimatingLogin {
                        Image(systemName: "shield.checkerboard") // Logo placeholder
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .matchedGeometryEffect(id: "logo", in: animation)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 120, height: 120)
                            )
                            .shadow(color: .cyan.opacity(0.5), radius: 20, x: 0, y: 0)
                            .transition(.scale)
                        
                        Text("SEGURBAN")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(2)
                            .transition(.opacity)
                        
                        Text("Bienvenido. Ingresa tus datos para gestionar tu seguridad.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .transition(.opacity)
                    } else {
                        Spacer().frame(height: 200) // Keep spacing
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                if !isAnimatingLogin {
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
                                }
                                .padding(.top, 10)
                                
                                // Action Button
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        isAnimatingLogin = true
                                    }
                                    
                                    // Delay to start splash
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showSplash = true
                                        }
                                    }
                                    
                                    // Trigger ViewModel login logic (mock)
                                    // viewModel.login() call is deferred until splash ends visually or we can call it here to set state
                                    // For now we set isAuthenticated = true in splash onAppear logic above to sync with animation
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
                }
                
                Spacer()
                
                // Role Switcher
                if !viewModel.isSearchingUrbanization && !isAnimatingLogin && !isKeyboardVisible {
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
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture {
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
                CustomTextField(placeholder: "Manzana (Mz)", text: $viewModel.manzana, keyboardType: .numberPad)
                CustomTextField(placeholder: "Villa", text: $viewModel.villa, keyboardType: .numberPad)
            }
            CustomSecureField(placeholder: "Contraseña", text: $viewModel.password)
        }
    }
    
    var guardFields: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "ID de Guardia", text: $viewModel.username, icon: "person.badge.shield", keyboardType: .numberPad)
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
