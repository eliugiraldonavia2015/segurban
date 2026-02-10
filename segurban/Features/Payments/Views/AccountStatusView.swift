//
//  AccountStatusView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AccountStatusView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AccountStatusViewModel()
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
                    VStack(spacing: 25) {
                        
                        // Hero Card (Balance)
                        balanceCard
                            .offset(y: showContent ? 0 : 30)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        
                        // Custom Segmented Control
                        customSegmentedControl
                            .opacity(showContent ? 1 : 0)
                            .animation(.easeIn.delay(0.2), value: showContent)
                        
                        // Transactions List
                        VStack(spacing: 20) {
                            ForEach(viewModel.sortedMonths, id: \.self) { month in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(month)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if month == viewModel.sortedMonths.first {
                                            Text("ACTUAL")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.gray)
                                                .tracking(1)
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                    
                                    ForEach(viewModel.filteredTransactions[month] ?? []) { transaction in
                                        TransactionRow(transaction: transaction)
                                    }
                                }
                            }
                        }
                        .offset(y: showContent ? 0 : 50)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showContent)
                    }
                    .padding(20)
                    .padding(.bottom, 80) // Space for bottom button
                }
            }
            
            // Bottom Button
            VStack {
                Spacer()
                Button(action: {
                    // Report Payment Action
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Reportar Pago")
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.cyan)
                    .cornerRadius(25) // Rounded like in image
                    .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                }
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
            
            VStack(spacing: 4) {
                // Logo placeholder or small text
                Image(systemName: "leaf.fill") // Placeholder for logo
                    .font(.caption)
                    .foregroundColor(.green.opacity(0.7))
                Text("ESTADO DE CUENTA")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .tracking(1)
            }
            
            Spacer()
            
            // Balance placeholder for symmetry
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(hex: "0D1B2A"))
    }
    
    var balanceCard: some View {
        ZStack {
            // Background Image / Gradient
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: "152636"))
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.8), Color(hex: "0D1B2A").opacity(0.4)]),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                )
                // Simulated depth with shadows/lights
                .overlay(
                    // Abstract shapes for "exquisite" feel
                    GeometryReader { geo in
                        Circle()
                            .fill(Color.cyan.opacity(0.05))
                            .frame(width: 200, height: 200)
                            .offset(x: geo.size.width - 100, y: -50)
                            .blur(radius: 20)
                    }
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "wallet.pass.fill")
                        .foregroundColor(.cyan)
                    Text("SALDO PENDIENTE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .tracking(1)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(String(format: "$%.2f", viewModel.totalPendingAmount))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.overallStatus.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(viewModel.overallStatus.color.opacity(0.3))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.overallStatus.color.opacity(0.5), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                HStack {
                    Text("Próximo vencimiento")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.nextDueDate)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding(25)
        }
        .frame(height: 200)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
    }
    
    var customSegmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Pendientes", index: 0)
            segmentButton(title: "Historial", index: 1)
        }
        .padding(4)
        .background(Color(hex: "152636"))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    func segmentButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectedTab = index
            }
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(viewModel.selectedTab == index ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        if viewModel.selectedTab == index {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1)) // Subtle highlight
                                .matchedGeometryEffect(id: "segment", in: animation)
                        }
                    }
                )
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "152636")) // Darker inner bg
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                
                Image(systemName: transaction.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let due = transaction.dueDate {
                    Text(transaction.formattedDueDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    // For history/reservations, show event date
                    Text(transaction.formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Amount & Status
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.formattedAmount)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(transaction.status.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(transaction.status.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(transaction.status.color.opacity(0.15))
                    .cornerRadius(6)
            }
        }
        .padding(15)
        .background(Color(hex: "152636")) // Card background
        .cornerRadius(20)
    }
    
    var iconColor: Color {
        switch transaction.type {
        case .alicuota: return .cyan
        case .reservation: return .green
        case .fine: return .red
        case .other: return .gray
        }
    }
}

#Preview {
    AccountStatusView()
}
