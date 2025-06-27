//
//  ContentView.swift
//  OverlayToastExample
//
//  Created by cano on 2025/06/27.
//

import SwiftUI

struct ContentView: View {
    @State private var showToast1: Bool = false
    @State private var showToast2: Bool = false
    @State private var anchor: OverlayToastConfig.OverlayToastAnchor = .top
    var body: some View {
        NavigationStack {
            /// Sample Toasts
            let toast1 = OverlayToastConfig(
                icon: "exclamationmark.circle.fill",
                title: "Incorrect password :(",
                subTitle: "Oops! That didn’t match. Give it another shot.",
                tint: .red,
                anchor: anchor,
                animationAnchor: anchor,
                actionIcon: "xmark"
            ) {
                showToast1 = false
            }
            
            let toast2 = OverlayToastConfig(
                icon: "checkmark.circle.fill",
                title: "Password Reset Email Sent!",
                subTitle: "",
                tint: .green,
                anchor: anchor,
                animationAnchor: anchor,
                actionIcon: "xmark"
            ) {
                showToast2 = false
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {


                    
                    HStack(alignment: .center, spacing: 20) {
                        Text("Error Example")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(.blue.gradient, in: .rect(cornerRadius: 10))
                            .onTapGesture {
                                showToast1.toggle()
                            }
                        
                        Text("Success Example")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(.blue.gradient, in: .rect(cornerRadius: 10))
                            .onTapGesture {
                                showToast2.toggle()
                            }
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Usage")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text(".inlineToast(config, isPresented)")
                            .font(.callout)
                            .monospaced()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Toast Anchor")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Picker("", selection: $anchor) {
                            Text("Top")
                                .tag(OverlayToastConfig.OverlayToastAnchor.top)
                            
                            Text("Bottom")
                                .tag(OverlayToastConfig.OverlayToastAnchor.bottom)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Spacer()
                }
                .textFieldStyle(.roundedBorder)
                .overlayToast(alignment: .center, config: toast1, isPresented: showToast1)
                .overlayToast(alignment: .center, config: toast2, isPresented: showToast2)
                .padding(15)
            }
            .navigationTitle("Overlay Toast Example")
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: showToast1)
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: showToast2)
        }
    }
}


#Preview {
    ContentView()
}
