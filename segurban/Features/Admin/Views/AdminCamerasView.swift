//
//  AdminCamerasView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct AdminCamerasView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AdminCamerasViewModel()
    @State private var showContent = false
    
    // Grid Layout
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Status Summary
                        HStack {
                            Label("7 Cámaras Activas", systemImage: "video.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            
                            Label("1 Offline", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring().delay(0.1), value: showContent)
                        
                        // Grid
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.cameras) { camera in
                                CameraFeedCard(camera: camera)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                    }
                    .padding(.top, 10)
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
            
            Text("Monitoreo de Cámaras")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Layout toggle placeholder
            Button(action: {}) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                    .padding(10)
            }
        }
        .padding()
    }
}

struct CameraFeedCard: View {
    let camera: CameraModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Video Feed Placeholder
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 120)
                
                // Static Noise / Gradient Effect
                LinearGradient(
                    colors: [Color(hex: "152636"), Color.black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Icon representation
                Image(systemName: camera.placeholderIcon)
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.1))
                
                // Live Indicator
                if camera.isLive {
                    VStack {
                        HStack {
                            Spacer()
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 6, height: 6)
                                Text("LIVE")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(4)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(4)
                        }
                        Spacer()
                    }
                    .padding(8)
                } else {
                    VStack {
                        Image(systemName: "wifi.slash")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                        Text("No Signal")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .clipped()
            
            // Info Footer
            VStack(alignment: .leading, spacing: 4) {
                Text(camera.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Text(camera.location)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Circle()
                        .fill(camera.isLive ? Color.green : Color.red)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(12)
            .background(Color(hex: "152636"))
        }
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
