//
//  UrbanizationSelector.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct UrbanizationSelector: View {
    @Binding var selection: String
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var filteredOptions: [String] {
        if searchText.isEmpty {
            return AppConstants.urbanizations
        } else {
            return AppConstants.urbanizations.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Urbanización")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "building.2")
                        .foregroundColor(.gray)
                    
                    TextField("Selecciona tu urbanización", text: $searchText, onEditingChanged: { editing in
                        withAnimation {
                            isSearching = editing
                        }
                    })
                    .foregroundColor(.white)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            selection = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSearching ? Color.cyan.opacity(0.5) : Color.clear, lineWidth: 1)
                )
                
                if isSearching {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredOptions, id: \.self) { option in
                                Button(action: {
                                    withAnimation {
                                        selection = option
                                        searchText = option
                                        isSearching = false
                                        hideKeyboard()
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if selection == option {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.cyan)
                                        }
                                    }
                                    .padding()
                                    .background(Color(hex: "0D1B2A")) // Match background to avoid transparency issues
                                }
                                Divider()
                                    .background(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.top, 5)
                    .shadow(radius: 10)
                }
            }
        }
    }
}
