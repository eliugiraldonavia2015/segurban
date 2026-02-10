//
//  AdminSearchVillaView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminSearchVillaView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminSearchVillaViewModel()
    @State private var showContent = false
    @State private var selectedVilla: VillaModel? = nil
    
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
                
                // List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.filteredVillas) { villa in
                            VillaRow(villa: villa)
                                .onTapGesture {
                                    selectedVilla = villa
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
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
        .sheet(item: $selectedVilla) { villa in
            VillaDetailView(villa: villa)
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
            
            Text("Buscar Villa")
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
            
            TextField("Manzana, Villa o Residente...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Manzana, Villa o Residente...").foregroundColor(.gray)
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

struct VillaRow: View {
    let villa: VillaModel
    
    var primaryResident: ResidentDetail? {
        villa.residents.first(where: { $0.isPrimary }) ?? villa.residents.first
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.cyan.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "house.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.cyan)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(villa.manzana)-\(villa.villa)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let resident = primaryResident {
                    Text(resident.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
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

// MARK: - Detail View

struct VillaDetailView: View {
    @Environment(\.dismiss) var dismiss
    let villa: VillaModel
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Sheet Header
                HStack {
                    Spacer()
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // Hero
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.cyan.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "house.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.cyan)
                            }
                            
                            Text("\(villa.manzana)-\(villa.villa)")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(villa.residents.count) Residentes")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        
                        // Residents Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Residentes")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(villa.residents) { resident in
                                ResidentDetailRow(resident: resident)
                            }
                        }
                        .padding()
                        .background(Color(hex: "152636"))
                        .cornerRadius(20)
                        
                        // Vehicles Section
                        if !villa.vehicles.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Vehículos Registrados")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(villa.vehicles, id: \.self) { vehicle in
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundColor(.cyan)
                                        Text(vehicle)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .padding(.vertical, 5)
                                    
                                    if vehicle != villa.vehicles.last {
                                        Divider().background(Color.white.opacity(0.1))
                                    }
                                }
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(20)
                        }
                        
                        // Pets Section
                        if !villa.pets.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Mascotas")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(villa.pets, id: \.self) { pet in
                                    HStack {
                                        Image(systemName: "pawprint.fill")
                                            .foregroundColor(.orange)
                                        Text(pet)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .padding(.vertical, 5)
                                    
                                    if pet != villa.pets.last {
                                        Divider().background(Color.white.opacity(0.1))
                                    }
                                }
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(20)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ResidentDetailRow: View {
    let resident: ResidentDetail
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Circle()
                    .fill(resident.isPrimary ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(String(resident.name.prefix(1)))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(resident.isPrimary ? .cyan : .white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(resident.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if resident.isPrimary {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(resident.role)
                    .font(.caption)
                    .foregroundColor(.cyan)
                
                // Contact Info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 5) {
                        Image(systemName: "phone.fill")
                            .font(.caption2)
                        Text(resident.phone)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "envelope.fill")
                            .font(.caption2)
                        Text(resident.email)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
                .padding(.top, 4)
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 10) {
                Button(action: {}) {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                }
                
                Button(action: {}) {
                    Image(systemName: "message.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
