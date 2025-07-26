//
//  OnboardingView.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Onboarding View
struct OnboardingView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let slides = OnboardingSlide.slides
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appBackground,
                    Color.appBackground.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    if currentPage < slides.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                userPreferences.completeOnboarding()
                            }
                        }
                        .foregroundColor(.appSecondaryText)
                        .padding()
                    }
                }
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        OnboardingSlideView(
                            slide: slides[index],
                            isAnimating: isAnimating && currentPage == index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.6), value: currentPage)
                
                // Bottom Controls
                VStack(spacing: 20) {
                    // Page Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? slides[currentPage].accentColor : Color.white.opacity(0.3))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        // Previous Button
                        if currentPage > 0 {
                            Button(action: previousPage) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Previous")
                                }
                                .foregroundColor(.appSecondaryText)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        Spacer()
                        
                        // Next/Get Started Button
                        Button(action: nextPageOrComplete) {
                            HStack {
                                Text(currentPage == slides.count - 1 ? "Get Started" : "Next")
                                if currentPage < slides.count - 1 {
                                    Image(systemName: "chevron.right")
                                } else {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(slides[currentPage].accentColor)
                                    .shadow(color: slides[currentPage].accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                        }
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: currentPage) { _ in
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.8).delay(0.5)) {
            isAnimating = true
        }
    }
    
    private func previousPage() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentPage > 0 {
                currentPage -= 1
                isAnimating = false
            }
        }
    }
    
    private func nextPageOrComplete() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentPage < slides.count - 1 {
                currentPage += 1
                isAnimating = false
            } else {
                userPreferences.completeOnboarding()
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(UserPreferences())
} 