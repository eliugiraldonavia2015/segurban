//
//  AdminCollectionView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminCollectionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminCollectionViewModel()
    
    // Animation States
    @State private var showContent = false
    @State private var selectedHouse: HouseDebtModel? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Search & Filter
                VStack(spacing: 15) {
                    searchBar
                    filterTabs
                }
                .padding(.vertical, 10)
                .offset(y: showContent ? 0 : -20)
                .opacity(showContent ? 1 : 0)
                
                // List
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.filteredHouses) { house in
                            HouseDebtCard(house: house)
                                .onTapGesture {
                                    selectedHouse = house
                                }
                                .offset(y: showContent ? 0 : 50)
                                .opacity(showContent ? 1 : 0)
                        }
                    }
                    .padding()
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
        .sheet(item: $selectedHouse) { house in
            HouseDebtDetailView(house: house)
        }
    }
    
    var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Gestión de Cobranza")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for balance
            Button(action: {}) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar Manzana, Villa o Nombre...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Buscar Manzana, Villa o Nombre...").foregroundColor(.gray)
                }
        }
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterButton(title: "Todos", status: nil)
                filterButton(title: "Deuda", status: .overdue)
                filterButton(title: "Pendiente", status: .pending)
                filterButton(title: "Al Día", status: .upToDate)
            }
            .padding(.horizontal)
        }
    }
    
    func filterButton(title: String, status: CollectionStatus?) -> some View {
        Button(action: {
            withAnimation {
                viewModel.selectedStatusFilter = status
            }
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(viewModel.selectedStatusFilter == status ? .black : .white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    viewModel.selectedStatusFilter == status ? Color.cyan : Color.white.opacity(0.1)
                )
                .cornerRadius(20)
        }
    }
}

struct HouseDebtCard: View {
    let house: HouseDebtModel
    
    var body: some View {
        HStack(spacing: 15) {
            // House Icon/Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: "152636"))
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(house.status.color, lineWidth: 2))
                
                Text("\(house.manzana)-\(house.villa)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(house.ownerName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(house.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(house.status.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(house.status.color.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if house.totalDebt > 0 {
                    Text("$\(String(format: "%.2f", house.totalDebt))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                } else {
                    Text("Al día")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                if house.pendingMaintenanceMonths > 0 || house.pendingReservations > 0 {
                    HStack(spacing: 4) {
                        if house.pendingMaintenanceMonths > 0 {
                            Image(systemName: "doc.text.fill")
                            Text("\(house.pendingMaintenanceMonths)")
                        }
                        if house.pendingReservations > 0 {
                            Image(systemName: "calendar")
                            Text("\(house.pendingReservations)")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(hex: "1E1E1E")) // Slightly lighter than bg
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
