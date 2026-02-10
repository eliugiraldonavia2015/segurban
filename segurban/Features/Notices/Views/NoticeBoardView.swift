//
//  NoticeBoardView.swift
//  segurban
//
//  Created by Trae on 8/2/26.
//

import SwiftUI

struct NoticeBoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NoticeBoardViewModel()
    @Namespace private var animation
    
    // Animation States
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(hex: "0D1B2A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // Categories
                        categoryTabs
                        
                        // Featured Announcement
                        if let featured = viewModel.featuredNotice, viewModel.selectedCategory == .all || viewModel.selectedCategory == featured.category {
                            featuredCard(notice: featured)
                                .offset(y: showContent ? 0 : 30)
                                .opacity(showContent ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        }
                        
                        // Recent Section Header
                        HStack {
                            Text("Recientes")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn.delay(0.2), value: showContent)
                        
                        // Recent List
                        LazyVStack(spacing: 15) {
                            ForEach(Array(viewModel.recentNotices.enumerated()), id: \.element.id) { index, notice in
                                NoticeRow(notice: notice, viewModel: viewModel)
                                    .offset(y: showContent ? 0 : 50)
                                    .opacity(showContent ? 1 : 0)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.7)
                                        .delay(Double(index) * 0.1 + 0.3),
                                        value: showContent
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 10)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Tablón de Anuncios")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Filter action
            }) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.top, 10) // Adjust for safe area if needed
    }
    
    var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NoticeCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedCategory = category
                        }
                    }) {
                        Text(category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .foregroundColor(viewModel.selectedCategory == category ? .black : .gray)
                            .background(
                                ZStack {
                                    if viewModel.selectedCategory == category {
                                        Capsule()
                                            .fill(Color.cyan)
                                            .matchedGeometryEffect(id: "activeTab", in: animation)
                                    } else {
                                        Capsule()
                                            .fill(Color.white.opacity(0.05))
                                    }
                                }
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func featuredCard(notice: Notice) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                // Image
                AsyncImage(url: URL(string: "https://picsum.photos/800/600")) { img in
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                .frame(height: 220)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [
                            Color(hex: "152636").opacity(0.1),
                            Color(hex: "152636").opacity(0.8),
                            Color(hex: "152636")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Badges
                HStack(spacing: 8) {
                    ForEach(notice.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(tag == "URGENTE" ? Color.red : Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .padding(15)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(notice.category.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .tracking(1)
                    Spacer()
                    Text(viewModel.formattedDate(notice.date))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }
                
                Text(notice.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(notice.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {
                    // Open details
                }) {
                    Text("Leer comunicado completo")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.cyan)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(20)
            .background(Color(hex: "152636"))
        }
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

struct NoticeRow: View {
    let notice: Notice
    let viewModel: NoticeBoardViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(notice.iconBackgroundColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: notice.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(notice.iconBackgroundColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notice.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // New indicator
                    if !notice.isRead {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(notice.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text(viewModel.formattedDate(notice.date))
                    Text("•")
                    Text(notice.category.rawValue)
                }
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.top, 2)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(15)
        .background(Color(hex: "152636"))
        .cornerRadius(16)
    }
}

#Preview {
    NoticeBoardView()
}
