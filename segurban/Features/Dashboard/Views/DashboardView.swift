//
//  DashboardView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var showPanicAlert = false
    @State private var showGenerateAccess = false
    @State private var showReservations = false
    @State private var showNotices = false
    @State private var showPayments = false
    @State private var showVisits = false
    @State private var showPackages = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    headerView
                    
                    // Quick Access - QR
                    qrAccessCard
                    
                    // Status Cards
                    HStack(spacing: 15) {
                        Button(action: { showPayments = true }) {
                            statusCard(
                                icon: "dollarsign.circle.fill",
                                title: "Saldo a Pagar",
                                value: "$1,250.00",
                                status: "PENDIENTE",
                                color: .red
                            )
                        }
                        
                        statusCard(
                            icon: "sun.max.fill",
                            title: "Clima en SEGURBAN",
                            value: "28°C",
                            status: "Soleado",
                            color: .yellow
                        )
                    }
                    
                    // Services Grid
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Servicios")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            Button(action: { showReservations = true }) {
                                serviceButton(icon: "calendar", title: "Reservas")
                            }
                            Button(action: { showVisits = true }) {
                                serviceButton(icon: "person.2.fill", title: "Visitas")
                            }
                            Button(action: { showPackages = true }) {
                                serviceButton(icon: "shippingbox.fill", title: "Paquetes")
                            }
                            serviceButton(icon: "doc.text.fill", title: "Pagos")
                        }
                    }
                    
                    // Announcements
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Tablón de Anuncios")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button("Ver todo") { showNotices = true }
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                announcementCard(
                                    image: "pool_image", // Placeholder
                                    tag: "MANTENIMIENTO",
                                    title: "Cierre temporal de piscina",
                                    desc: "Debido a trabajos de limpieza profunda, la piscina estará cerrada este martes..."
                                )
                                
                                announcementCard(
                                    image: "meeting_image",
                                    tag: "COMUNIDAD",
                                    title: "Reunión Anual",
                                    desc: "La asamblea de residentes será el próximo viernes a las 19:00..."
                                )
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Panic Button
                    panicButton
                        .padding(.bottom, 5)
                    
                    // Logout Button
                    Button(action: {
                        withAnimation {
                            viewModel.isAuthenticated = false
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 16, weight: .bold))
                            Text("Cerrar Sesión")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(15)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showGenerateAccess) {
            GenerateAccessView()
        }
        .fullScreenCover(isPresented: $showReservations) {
            ReservationsView()
        }
        .fullScreenCover(isPresented: $showNotices) {
            NoticeBoardView()
        }
        .fullScreenCover(isPresented: $showPayments) {
            AccountStatusView()
        }
        .fullScreenCover(isPresented: $showVisits) {
            VisitsView()
        }
        .fullScreenCover(isPresented: $showPackages) {
            PackageRegistrationView()
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://i.pravatar.cc/150?img=11")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bienvenido a casa")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Hola, Residente")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.1)))
            }
        }
    }
    
    var qrAccessCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Acceso Rápido")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Genera tu QR para entrar.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "qrcode")
                    .font(.system(size: 30))
                    .foregroundColor(.cyan)
            }
            
            HStack(spacing: 10) {
                Button(action: { showGenerateAccess = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Generar Código")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.cyan)
                    .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(Color(hex: "152636")) // Slightly lighter card bg
        .cornerRadius(20)
    }
    
    func statusCard(icon: String, title: String, value: String, status: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .padding(8)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            if !status.isEmpty {
                Text(status)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(hex: "152636"))
        .cornerRadius(20)
    }
    
    func serviceButton(icon: String, title: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.cyan)
                .frame(width: 60, height: 60)
                .background(Color(hex: "152636"))
                .cornerRadius(15)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    func announcementCard(image: String, tag: String, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Placeholder Image
            AsyncImage(url: URL(string: "https://picsum.photos/400/200")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    )
            }
            .frame(height: 120)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(tag)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(15)
        }
        .frame(width: 280)
        .background(Color(hex: "152636"))
        .cornerRadius(20)
    }
    
    var panicButton: some View {
        Button(action: { showPanicAlert.toggle() }) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 40, height: 40)
                        .shadow(color: .red.opacity(0.5), radius: 10)
                    
                    Text("SOS")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Botón de Pánico")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Mantén presionado para alertar")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(hex: "1E1E1E")) // Darker specific bg for contrast
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    DashboardView()
}
