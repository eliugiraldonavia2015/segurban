//
//  AdminVerifyPlateView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminVerifyPlateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminVerifyPlateViewModel()
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                VStack(spacing: 30) {
                    // Search Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingrese la Placa")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(.gray)
                            
                            TextField("Ej. ABC-123", text: $viewModel.searchText)
                                .foregroundColor(.white)
                                .disableAutocorrection(true)
                                .autocapitalization(.allCharacters)
                                .placeholder(when: viewModel.searchText.isEmpty) {
                                    Text("Ej. ABC-123").foregroundColor(.gray)
                                }
                                .onSubmit {
                                    viewModel.searchPlate()
                                }
                            
                            if !viewModel.searchText.isEmpty {
                                Button(action: viewModel.reset) {
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
                        
                        Button(action: viewModel.searchPlate) {
                            HStack {
                                if viewModel.isSearching {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                } else {
                                    Image(systemName: "magnifyingglass")
                                    Text("Buscar Vehículo")
                                }
                            }
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .cornerRadius(15)
                        }
                        .disabled(viewModel.searchText.isEmpty || viewModel.isSearching)
                        .opacity((viewModel.searchText.isEmpty || viewModel.isSearching) ? 0.6 : 1)
                    }
                    .padding()
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                    
                    // Results Area
                    if viewModel.isSearching {
                        Spacer()
                    } else if let result = viewModel.searchResult {
                        ResultCard(result: result)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else if viewModel.hasSearched {
                        VStack(spacing: 15) {
                            Image(systemName: "exclamationmark.magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No se encontró ningún vehículo con esa placa")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
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
            
            Text("Verificar Placa")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
    }
}

struct ResultCard: View {
    let result: VehicleResult
    
    var body: some View {
        VStack(spacing: 20) {
            // Header: Plate & Type
            HStack {
                VStack(alignment: .leading) {
                    Text(result.plate)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Text(result.vehicleModel)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(result.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(result.type.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(result.type.color.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            // Destination
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Destino")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.cyan)
                        Text("\(result.manzana)-\(result.villa)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Hora Entrada")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(result.entryTime)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            // Driver Info (Conditional)
            VStack(alignment: .leading, spacing: 10) {
                Text("Conductor")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(result.driverName)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if let id = result.driverID {
                            Text("C.I. \(id)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            // Entry Method
            HStack {
                Text("Método de Ingreso:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                HStack {
                    Image(systemName: result.entryMethod.icon)
                    Text(result.entryMethod.rawValue)
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
            }
            .padding(.top, 5)
        }
        .padding(25)
        .background(Color(hex: "152636"))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
