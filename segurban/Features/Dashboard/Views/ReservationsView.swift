//
//  ReservationsView.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct ReservationItem: Identifiable {
    let id = UUID()
    let facility: String
    let time: String
    let status: String
}

struct ReservationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFacility: String = "Cancha de Tenis"
    @State private var selectedDate: Int = 5
    @State private var selectedStartSlot: Int? = nil
    @State private var selectedEndSlot: Int? = nil
    
    // Payment & Confirmation
    @State private var showPaymentOptions = false
    @State private var selectedPaymentMethod: String = "Tarjeta"
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var myReservations: [ReservationItem] = [
        ReservationItem(facility: "Cancha de Tenis A", time: "Hoy, 18:00 - 19:00", status: "ACTIVA")
    ]
    
    let facilities = ["Piscina", "Cancha de Tenis", "Cancha de Fútbol", "Salón de Eventos", "BBQ"]
    let days = Array(1...31)
    let weekDays = ["D", "L", "M", "M", "J", "V", "S"]
    
    // 07:00 to 22:00 (30 min intervals)
    let timeSlots = [
        "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
        "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
        "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30",
        "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00"
    ]
    
    // Mock unavailable slots indices (consecutive)
    let unavailableSlots = [8, 9] // 11:00, 11:30 unavailable
    
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
                            
                            if myReservations.isEmpty {
                                Text("No tienes reservas activas")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 10)
                            } else {
                                ForEach(myReservations) { reservation in
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
                                            Text(reservation.facility)
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            Text(reservation.time)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(reservation.status)
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
                            }
                        }
                        
                        Spacer(minLength: 150) // Space for bottom sheet
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
                    
                    if showPaymentOptions {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("⚠️ Horario Nocturno: $20.00/hr por iluminación")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            
                            Text("Método de Pago")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 10) {
                                ForEach(["Tarjeta", "Transferencia", "Deuda"], id: \.self) { method in
                                    Button(action: { selectedPaymentMethod = method }) {
                                        Text(method)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(selectedPaymentMethod == method ? .black : .white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedPaymentMethod == method ? Color.cyan : Color.white.opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    Button(action: { confirmReservation() }) {
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
            
            // Success Overlay
            if showSuccess {
                ZStack {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .scaleEffect(showSuccess ? 1.0 : 0.5)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showSuccess)
                        
                        Text("¡Reserva Confirmada!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Tu reserva ha sido añadida exitosamente.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                    .background(Color(hex: "152636"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .padding(40)
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Aviso"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
    
    func checkPaymentRequirement() {
        showPaymentOptions = false
        if let start = selectedStartSlot, let end = selectedEndSlot {
            // Check if any selected slot is >= 17:00
            // 17:00 index in our array is 20
            if start >= 20 || end >= 20 {
                showPaymentOptions = true
            }
        } else if let start = selectedStartSlot {
             if start >= 20 { showPaymentOptions = true }
        }
    }

    func handleSlotSelection(_ index: Int) {
        withAnimation {
            // Case 1: Start selection
            if selectedStartSlot == nil {
                selectedStartSlot = index
                // Auto select next slot (1 hour total) if available and not blocked
                let nextSlot = index + 1
                if nextSlot < timeSlots.count && !unavailableSlots.contains(nextSlot) {
                    selectedEndSlot = nextSlot
                } else {
                    selectedEndSlot = index
                }
            }
            // Case 2: Extend or Change
            else if let start = selectedStartSlot {
                if index == start {
                    // Click start -> Reset
                    selectedStartSlot = nil
                    selectedEndSlot = nil
                } else if index > start {
                    // Selecting a later slot
                    let count = index - start + 1
                    if count > 4 {
                        errorMessage = "Solo se pueden seleccionar máximo 2 horas por villa"
                        showError = true
                    } else {
                        // Check availability in between
                        var blocked = false
                        for i in start...index {
                            if unavailableSlots.contains(i) { blocked = true }
                        }
                        
                        if blocked {
                            // Reset to new start
                            selectedStartSlot = index
                            let nextSlot = index + 1
                            if nextSlot < timeSlots.count && !unavailableSlots.contains(nextSlot) {
                                selectedEndSlot = nextSlot
                            } else {
                                selectedEndSlot = index
                            }
                        } else {
                            selectedEndSlot = index
                        }
                    }
                } else {
                    // Clicked before start -> New start
                    selectedStartSlot = index
                    let nextSlot = index + 1
                    if nextSlot < timeSlots.count && !unavailableSlots.contains(nextSlot) {
                        selectedEndSlot = nextSlot
                    } else {
                        selectedEndSlot = index
                    }
                }
            }
        }
        checkPaymentRequirement()
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
        if let start = selectedStartSlot {
            if index == start {
                return Color.cyan
            }
            if let end = selectedEndSlot {
                if index > start && index <= end {
                    return Color.gray.opacity(0.5)
                }
            }
        }
        return Color(hex: "152636")
    }

    func formatSelectedTime() -> String {
        guard let start = selectedStartSlot else { return "Seleccionar hora" }
        let startTime = timeSlots[start]
        
        if let end = selectedEndSlot {
            // End time is the END of the end slot.
            // If slot is 07:00, it ends at 07:30.
            // If slot is 07:30, it ends at 08:00.
            
            let endTimeString: String
            let endSlotTime = timeSlots[end]
            
            // Parse end slot time
            let components = endSlotTime.split(separator: ":")
            if components.count == 2, let h = Int(components[0]), let m = Int(components[1]) {
                var newM = m + 30
                var newH = h
                if newM >= 60 {
                    newM -= 60
                    newH += 1
                }
                endTimeString = String(format: "%02d:%02d", newH, newM)
            } else {
                endTimeString = endSlotTime
            }
            
            return "\(selectedDate) Oct, \(startTime) - \(endTimeString)"
        } else {
            // Single slot (30 min)
             let components = startTime.split(separator: ":")
            if components.count == 2, let h = Int(components[0]), let m = Int(components[1]) {
                var newM = m + 30
                var newH = h
                if newM >= 60 {
                    newM -= 60
                    newH += 1
                }
                let endTimeString = String(format: "%02d:%02d", newH, newM)
                return "\(selectedDate) Oct, \(startTime) - \(endTimeString)"
            }
            return "\(selectedDate) Oct, \(startTime)"
        }
    }
    
    func confirmReservation() {
        guard let start = selectedStartSlot else { return }
        
        // Add to list
        let timeString = formatSelectedTime()
        // Extract just the time part
        let parts = timeString.components(separatedBy: ", ")
        let timeOnly = parts.count > 1 ? parts[1] : timeString
        
        let newReservation = ReservationItem(
            facility: selectedFacility,
            time: "Hoy, \(timeOnly)",
            status: "ACTIVA"
        )
        
        myReservations.append(newReservation)
        
        withAnimation {
            showSuccess = true
        }
        
        // Hide success after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSuccess = false
                dismiss()
            }
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
