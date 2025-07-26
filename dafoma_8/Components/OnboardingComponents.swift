//
//  OnboardingComponents.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Onboarding Slide View
struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    let isAnimating: Bool
    
    @State private var iconScale: CGFloat = 0.5
    @State private var contentOpacity: Double = 0
    @State private var featuresOffset: CGFloat = 50
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                Spacer(minLength: 40)
                
                // Icon Section
                ZStack {
                    // Background Circle
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    slide.accentColor.opacity(0.3),
                                    slide.accentColor.opacity(0.1)
                                ]),
                                center: .center,
                                startRadius: 30,
                                endRadius: 100
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // Icon
                    Image(systemName: slide.iconName)
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(slide.accentColor)
                        .scaleEffect(iconScale)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: iconScale)
                }
                .padding(.bottom, 20)
                
                // Content Section
                VStack(spacing: 16) {
                    // Title
                    Text(slide.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.appText)
                        .multilineTextAlignment(.center)
                        .opacity(contentOpacity)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: contentOpacity)
                    
                    // Subtitle
                    Text(slide.subtitle)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(slide.accentColor)
                        .multilineTextAlignment(.center)
                        .opacity(contentOpacity)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: contentOpacity)
                    
                    // Description
                    Text(slide.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.appSecondaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .opacity(contentOpacity)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: contentOpacity)
                }
                .padding(.horizontal, 40)
                
                // Features Section
                VStack(spacing: 12) {
                    ForEach(Array(slide.features.enumerated()), id: \.offset) { index, feature in
                        FeatureRow(
                            text: feature,
                            accentColor: slide.accentColor,
                            delay: Double(index) * 0.1
                        )
                        .offset(y: featuresOffset)
                        .opacity(contentOpacity)
                        .animation(.easeOut(duration: 0.6).delay(0.8 + Double(index) * 0.1), value: featuresOffset)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            startAnimations()
        }
        .onChange(of: isAnimating) { animating in
            if animating {
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Reset animations
        iconScale = 0.5
        contentOpacity = 0
        featuresOffset = 50
        
        // Start animations with delays
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1)) {
            iconScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            contentOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
            featuresOffset = 0
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let text: String
    let accentColor: Color
    let delay: Double
    
    @State private var checkmarkScale: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkmark Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 24, height: 24)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(accentColor)
                    .scaleEffect(checkmarkScale)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(delay), value: checkmarkScale)
            }
            
            // Feature Text
            Text(text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.appText)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .onAppear {
            withAnimation {
                checkmarkScale = 1.0
            }
        }
    }
}

// MARK: - Animated Background
struct OnboardingBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appBackground,
                    Color.appBackground.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Floating particles
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.appYellow.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...40))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    OnboardingSlideView(
        slide: OnboardingSlide.slides[0],
        isAnimating: true
    )
    .background(Color.appBackground)
} 