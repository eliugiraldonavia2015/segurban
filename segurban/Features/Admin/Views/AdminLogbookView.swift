//
//  AdminLogbookView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminLogbookView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminLogbookViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    
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
                        ForEach(viewModel.filteredEntries) { entry in
                            LogEntryRow(entry: entry)
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
            
            Text("Bitácora de Ingreso")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Filter placeholder
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                    .padding(10)
            }
        }
        .padding()
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar por nombre o casa (ej. 10-3)...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Buscar por nombre o casa (ej. 10-3)...").foregroundColor(.gray)
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

struct LogEntryRow: View {
    let entry: LogEntry
    
    var body: some View {
        HStack(spacing: 15) {
            // Time Column
            VStack(alignment: .center, spacing: 4) {
                Text(entry.timeIn)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
            .frame(width: 60)
            .padding(.trailing, 5)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1)
                    .padding(.vertical, 5),
                alignment: .trailing
            )
            
            // Info Column
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Type Badge
                    Text(entry.type.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(entry.type.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(entry.type.color.opacity(0.2))
                        .cornerRadius(4)
                }
                
                HStack(spacing: 15) {
                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("\(entry.manzana)-\(entry.villa)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                    }
                    
                    // Plate (if any)
                    if let plate = entry.plate {
                        HStack(spacing: 4) {
                            Image(systemName: "car.fill")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(plate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
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
