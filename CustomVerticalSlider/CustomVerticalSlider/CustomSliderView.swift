//
//  CustomSliderView.swift
//  CustomVerticalSlider
//
//  Created by Kalpesh on 04/04/25.
//



import SwiftUI
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct CustomSliderView :View{

    @Binding var sliderValue:Double

    @State private var internalPosition:Double = 0.5
    @State private var currentPosition:Double  = 0.0
    
    let minValue : Double
    let maxValue : Double
    
    init(sliderValue: Binding<Double>, minValue: Double, maxValue: Double, linearGradient: LinearGradient, callback: ((Double) -> Void)? = nil) {
        self._sliderValue = sliderValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.linearGradient = linearGradient
        self.callback = callback
    }
    
    var linearGradient:LinearGradient
    let padingSpace = 50.0 // verticle pading for Capsule height
    var callback:((Double) -> Void)? = nil
    var body: some View{
        GeometryReader { readerContainer in
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 13.3)
                    .fill(linearGradient)
                    .overlay(
                        VStack(spacing: 0) {
                            GeometryReader(content: { reader in
                                Capsule()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(height: 30)
                                    .frame(maxWidth: .infinity)
                                    .offset(y: CGFloat(currentPosition))
                            })
                        }.padding(.horizontal)
                            .padding(.vertical, 10)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                var newValue = drag.location.y
                                newValue = CGFloat( min(newValue, readerContainer.size.height - padingSpace))
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    currentPosition = CGFloat( max(newValue, 1))
                                }
                            }.onEnded({ _ in
                                let maxPosition = readerContainer.size.height - padingSpace
                                internalPosition = (1 - (currentPosition / maxPosition)).rounded(toPlaces: 2)
                                let submitValue = ((maxValue - minValue) * internalPosition) + minValue
                                self.callback?(submitValue)
                            })
                    )
            }.onAppear {
                internalPosition = sliderValue / (maxValue - minValue) - (minValue / (maxValue - minValue))
                let maxViewHeight = readerContainer.size.height - padingSpace
                currentPosition = (1 - internalPosition) * maxViewHeight
            }
        }
    }
}

