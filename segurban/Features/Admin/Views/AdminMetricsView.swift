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
                        
                        // 2. Monthly Trend Graph
                        monthlyTrendCard
                            .offset(y: showContent ? 0 : 40)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                        
                        // 3. Maintenance Stats Grid
                        maintenanceGrid
                            .offset(y: showContent ? 0 : 50)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                        
                        // 4. Operational Stats
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
    
    var monthlyTrendCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tendencia Semestral")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(viewModel.collectionHistory) { metric in
                    VStack {
                        Spacer()
                        
                        // Bar
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: metric.percentage >= 0.8 ? [.cyan, .blue] : [.gray.opacity(0.5), .gray.opacity(0.3)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(height: showContent ? CGFloat(metric.percentage * 120) : 0) // Animation height
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showContent)
                        
                        Text(metric.month)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
    }
    
    var maintenanceGrid: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Mantenimiento Realizado")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(viewModel.maintenanceStats) { stat in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(stat.color.opacity(0.15))
                                .frame(width: 45, height: 45)
                            
                            Image(systemName: stat.icon)
                                .foregroundColor(stat.color)
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(stat.count)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(stat.title)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(hex: "1E1E1E"))
                    .cornerRadius(15)
                }
            }
        }
        .padding(20)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
    }
    
    var operationalStats: some View {
        HStack(spacing: 15) {
            // Visits Stat
            VStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.purple)
                
                Text("\(viewModel.totalVisits)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Visitas Totales")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
            
            // Alerts Stat
            VStack(spacing: 10) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                
                Text("\(viewModel.activeAlerts)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Alertas Activas")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(hex: "152636"))
            .cornerRadius(20)
        }
    }
}
