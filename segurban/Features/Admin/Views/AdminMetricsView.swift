//
//  AdminMetricsView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminMetricsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminMetricsViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    @State private var animatedPercentage: Double = 0.0
    
    // Edit Sheet State
    @State private var showMaintenanceSheet = false
    @State private var editingItem: MaintenanceStat? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // 1. Collection Performance (Hero)
                        collectionPerformanceCard
                            .offset(y: showContent ? 0 : 30)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        
                        // 2. Delinquency Stats (Replaces Trend)
                        delinquencyCard
                            .offset(y: showContent ? 0 : 40)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                        
                        // 3. Maintenance Stats (Editable)
                        maintenanceSection
                            .offset(y: showContent ? 0 : 50)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                        
                        // 4. Operational Stats (Updated)
                        operationalStats
                            .offset(y: showContent ? 0 : 60)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
            
            // Edit Sheet Overlay
            if showMaintenanceSheet {
                MaintenanceEditSheet(
                    item: editingItem,
                    onSave: { title, count in
                        if let item = editingItem {
                            viewModel.updateMaintenanceItem(id: item.id, title: title, count: count)
                        } else {
                            viewModel.addMaintenanceItem(title: title, count: count)
                        }
                        showMaintenanceSheet = false
                        editingItem = nil
                    },
                    onDismiss: {
                        showMaintenanceSheet = false
                        editingItem = nil
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(100)
            }
        }
        .onAppear {
            withAnimation {
                showContent = true
            }
            // Animate percentage count up
            withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
                animatedPercentage = viewModel.currentCollectionPercentage
            }
        }
    }
    
    // MARK: - Components
    
    var headerView: some View {
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
            
            Text("Métricas de Desempeño")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
    }
    
    var collectionPerformanceCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Cobranza Mensual")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("Octubre")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyan.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack(spacing: 30) {
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 20)
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .trim(from: 0, to: animatedPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(Int(animatedPercentage * 100))%")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                        Text("Recaudado")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Comparison Text
                VStack(alignment: .leading, spacing: 10) {
                    Text("Vs. Mes Anterior")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Image(systemName: viewModel.collectionGrowth >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(viewModel.collectionGrowth >= 0 ? .green : .red)
                        
                        Text("\(abs(Int(viewModel.collectionGrowth * 100)))%")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(viewModel.collectionGrowth >= 0 ? .green : .red)
                    }
                    
                    Text(viewModel.collectionGrowth >= 0 ? "Mejor desempeño" : "Menor recaudación")
                        .font(.caption2)
                        .foregroundColor(viewModel.collectionGrowth >= 0 ? .green.opacity(0.8) : .red.opacity(0.8))
                }
            }
            .padding(.vertical, 10)
        }
        .padding(20)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    var delinquencyCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Estado de Morosidad")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                ForEach(viewModel.delinquencyStats) { stat in
                    VStack {
                        Text("\(stat.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(stat.color)
                        Text(stat.status)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if stat.id != viewModel.delinquencyStats.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .frame(height: 40)
                    }
                }
            }
            .padding(20)
            .background(Color(hex: "1E1E1E"))
            .cornerRadius(15)
        }
        .padding(20)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
    }
    
    var maintenanceSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Mantenimiento Realizado")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    editingItem = nil
                    withAnimation { showMaintenanceSheet = true }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.cyan)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.maintenanceStats) { stat in
                    HStack {
                        Text(stat.title)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(stat.count) veces")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        
                        // Edit/Delete Menu
                        Menu {
                            Button(action: {
                                editingItem = stat
                                withAnimation { showMaintenanceSheet = true }
                            }) {
                                Label("Editar", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                if let index = viewModel.maintenanceStats.firstIndex(where: { $0.id == stat.id }) {
                                    withAnimation {
                                        viewModel.removeMaintenanceItem(at: index)
                                    }
                                }
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(Color.white.opacity(0.05))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color(hex: "1E1E1E"))
                    .cornerRadius(12)
                }
                
                if viewModel.maintenanceStats.isEmpty {
                    Text("No hay registros de mantenimiento.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .padding(20)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
    }
    
    var operationalStats: some View {
        HStack(spacing: 15) {
            // Open Reports
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.bubble.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                
                Text("\(viewModel.openReports)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Reportes Pendientes")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
            
            // Monthly Fines
            VStack(spacing: 10) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
                
                Text("\(viewModel.monthlyFines)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Multas del Mes")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
        }
    }
}

// MARK: - Helper Views

struct MaintenanceEditSheet: View {
    let item: MaintenanceStat?
    let onSave: (String, Int) -> Void
    let onDismiss: () -> Void
    
    @State private var title: String = ""
    @State private var countString: String = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack(spacing: 20) {
                Text(item == nil ? "Agregar Mantenimiento" : "Editar Mantenimiento")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("Título (ej. Poda)", text: $title)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                TextField("Cantidad", text: $countString)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    Button("Cancelar") { onDismiss() }
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Guardar") {
                        if let count = Int(countString), !title.isEmpty {
                            onSave(title, count)
                        }
                    }
                    .foregroundColor(.cyan)
                    .fontWeight(.bold)
                }
                .padding(.top, 10)
            }
            .padding(25)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
            .padding(30)
            .shadow(radius: 20)
            .onAppear {
                if let item = item {
                    title = item.title
                    countString = String(item.count)
                }
            }
        }
    }
}
