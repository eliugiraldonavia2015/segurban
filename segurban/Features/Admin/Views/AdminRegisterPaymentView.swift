//
//  AdminRegisterPaymentView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminRegisterPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminRegisterPaymentViewModel()
    @State private var showContent = false
    
    // Confirmation Dialog
    @State private var selectedDebt: DebtItem? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Search Bar
                searchBar
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .offset(y: showContent ? 0 : -20)
                    .opacity(showContent ? 1 : 0)
                
                if viewModel.filteredDebts.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("No se encontraron deudas pendientes")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: -50)
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.filteredDebts) { debt in
                                DebtRow(debt: debt) {
                                    selectedDebt = debt
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding()
                        .padding(.bottom, 50)
                    }
                    .offset(y: showContent ? 0 : 50)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                }
            }
            
            // Success Overlay
            if viewModel.showSuccessAlert {
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Pago registrado correctamente")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(hex: "152636"))
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.bottom, 50)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: viewModel.showSuccessAlert)
                .zIndex(100)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
        .alert(item: $selectedDebt) { debt in
            Alert(
                title: Text("Registrar Pago"),
                message: Text("¿Confirmas que recibiste el pago de $\(String(format: "%.2f", debt.amount)) por \(debt.concept)?"),
                primaryButton: .default(Text("Confirmar")) {
                    viewModel.registerPayment(for: debt)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
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
            
            Text("Registrar Pago")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Manzana, Villa o Propietario...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Manzana, Villa o Propietario...").foregroundColor(.gray)
                }
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
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

struct DebtRow: View {
    let debt: DebtItem
    let onRegister: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(debt.concept)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(debt.owner)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 6) {
                    Image(systemName: "house.fill")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(debt.manzana)-\(debt.villa)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text("• Vence: \(debt.dueDate)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("$\(String(format: "%.2f", debt.amount))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button(action: onRegister) {
                    Text("Pagar")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding(15)
        .background(Color(hex: "152636"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
