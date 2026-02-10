//
//  AdminCommunityView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminCommunityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminCommunityViewModel()
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
                
                // Segmented Control
                customSegmentedControl
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .offset(y: showContent ? 0 : -10)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring().delay(0.1), value: showContent)
                
                // Content List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        if viewModel.selectedTab == 0 {
                            ForEach(viewModel.filteredResidents) { resident in
                                ResidentCard(resident: resident)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                            }
                        } else {
                            ForEach(viewModel.filteredStaff) { staff in
                                StaffCard(staff: staff)
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                    }
                    .padding(.horizontal)
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
            
            Text("Comunidad")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry or extra action
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar por nombre...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Buscar por nombre...").foregroundColor(.gray)
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
    
    var customSegmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Residentes", index: 0)
            segmentButton(title: "Personal", index: 1)
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
                .foregroundColor(viewModel.selectedTab == index ? .black : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        if viewModel.selectedTab == index {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cyan)
                                .matchedGeometryEffect(id: "tab", in: animation)
                        }
                    }
                )
        }
    }
}

// MARK: - Components

struct ResidentCard: View {
    let resident: ResidentModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar
            ZStack {
                Circle()
                    .fill(resident.type.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(String(resident.name.prefix(1)))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(resident.type.color)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(resident.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Text("\(resident.manzana)-\(resident.villa)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text(resident.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Actions
            Button(action: {}) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.cyan)
                    .padding(10)
                    .background(Color.cyan.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

struct StaffCard: View {
    let staff: StaffModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.orange)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(staff.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(staff.role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Status & Actions
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(staff.isAvailable ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(staff.isAvailable ? "Disponible" : "Ocupado")
                        .font(.caption2)
                        .foregroundColor(staff.isAvailable ? .green : .red)
                }
                
                Button(action: {}) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
