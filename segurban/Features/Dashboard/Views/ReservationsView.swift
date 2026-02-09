//
//  ReservationsView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct ReservationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: String = "Canchas"
    @State private var selectedDate: Int = 5
    @State private var selectedTime: String = "11:00"
    
    let categories = ["Canchas", "Salón", "Piscina"]
    let days = Array(1...31)
    let weekDays = ["D", "L", "M", "M", "J", "V", "S"]
    let timeSlots = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00"]
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
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
                    Text("Reservar Área")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    // Placeholder for balance
                    Spacer().frame(width: 40)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Category Segmented Control
                        HStack(spacing: 0) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    withAnimation { selectedCategory = category }
                                }) {
                                    HStack {
                                        Image(systemName: iconForCategory(category))
                                        Text(category)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedCategory == category ? Color(hex: "152636") : Color.clear
                                    )
                                    .foregroundColor(
                                        selectedCategory == category ? .cyan : .gray
                                    )
                                }
                            }
                        }
                        .background(Color(hex: "0D1B2A").opacity(0.5)) // Darker background for the bar
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Calendar Card
                        VStack(spacing: 20) {
                            // Month Header
                            HStack {
                                Button(action: {}) { Image(systemName: "chevron.left").foregroundColor(.gray) }
                                Spacer()
                                Text("Octubre 2023")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {}) { Image(systemName: "chevron.right").foregroundColor(.gray) }
                            }
                            
                            // Days Grid
                            VStack(spacing: 15) {
                                // Weekday Headers
                                HStack {
                                    ForEach(weekDays, id: \.self) { day in
                                        Text(day)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                // Days
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                                    // Empty spots for offset (mock)
                                    ForEach(0..<2, id: \.self) { _ in
                                        Text("").frame(maxWidth: .infinity)
                                    }
                                    
                                    ForEach(1...14, id: \.self) { day in
                                        Button(action: {
                                            withAnimation { selectedDate = day }
                                        }) {
                                            Text("\(day)")
                                                .font(.subheadline)
                                                .fontWeight(selectedDate == day ? .bold : .regular)
                                                .foregroundColor(selectedDate == day ? .black : .white)
                                                .frame(width: 35, height: 35)
                                                .background(
                                                    Circle()
                                                        .fill(selectedDate == day ? Color.cyan : Color.clear)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color(hex: "152636"))
                        .cornerRadius(20)
                        
                        // Available Times
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Horarios Disponibles")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(selectedDate) Oct")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.cyan.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                ForEach(timeSlots, id: \.self) { time in
                                    Button(action: {
                                        withAnimation { selectedTime = time }
                                    }) {
                                        ZStack(alignment: .topTrailing) {
                                            Text(time)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(selectedTime == time ? .black : .gray)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(selectedTime == time ? Color.cyan : Color(hex: "152636"))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(selectedTime == time ? Color.cyan : Color.white.opacity(0.1), lineWidth: 1)
                                                        )
                                                )
                                            
                                            if selectedTime == time {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                                    .background(Circle().fill(Color.black)) // Contrast
                                                    .offset(x: 5, y: -5)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // My Reservations Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Mis Reservas")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Button("Ver todas") {}
                                    .font(.subheadline)
                                    .foregroundColor(.cyan)
                            }
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "tennis.racket")
                                        .foregroundColor(.green)
                                        .font(.system(size: 20))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Cancha de Tenis A")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Hoy, 18:00 - 19:00")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("ACTIVA")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(6)
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                            // Green indicator bar on left
                            .overlay(
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 4)
                                    .cornerRadius(2, corners: [.topLeft, .bottomLeft]),
                                alignment: .leading
                            )
                        }
                        
                        Spacer(minLength: 100) // Space for bottom sheet
                    }
                    .padding(.horizontal)
                }
            }
            
            // Bottom Sheet Summary
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("RESUMEN")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .tracking(1)
                            Text(categoryTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("FECHA")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .tracking(1)
                            Text("\(selectedDate) Oct, \(selectedTime)")
                                .font(.headline)
                                .foregroundColor(.cyan)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Confirmar Reserva")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .cornerRadius(15)
                        .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(25)
                .background(
                    Color(hex: "0D1B2A")
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: -5)
                )
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.1)),
                    alignment: .top
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    var categoryTitle: String {
        switch selectedCategory {
        case "Canchas": return "Cancha de Tenis"
        case "Salón": return "Salón de Eventos"
        case "Piscina": return "Piscina Principal"
        default: return "Área Común"
        }
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Canchas": return "sportscourt"
        case "Salón": return "party.popper"
        case "Piscina": return "water.waves"
        default: return "square"
        }
    }
}

// Helper for rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ReservationsView()
}
