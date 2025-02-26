//
//  ContentView.swift
//  LionWell real
//
//  Created by Adheera Chilamkurthi on 2/20/25.
//

import SwiftUI


struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("DEBUG: HomeScreen Loaded!")
                    
                    // Header Section
                    ZStack {
                        Color.blue // or Color("4A90E2") if defined
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                        
                        VStack(spacing: 8) {
                            Text("LionWell")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Your AI-Powered Health Journey")
                                .font(.system(size: 16))
                                .foregroundColor(.red.opacity(0.9))
                        }
                    }
                    
                    // Content Section
                    VStack(spacing: 12) {
                        Text("Welcome to Your Health Dashboard")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color.purple)
                            .multilineTextAlignment(.center)
                        
                        Text("We analyze your health data to create custom wellness plans just for you")
                            .font(.system(size: 16))
                            .foregroundColor(Color.green)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.horizontal)
                    }
                    .padding(20)
                    
                    NavigationLink(destination: ResourcesView()) {
                                            Text("Go to Resources")
                                                .font(.headline)
                                                .padding()
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        .padding() // Adjust the padding to suit your layout
                                        
                                        Spacer()
                                    }
                }
                .frame(maxHeight: .infinity) // Ensures the content expands
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    struct HomeScreen_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreen()
        }
    }
    

