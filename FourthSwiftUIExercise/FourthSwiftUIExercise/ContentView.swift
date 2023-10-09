//
//  ContentView.swift
//  FourthSwiftUIExercise
//
//  Created by Лада Зудова on 08.10.2023.
//

import SwiftUI

struct PressedButton: ButtonStyle {
    
    private var animationDuration = 0.22
    @State private var isPressed = false
    @State private var performAnimation = false
    @State private var isSecond = false
    private let scale: Double
    
    init(scale: Double = 0.86) {
        self.scale = scale
    }
    
    func makeBody(configuration: Configuration) -> some View {
        
        return
            ZStack {
                configuration.label
                HStack(alignment: .center, spacing: -3) {
                    if performAnimation {
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .transition(
                                .scale(scale: performAnimation ? 0 : 1)
                                .combined(with: .opacity)
                                .animation(isSecond ?.easeOut(duration: 0) :
                                        .easeOut(duration: 0.2))
                            )
                    }
                    Image(systemName: "play.fill")
                        .font(.system(size: 30))
                        .transition(
                            .opacity
                                .animation(isSecond ?.easeOut(duration: 0) :
                                        .easeOut(duration: 0.2))
                        )
                    if !performAnimation {
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .transition(
                                .scale(scale: performAnimation ? 1 : 0)
                                .combined(with: .opacity)
                                .animation(.linear(duration: isSecond ? 0 : 0.2))
                            )
                    }
                }
            }
            .padding(20)
            .background(isPressed ? .gray : .red)
            .foregroundColor(.blue)
            .clipShape(Circle())
            .scaleEffect(isPressed ? scale : 1)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    withAnimation(.linear(duration: animationDuration/2)) {
                        isSecond = false
                        isPressed = true
                        performAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + animationDuration/2) {
                        isSecond = true
                        performAnimation = false
                        withAnimation(.linear(duration: animationDuration)) {
                            isPressed = false
                        }
                    }
                }
            }
    }
    
}

struct ContentView: View {
    @State private var showDetail = false
    @State private var isSecond = false
    
    var body: some View {
        HStack {
            VStack {
                Text("Scale до 0")
                Button("") {
                    //
                }
                .padding(50)
                .buttonStyle(PressedButton(scale: 0))
            }
            .frame(maxHeight: 100)
            
            VStack {
                Text("Scale до 0.86")
                Button("") {
                    //
                }
                .padding(50)
                .buttonStyle(PressedButton())
            }
            .frame(maxHeight: 100)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}
