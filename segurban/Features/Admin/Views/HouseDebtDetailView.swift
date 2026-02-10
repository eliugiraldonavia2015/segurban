//
//  HouseDebtDetailView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct HouseDebtDetailView: View {
    @Environment(\.dismiss) var dismiss
    let house: HouseDebtModel
    
    // Animation
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Detalle de Cuenta")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // Hero Section
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(house.status.color.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Text("\(house.manzana)-\(house.villa)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(house.status.color)
                            }
                            
                            Text(house.ownerName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(house.status.rawValue.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(house.status.color)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(house.status.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.top, 10)
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                        
                        // Total Debt Card
                        VStack(spacing: 5) {
                            Text("Total a Pagar")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("$\(String(format: "%.2f", house.totalDebt))")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(house.totalDebt > 0 ? .red : .green)
                            
                            if house.totalDebt == 0 {
                                Text("¡Excelente! No hay deudas pendientes.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "152636"))
                        .cornerRadius(20)
                        .offset(y: showContent ? 0 : 30)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring().delay(0.1), value: showContent)
                        
                        // Pending Items
                        if house.totalDebt > 0 {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Desglose de Deuda")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                // Maintenance Fees
                                if house.pendingMaintenanceMonths > 0 {
                                    debtSection(title: "Alícuotas Pendientes", icon: "house.fill", count: house.pendingMaintenanceMonths, amount: Double(house.pendingMaintenanceMonths) * 50.0) // Mock amount logic
                                }
                                
                                // Reservations
                                if house.pendingReservations > 0 {
                                    debtSection(title: "Reservas sin Pagar", icon: "calendar", count: house.pendingReservations, amount: Double(house.pendingReservations) * 25.0) // Mock amount logic
                                }
                            }
                            .offset(y: showContent ? 0 : 40)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring().delay(0.2), value: showContent)
                        }
                        
                        // History / Last Payment
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Última Actividad")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                VStack(alignment: .leading) {
                                    Text("Pago Confirmado")
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                    Text(house.lastPaymentDate)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("Ver Recibo")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(15)
                        }
                        .offset(y: showContent ? 0 : 50)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring().delay(0.3), value: showContent)
                        
                    }
                    .padding()
                }
                
                // Bottom Actions
                if house.totalDebt > 0 {
                    HStack(spacing: 15) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "bell.fill")
                                Text("Recordar")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(15)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                Text("Registrar Pago")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                    .background(Color(hex: "152636"))
                    .offset(y: showContent ? 0 : 100)
                    .animation(.spring().delay(0.4), value: showContent)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    func debtSection(title: String, icon: String, count: Int, amount: Double) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.cyan)
                .frame(width: 50, height: 50)
                .background(Color.cyan.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(count) items pendientes")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", amount))")
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(15)
    }
}
