//
//  AdminCreateNoticeView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminCreateNoticeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminCreateNoticeViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // Image Picker Section
                        imageUploadSection
                            .offset(y: showContent ? 0 : 20)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        
                        // Main Form
                        VStack(spacing: 20) {
                            
                            // Title
                            customTextField(title: "Título del Aviso", placeholder: "Ej. Mantenimiento Piscina", text: $viewModel.title, icon: "textformat")
                                .offset(y: showContent ? 0 : 30)
                                .opacity(showContent ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                            
                            // Category & Urgency
                            HStack(spacing: 15) {
                                categoryPicker
                                urgencyToggle
                            }
                            .offset(y: showContent ? 0 : 40)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                            
                            // Description
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Descripción")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .tracking(1)
                                
                                ZStack(alignment: .topLeading) {
                                    if viewModel.description.isEmpty {
                                        Text("Escribe los detalles aquí...")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .padding(12)
                                    }
                                    
                                    TextEditor(text: $viewModel.description)
                                        .frame(height: 120)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                        .foregroundColor(.white)
                                        .padding(4)
                                }
                                .background(Color(hex: "152636"))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                )
                            }
                            .offset(y: showContent ? 0 : 50)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                            
                            // Scheduling
                            scheduleSection
                                .offset(y: showContent ? 0 : 60)
                                .opacity(showContent ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showContent)
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            
            // Bottom Action Bar
            VStack {
                Spacer()
                
                Button(action: viewModel.createNotice) {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Image(systemName: viewModel.isScheduled ? "calendar.badge.plus" : "paperplane.fill")
                            Text(viewModel.isScheduled ? "Programar Aviso" : "Publicar Ahora")
                        }
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .cyan.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .disabled(!viewModel.isValid || viewModel.isSubmitting)
                .opacity(!viewModel.isValid ? 0.5 : 1)
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "0D1B2A").opacity(0), Color(hex: "0D1B2A")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .offset(y: showContent ? 0 : 100)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showContent)
            }
            
            // Success Overlay
            if viewModel.showSuccess {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .scaleEffect(viewModel.showSuccess ? 1 : 0.5)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.showSuccess)
                        
                        Text("¡Aviso Publicado!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(40)
                    .background(Color(hex: "152636"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Crear Nuevo Aviso")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding()
    }
    
    var imageUploadSection: some View {
        Button(action: {
            // Image Picker logic
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "152636"))
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(Color.cyan.opacity(0.5))
                    )
                
                VStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.cyan)
                    
                    Text("Subir Foto o Cover")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func customTextField(title: String, placeholder: String, text: Binding<String>, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .tracking(1)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                
                TextField(placeholder, text: text)
                    .foregroundColor(.white)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder).foregroundColor(.gray.opacity(0.5))
                    }
            }
            .padding()
            .background(Color(hex: "152636"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
    
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Categoría")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .tracking(1)
            
            Menu {
                ForEach(NoticeCategory.allCases, id: \.self) { category in
                    if category != .all { // Don't allow 'All' for creation
                        Button(action: { viewModel.selectedCategory = category }) {
                            Label(category.rawValue, systemImage: "tag")
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCategory.rawValue)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding()
                .background(Color(hex: "152636"))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
            }
        }
    }
    
    var urgencyToggle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prioridad")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .tracking(1)
            
            Button(action: {
                withAnimation {
                    viewModel.isUrgent.toggle()
                }
            }) {
                HStack {
                    Image(systemName: viewModel.isUrgent ? "exclamationmark.triangle.fill" : "exclamationmark.triangle")
                        .foregroundColor(viewModel.isUrgent ? .red : .gray)
                    
                    Text(viewModel.isUrgent ? "Urgente" : "Normal")
                        .foregroundColor(viewModel.isUrgent ? .red : .white)
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: "152636"))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(viewModel.isUrgent ? Color.red.opacity(0.5) : Color.white.opacity(0.05), lineWidth: 1)
                )
            }
        }
    }
    
    var scheduleSection: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $viewModel.isScheduled.animation()) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.purple)
                    VStack(alignment: .leading) {
                        Text("Programar Publicación")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("El aviso se enviará automáticamente")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: .purple))
            
            if viewModel.isScheduled {
                Divider().background(Color.white.opacity(0.1))
                
                DatePicker("", selection: $viewModel.scheduledDate, in: Date()...)
                    .datePickerStyle(.graphical)
                    .colorScheme(.dark)
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color(hex: "152636"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
