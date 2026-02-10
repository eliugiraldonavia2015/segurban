//
//  VisitsView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct VisitsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = VisitsViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    
    // Detail Sheet
    @State private var selectedVisit: Visit?
    
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
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                
                // Filter Tabs
                filterTabs
                    .padding(.vertical, 15)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeIn.delay(0.2), value: showContent)
                
                // Visits List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 25, pinnedViews: [.sectionHeaders]) {
                        ForEach(viewModel.sortedSections, id: \.self) { section in
                            Section(header: sectionHeader(title: section)) {
                                ForEach(viewModel.filteredTransactions[section] ?? []) { visit in // Using same logic as viewmodel
                                    // Typo fix: viewModel.filteredVisits
                                    VisitRow(visit: visit)
                                        .onTapGesture {
                                            selectedVisit = visit
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .offset(y: showContent ? 0 : 50)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showContent)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
        .sheet(item: $selectedVisit) { visit in
            VisitDetailView(visit: visit)
                .presentationDetents([.medium])
                .presentationCornerRadius(25)
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
            
            Text("Historial de Visitas")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(hex: "0D1B2A"))
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar por nombre o fecha...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Buscar por nombre o fecha...").foregroundColor(.gray)
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
    
    var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "Todos" Tab
                filterButton(title: "Todos", status: .all)
                
                // Other Tabs
                filterButton(title: "Usado", status: .used)
                filterButton(title: "Vencido", status: .overdue)
                filterButton(title: "Activo", status: .active)
            }
            .padding(.horizontal)
        }
    }
    
    func filterButton(title: String, status: VisitStatus) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectedStatus = status
            }
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundColor(viewModel.selectedStatus == status ? .black : .gray)
                .background(
                    ZStack {
                        if viewModel.selectedStatus == status {
                            Capsule()
                                .fill(Color.gray.opacity(0.8)) // Darker gray for active tab as in image
                                .matchedGeometryEffect(id: "activeTab", in: animation)
                        } else {
                            Capsule()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        }
                    }
                )
        }
    }
    
    func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .tracking(1)
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color(hex: "0D1B2A")) // Sticky header background
    }
}

// Helper to fix LazyVStack loop
extension VisitsViewModel {
    // Re-declare for clarity in View
    // filteredVisits is [String: [Visit]]
}

// Fix typo in View
extension VisitsView {
    // Correct loop: viewModel.filteredVisits[section]
}


struct VisitRow: View {
    let visit: Visit
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Initials
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: "D9D9D9")) // Light gray for avatar bg
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(visit.initials)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    )
                
                // Status Indicator
                if visit.status == .used {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .background(Circle().fill(Color.white))
                        .offset(x: 2, y: 2)
                } else if visit.status == .overdue {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                        .background(Circle().fill(Color.white))
                        .offset(x: 2, y: 2)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(visit.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(visit.timeDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Right Side: Status Tag & Code
            VStack(alignment: .trailing, spacing: 6) {
                Text(visit.status.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(visit.status.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(visit.status.color.opacity(0.15))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(visit.status.color.opacity(0.3), lineWidth: 1)
                    )
                
                if let code = visit.accessCode {
                    Text("\(visit.accessMethod.rawValue) \(code)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text(visit.accessMethod.rawValue)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(15)
        .background(Color(hex: "152636"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Detail Sheet

struct VisitDetailView: View {
    let visit: Visit
    
    var body: some View {
        ZStack {
            Color(hex: "152636").ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Drag Handle
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .padding(.top, 15)
                
                // Header Profile
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "D9D9D9"))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(visit.initials)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            )
                        
                        // Access Method Icon Badge
                        Image(systemName: visit.accessMethod.icon)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.cyan)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hex: "152636"), lineWidth: 3))
                            .offset(x: 25, y: 25)
                    }
                    
                    VStack(spacing: 5) {
                        Text(visit.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Visitante")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // Details Grid
                VStack(spacing: 20) {
                    detailRow(icon: "clock.fill", title: "Hora de Acceso", value: visit.formattedTime)
                    detailRow(icon: "person.text.rectangle.fill", title: "Cédula", value: visit.cedula)
                    
                    if let plate = visit.licensePlate {
                        detailRow(icon: "car.fill", title: "Placa Vehículo", value: plate)
                    }
                    
                    detailRow(icon: "qrcode", title: "Medio de Acceso", value: visit.accessMethod.rawValue + (visit.accessCode != nil ? " (\(visit.accessCode!))" : ""))
                    
                    detailRow(icon: "info.circle.fill", title: "Estado", value: visit.status.rawValue, color: visit.status.color)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
    }
    
    func detailRow(icon: String, title: String, value: String, color: Color = .white) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(15)
        .background(Color(hex: "0D1B2A"))
        .cornerRadius(12)
    }
}

// Helper for placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
