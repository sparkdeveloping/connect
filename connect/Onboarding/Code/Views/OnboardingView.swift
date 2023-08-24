//
//  OnboardingView.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK:- variables
    @StateObject var appModel: AuthModel = AuthModel()
    @State var background: Color
    @State var viewAppeared = false
    @EnvironmentObject var navigationModel: NavigationModel

    
    // MARK:- views
    var body: some View {
        ZStack {
            appModel.previousColor
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                ZStack {
                    /// left
                    if (!appModel.forward) {
                        Circle()
                            .scale(appModel.scale)
                            .foregroundColor(background)
                            .frame(width: 200, height: 200)
                            .offset(x: 12, y: height * 0.775)
                    }
                    /// right
                    if (appModel.forward) {
                        ZStack {
                        Circle()
                            .scale(appModel.scale)
                            .foregroundColor(background)
                            .frame(width: 200, height: 200)
                         
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .foregroundColor(.white.opacity(0.5))
                            .blur(radius:6)
                            .frame(width: 200, height: 200)
                            .scaleEffect(appModel.scale)
                            .animation(Animation.easeInOut(duration: 0.2).delay(0.2))
                        }
                            .offset(x: width * 0.6, y: height * 0.775)
                        
                    }
                }
            }
            OnboardingScrollView(backgroundColor: $background)
                .environmentObject(appModel)
            
        }.onAppear() {
            self.background = self.appModel.previousColor
            self.viewAppeared = true
        }
    }
}
