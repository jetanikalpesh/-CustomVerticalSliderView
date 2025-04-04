//
//  ContentView.swift
//  CustomVerticalSlider
//
//  Created by Kalpesh on 04/04/25.
//

import SwiftUI

struct ContentView: View {    
    @State var sliderValue = 5.0
    var body: some View {
        VStack {
            CustomSliderView(sliderValue:  $sliderValue, minValue:5, maxValue:95, linearGradient: .init(colors: [.blue, .yellow], startPoint: .top, endPoint: .bottom))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
