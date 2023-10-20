//
//  ContentView.swift
//  SwiftUI Marathon Lesson 8
//
//  Created by Magomet Bekov on 20.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var volumeValue = 0.2
    @State private var offset: CGSize = .zero
    
    let height: CGFloat = 200
    let width: CGFloat = 80
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("wallpaper")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: geo.size.width, minHeight: geo.size.height)
                    .ignoresSafeArea()
                VStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(width: width * xScale, height: height * 1 / xScale)
                        .overlay(alignment: .bottom) {
                            Color.white.background(.thickMaterial)
                                .frame(width: width * xScale, height: height * 1 / xScale * returnCurrentVolume)
                            
                        }
                        .overlay(alignment: .bottom) {
                            Image(systemName: "speaker.wave.3.fill", variableValue: currentVolume)
                                .font(.title)
                                .blendMode(.exclusion)
                                .foregroundStyle(.gray)
                                .padding(.bottom, 20)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 22)
                        )
                        .scaleEffect(x: xScale, y: 1 / xScale)
                        .offset(y: yOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                    
                                }
                                .onEnded { value in
                                    withAnimation {
                                        volumeValue = returnCurrentVolume
                                        offset = .zero
                                    }
                                }
                        )
                }
            }
        }
    }
    
    func changeVolumeValue(_ value: CGFloat, factorOfChanging: CGFloat = 10.0) -> CGFloat {
        if value < 0.0 { return value / factorOfChanging }
        else if value > 1.0 { return CGFloat(1.0) + (value - 1) / factorOfChanging }
        return value
    }
    
    var currentVolume: CGFloat {
        return changeVolumeValue(volumeValue - offset.height / height)
    }
    
    var returnCurrentVolume: CGFloat {
        return min(1.0, max(0.0, currentVolume))
    }
    
    var xScale: CGFloat {
        if currentVolume > 1.0  {
            return 1 / CGFloat(sqrt(Double(currentVolume)))
        } else if currentVolume < 0.0 {
            return 1 / CGFloat(sqrt(Double(1 - currentVolume)))
        } else {
            return 1.0
        }
    }
    
    var yOffset: CGFloat {
        if currentVolume > 1.0 {
            return -height * (1 / xScale - 1.0)
        } else if currentVolume < 0.0 {
            return height * (1 / xScale - 1.0)
        } else {
            return 0.0
        }
    }
}


#Preview {
    ContentView()
}
