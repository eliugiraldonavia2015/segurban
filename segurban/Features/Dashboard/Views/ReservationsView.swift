//
//  ReservationsView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct ReservationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFacility: String = "Cancha de Tenis"
    @State private var selectedDate: Int = 5
    @State private var selectedStartSlot: Int? = nil
    @State private var selectedEndSlot: Int? = nil
    
    let facilities = ["Piscina", "Cancha de Tenis", "Cancha de Fútbol", "Salón de Eventos", "BBQ"]
    let days = Array(1...31)
    let weekDays = ["D", "L", "M", "M", "J", "V", "S"]
    let timeSlots = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00"]
    // Mock unavailable slots indices
    let unavailableSlots = [1, 5] // 10:00, 14:00 unavailable
    
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
                        
                        // Facility Selector (Dropdown)
                        Menu {
                            ForEach(facilities, id: \.self) { facility in
                                Button(action: { selectedFacility = facility }) {
                                    Text(facility)
                                    if selectedFacility == facility {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedFacility)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "152636"))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
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
                                ForEach(Array(timeSlots.enumerated()), id: \.offset) { index, time in
                                    let isUnavailable = unavailableSlots.contains(index)
                                    let isSelected = isSlotSelected(index)
                                    let isStart = selectedStartSlot == index
                                    let isEnd = selectedEndSlot == index
                                    
                                    Button(action: {
                                        handleSlotSelection(index)
                                    }) {
                                        ZStack(alignment: .topTrailing) {
                                            Text(time)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(isUnavailable ? .gray : (isSelected ? .black : .white))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(backgroundForSlot(index, isUnavailable: isUnavailable))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(isSelected ? Color.cyan : (isUnavailable ? Color.white.opacity(0.05) : Color.white.opacity(0.1)), lineWidth: 1)
                                                        )
                                                )
                                            
                                            if isStart || isEnd {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                                    .background(Circle().fill(Color.black)) // Contrast
                                                    .offset(x: 5, y: -5)
                                            }
                                        }
                                    }
                                    .disabled(isUnavailable)
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
                            Text(formatSelectedTime())
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
        return selectedFacility
    }
    
    func iconForCategory(_ category: String) -> String {
        // Not used anymore but kept for reference or safe removal
        return "square"
    }
    
    // MARK: - Logic
    
    func handleSlotSelection(_ index: Int) {
        withAnimation {
            // Case 1: Start selection
            if selectedStartSlot == nil {
                selectedStartSlot = index
                selectedEndSlot = nil
            }
            // Case 2: Deselect if clicking start again
            else if selectedStartSlot == index && selectedEndSlot == nil {
                selectedStartSlot = nil
            }
            // Case 3: Selecting end slot
            else if let start = selectedStartSlot, selectedEndSlot == nil {
                if index == start {
                    // Clicking start again when end is nil -> deselect
                    selectedStartSlot = nil
                } else if index == start + 1 {
                    // Valid next slot (2 hours max)
                    selectedEndSlot = index
                } else if index == start - 1 {
                    // Clicked previous slot, swap
                    selectedEndSlot = start
                    selectedStartSlot = index
                } else {
                    // Clicked far away, reset to new start
                    selectedStartSlot = index
                    selectedEndSlot = nil
                }
            }
            // Case 4: Range already selected, reset to new start
            else {
                selectedStartSlot = index
                selectedEndSlot = nil
            }
        }
    }
    
    func isSlotSelected(_ index: Int) -> Bool {
        if let start = selectedStartSlot {
            if let end = selectedEndSlot {
                return index >= start && index <= end
            }
            return index == start
        }
        return false
    }
    
    func backgroundForSlot(_ index: Int, isUnavailable: Bool) -> Color {
        if isUnavailable {
            return Color(hex: "0D1B2A").opacity(0.5)
        }
        if isSlotSelected(index) {
            if let start = selectedStartSlot, let end = selectedEndSlot {
                if index > start && index < end {
                    return Color.cyan.opacity(0.3) // Middle of range (if range > 2, but max is 2 so irrelevant here but good practice)
                }
            }
            return Color.cyan
        }
        return Color(hex: "152636")
    }
    
    func formatSelectedTime() -> String {
        guard let start = selectedStartSlot else { return "Seleccionar hora" }
        let startTime = timeSlots[start]
        
        if let end = selectedEndSlot {
            // End time is the slot time + 1 hour usually, or just the slot label
            // Let's assume the slot label is the start of that hour.
            // So if range is 11:00 (start) - 12:00 (end selected), booking is 11:00 - 13:00?
            // User said "choose max 2 hours", logic: selecting 2 consecutive slots = 2 hours.
            // e.g. Select 11:00 and 12:00 -> 11:00 to 13:00.
            
            // Logic to get end time string (end slot + 1 hour)
            // Simple approach: show range "11:00 - 13:00"
            
            let endHour = Int(timeSlots[end].prefix(2))! + 1
            let endTimeString = String(format: "%02d:00", endHour)
            
            return "\(selectedDate) Oct, \(startTime) - \(endTimeString)"
        } else {
            // Single slot (1 hour)
            let startHour = Int(startTime.prefix(2))!
            let endTimeString = String(format: "%02d:00", startHour + 1)
            return "\(selectedDate) Oct, \(startTime) - \(endTimeString)"
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
