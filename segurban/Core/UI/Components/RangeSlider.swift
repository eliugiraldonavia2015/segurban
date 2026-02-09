//
//  RangeSlider.swift
//  segurban
//
//  Created by eliu giraldo on 8/2/26.
//

import SwiftUI

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    var bounds: ClosedRange<Double> = 0...24
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                
                // Selected Range
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.cyan)
                    .frame(width: width(for: range, in: geometry), height: 4)
                    .offset(x: x(for: range.lowerBound, in: geometry))
                
                // Lower Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.cyan, lineWidth: 2))
                    .offset(x: x(for: range.lowerBound, in: geometry) - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = value(for: value.location.x, in: geometry)
                                if newValue < range.upperBound - 1 {
                                    range = newValue...range.upperBound
                                }
                            }
                    )
                
                // Upper Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.cyan, lineWidth: 2))
                    .offset(x: x(for: range.upperBound, in: geometry) - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = value(for: value.location.x, in: geometry)
                                if newValue > range.lowerBound + 1 {
                                    range = range.lowerBound...newValue
                                }
                            }
                    )
            }
            .frame(height: 20)
        }
        .frame(height: 20)
    }
    
    private func width(for range: ClosedRange<Double>, in geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        let rangeWidth = range.upperBound - range.lowerBound
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        return width * CGFloat(rangeWidth / boundsWidth)
    }
    
    private func x(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        let valueOffset = value - bounds.lowerBound
        return width * CGFloat(valueOffset / boundsWidth)
    }
    
    private func value(for x: CGFloat, in geometry: GeometryProxy) -> Double {
        let width = geometry.size.width
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        let value = Double(x / width) * boundsWidth + bounds.lowerBound
        return min(max(value, bounds.lowerBound), bounds.upperBound)
    }
}
