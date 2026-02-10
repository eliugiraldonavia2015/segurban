//
//  PaymentMethodView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct PaymentMethodView: View {
    @Environment(\.dismiss) var dismiss
    let amount: Double
    @State private var selectedMethod: String = "Tarjeta"
    
    // Card Fields
    @State private var cardNumber = ""
    @State private var cardHolder = ""
    @State private var cardExpiry = ""
    @State private var cardCVV = ""
    
    // UI States
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    let methods = ["Tarjeta", "Transferencia", "Efectivo"]
    
    var body: some View {
        ZStack {
            Color(hex: "152636").ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Handle
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .padding(.top, 15)
                
                Text("Método de Pago")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Total Amount
                Text(String(format: "$%.2f", amount))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Method Selector
                HStack(spacing: 15) {
                    ForEach(methods, id: \.self) { method in
                        Button(action: {
                            withAnimation {
                                selectedMethod = method
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: iconForMethod(method))
                                    .font(.system(size: 24))
                                Text(method)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(selectedMethod == method ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedMethod == method ? Color.cyan : Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Content based on method
                ScrollView {
                    VStack(spacing: 20) {
                        if selectedMethod == "Tarjeta" {
                            cardView
                                .transition(.move(edge: .leading).combined(with: .opacity))
                        } else if selectedMethod == "Transferencia" {
                            transferView
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        } else {
                            cashView
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding()
                }
                
                // Action Button (Only for Card/Transfer)
                if selectedMethod != "Efectivo" {
                    Button(action: {
                        processPayment()
                    }) {
                        HStack {
                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            } else {
                                Text(selectedMethod == "Tarjeta" ? "Pagar Ahora" : "Subir Comprobante")
                            }
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.cyan)
                        .cornerRadius(20)
                        .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isProcessing)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            
            // Success Overlay
            if showSuccess {
                ZStack {
                    Color.black.opacity(0.8).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .scaleEffect(1.2)
                        
                        Text("¡Pago Exitoso!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Tu pago ha sido procesado correctamente.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("Cerrar") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, 20)
                    }
                    .padding(40)
                    .background(Color(hex: "152636"))
                    .cornerRadius(25)
                    .padding(30)
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
    }
    
    // MARK: - Components
    
    var cardView: some View {
        VStack(spacing: 20) {
            // Card Preview
            CreditCardPreview(cardNumber: cardNumber, cardHolder: cardHolder, cardExpiry: cardExpiry)
                .frame(height: 200)
            
            // Fields
            VStack(spacing: 15) {
                customTextField(icon: "creditcard", placeholder: "Número de Tarjeta", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: cardNumber) { newValue in
                        if newValue.count > 16 { cardNumber = String(newValue.prefix(16)) }
                    }
                
                customTextField(icon: "person.text.rectangle", placeholder: "Nombre del Titular", text: $cardHolder)
                
                HStack(spacing: 15) {
                    customTextField(icon: "calendar", placeholder: "MM/AA", text: $cardExpiry)
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: cardExpiry) { newValue in
                            if newValue.count > 5 { cardExpiry = String(newValue.prefix(5)) }
                        }
                    
                    customTextField(icon: "lock.fill", placeholder: "CVV", text: $cardCVV)
                        .keyboardType(.numberPad)
                        .onChange(of: cardCVV) { newValue in
                            if newValue.count > 3 { cardCVV = String(newValue.prefix(3)) }
                        }
                }
            }
        }
    }
    
    var transferView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Datos Bancarios")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                VStack(spacing: 15) {
                    bankRow(key: "Banco", value: "Banco Pichincha")
                    bankRow(key: "Tipo de Cuenta", value: "Corriente")
                    bankRow(key: "Número", value: "2100458892")
                    bankRow(key: "Titular", value: "ADMINISTRACION SEGURBAN")
                    bankRow(key: "RUC", value: "0991234567001")
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
            }
            
            Button(action: {
                // Simulate upload
            }) {
                VStack(spacing: 10) {
                    Image(systemName: "arrow.up.doc.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.cyan)
                    
                    Text("Subir Comprobante")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("JPG, PNG o PDF")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.cyan.opacity(0.1))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.cyan.opacity(0.5))
                )
            }
        }
    }
    
    var cashView: some View {
        VStack(spacing: 25) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 10) {
                Text("Pago en Administración")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Acércate a la oficina de administración para realizar tu pago en efectivo.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Horarios de Atención")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .tracking(1)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                    Text("Lunes a Viernes")
                        .foregroundColor(.white)
                    Spacer()
                    Text("08:00 - 16:00")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text("Sábados y Domingos")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Cerrado")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    func processPayment() {
        withAnimation {
            isProcessing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isProcessing = false
                showSuccess = true
            }
        }
    }
    
    func iconForMethod(_ method: String) -> String {
        switch method {
        case "Tarjeta": return "creditcard.fill"
        case "Transferencia": return "arrow.left.arrow.right"
        case "Efectivo": return "banknote.fill"
        default: return "circle"
        }
    }
    
    func customTextField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            TextField(placeholder, text: text)
                .foregroundColor(.white)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder).foregroundColor(.gray.opacity(0.5))
                }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    func bankRow(key: String, value: String) -> some View {
        HStack {
            Text(key)
                .foregroundColor(.gray)
                .font(.subheadline)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// Reusing a simplified card preview
struct CreditCardPreview: View {
    var cardNumber: String
    var cardHolder: String
    var cardExpiry: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: [Color(hex: "0D1B2A"), Color.cyan.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "simcard.fill")
                    .font(.title)
                    .foregroundColor(.yellow.opacity(0.8))
                    .rotationEffect(.degrees(90))
                
                Spacer()
                
                Text(cardNumber.isEmpty ? "•••• •••• •••• ••••" : formatCardNumber(cardNumber))
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("TITULAR")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(cardHolder.isEmpty ? "NOMBRE APELLIDO" : cardHolder.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("EXPIRA")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(cardExpiry.isEmpty ? "MM/AA" : cardExpiry)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(25)
        }
    }
    
    func formatCardNumber(_ number: String) -> String {
        let clean = number.replacingOccurrences(of: " ", with: "")
        var result = ""
        for (index, char) in clean.enumerated() {
            if index % 4 == 0 && index > 0 {
                result += " "
            }
            result.append(char)
        }
        return result
    }
}
