//
//  AdminDashboardView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var viewModel = AdminDashboardViewModel()
    
    // Animation States
    @State private var showHeader = false
    @State private var showStats = false
    @State private var showQuickActions = false
    @State private var showActivity = false
    @State private var showFab = false
    
    // Navigation
    @State private var showCollection = false
    @State private var showCreateNotice = false
    @State private var showDisabledAlert = false
    @State private var showCommunity = false
    @State private var showMetrics = false
    @State private var showLogbook = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    
                    // Header Section
                    headerView
                        .opacity(showHeader ? 1 : 0)
                        .offset(y: showHeader ? 0 : -20)
                    
                    // Greeting
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hola, Admin")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        Text("Aquí está el resumen de hoy")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .opacity(showHeader ? 1 : 0)
                    .offset(y: showHeader ? 0 : -10)
                    
                    // Stats Cards (Horizontal Scroll)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.stats) { stat in
                                StatCard(stat: stat)
                                    .onTapGesture {
                                        if stat.title == "COBRANZA" {
                                            showCollection = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .opacity(showStats ? 1 : 0)
                    .offset(x: showStats ? 0 : 50)
                    
                    // Quick Management Grid
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Gestión Rápida")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Button("Ver todo") { }
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(viewModel.quickActions) { action in
                                QuickActionCard(action: action)
                                    .onTapGesture {
                                        if action.title == "Avisos" {
                                            showCreateNotice = true
                                        } else if action.title == "Panel Pagos" || action.title == "Auditoría" {
                                            showDisabledAlert = true
                                        } else if action.title == "Comunidad" {
                                            showCommunity = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .opacity(showQuickActions ? 1 : 0)
                    .offset(y: showQuickActions ? 0 : 30)
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Actividad Reciente")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.recentActivities) { activity in
                                ActivityRow(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .opacity(showActivity ? 1 : 0)
                    .offset(y: showActivity ? 0 : 40)
                    
                    Spacer(minLength: 80) // Space for FAB
                }
                .padding(.top, 10)
            }
            
            // FAB Menu Overlay
            if viewModel.showFabMenu {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.showFabMenu = false
                        }
                    }
                    .transition(.opacity)
                
                VStack(alignment: .trailing, spacing: 20) {
                    Spacer()
                    
                    fabOption(title: "Ver Métricas", icon: "chart.xyaxis.line", color: .purple) {
                        showMetrics = true
                        viewModel.showFabMenu = false
                    }
                    
                    fabOption(title: "Verificar Bitácora", icon: "book.fill", color: .orange) {
                        showLogbook = true
                        viewModel.showFabMenu = false
                    }
                    
                    fabOption(title: "Verificar Cámaras", icon: "video.fill", color: .red) {
                        // Action
                    }
                    
                    fabOption(title: "Verificar Placa", icon: "car.fill", color: .blue) {
                        // Action
                    }
                    
                    fabOption(title: "Buscar Villa", icon: "house.fill", color: .cyan) {
                        showCollection = true
                        viewModel.showFabMenu = false
                    }
                    
                    fabOption(title: "Registrar Pago", icon: "dollarsign.circle.fill", color: .green) {
                        showDisabledAlert = true
                        viewModel.showFabMenu = false
                    }
                    
                    fabOption(title: "Crear Aviso", icon: "megaphone.fill", color: .yellow) {
                        showCreateNotice = true
                        viewModel.showFabMenu = false
                    }
                    
                    Spacer().frame(height: 80) // Space for FAB
                }
                .padding(.trailing, 30)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            viewModel.showFabMenu.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(viewModel.showFabMenu ? Color.white : Color.cyan)
                            .clipShape(Circle())
                            .shadow(color: (viewModel.showFabMenu ? Color.white : Color.cyan).opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .rotationEffect(.degrees(viewModel.showFabMenu ? 45 : 0))
                    .scaleEffect(showFab ? 1 : 0)
                    .padding()
                }
            }
        }
        .onAppear {
            animateEntrance()
        }
        .fullScreenCover(isPresented: $showCollection) {
            AdminCollectionView()
        }
        .fullScreenCover(isPresented: $showCreateNotice) {
            AdminCreateNoticeView()
        }
        .alert(isPresented: $showDisabledAlert) {
            Alert(
                title: Text("Módulo Desactivado"),
                message: Text("Esta función se encuentra temporalmente en mantenimiento. Por favor intente más tarde."),
                dismissButton: .default(Text("Entendido"))
            )
        }
        .fullScreenCover(isPresented: $showCommunity) {
            AdminCommunityView()
        }
        .fullScreenCover(isPresented: $showMetrics) {
            AdminMetricsView()
        }
        .fullScreenCover(isPresented: $showLogbook) {
            AdminLogbookView()
        }
    }
    
    private func animateEntrance() {
        withAnimation(.easeOut(duration: 0.6)) {
            showHeader = true
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            showStats = true
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
            showQuickActions = true
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6)) {
            showActivity = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.8)) {
            showFab = true
        }
    }
    
    var headerView: some View {
        HStack {
            Button(action: {
                // Menu Action
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("LA BRISA")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                Text("Admin Panel")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.crop.circle.fill") // Placeholder
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .background(Circle().fill(Color.white.opacity(0.1)))
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color(hex: "0D1B2A"), lineWidth: 2))
            }
            .onTapGesture {
                // Logout or Profile logic
                withAnimation {
                    loginViewModel.isAuthenticated = false
                }
            }
        }
        .padding(.horizontal)
    }
    
    func fabOption(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
                
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 45, height: 45)
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - Subviews

struct StatCard: View {
    let stat: AdminStat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: stat.icon)
                    .font(.system(size: 20))
                    .foregroundColor(stat.color)
                    .padding(10)
                    .background(stat.color.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                Text(stat.percentage)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(stat.isPositive ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        (stat.isPositive ? Color.green : Color.red).opacity(0.2)
                    )
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stat.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .tracking(1)
                
                Text(stat.value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(20)
        .frame(width: 160, height: 150)
        .background(Color(hex: "152636"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

struct QuickActionCard: View {
    let action: QuickAction
    
    var isDisabled: Bool {
        action.title == "Panel Pagos" || action.title == "Auditoría"
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Gradient Background
            if isDisabled {
                Color(hex: "1E1E1E") // Flat dark gray for disabled
            } else {
                LinearGradient(
                    colors: [Color(hex: "152636"), Color(hex: "0D1B2A")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: action.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isDisabled ? .gray : .cyan)
                    .padding(.bottom, 10)
                    .grayscale(isDisabled ? 1.0 : 0.0)
                
                Text(action.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isDisabled ? .gray : .white)
                    .strikethrough(isDisabled, color: .gray)
                
                Text(action.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(15)
            .opacity(isDisabled ? 0.6 : 1.0)
            
            // Diagonal Line Overlay for Disabled
            if isDisabled {
                GeometryReader { geo in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geo.size.height))
                        path.addLine(to: CGPoint(x: geo.size.width, y: 0))
                    }
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                }
            }
        }
        .frame(height: 110)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(isDisabled ? 0.02 : 0.05), lineWidth: 1)
        )
    }
}

struct ActivityRow: View {
    let activity: AdminActivity
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(activity.type.color.opacity(0.15))
                    .frame(width: 45, height: 45)
                
                Image(systemName: activity.type.icon)
                    .font(.system(size: 18))
                    .foregroundColor(activity.type.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(activity.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let value = activity.value {
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(activity.type == .payment ? .green : (activity.type == .alert ? .red : .white))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            activity.type == .alert ? Color.red.opacity(0.2) : Color.clear
                        )
                        .cornerRadius(4)
                }
                
                Text(activity.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(15)
    }
}
