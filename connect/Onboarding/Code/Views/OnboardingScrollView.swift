//
//  OnboardingScrollView.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import SwiftUI

struct OnboardingScrollView: View {
    
    // MARK:- variables
    @EnvironmentObject var appModel: AuthModel
    @EnvironmentObject var navigationModel: NavigationModel

    @Binding var backgroundColor: Color
    
    @State var viewAppeared = false
    @State var nextButtonScale: CGFloat = 0
    @State var viewOffset: CGFloat = 0
    
    let appWidth: CGFloat = UIScreen.main.bounds.width
    
    let detectDirectionalDrags = DragGesture(minimumDistance: 0, coordinateSpace: .local)
    
    // MARK:- views
    var body: some View {
        VStack {
            HStack {
                
                if (appModel.currentStep < 2) {
                    Button(action: {
                        navigationModel.path.append("login")
                    }) {
                        Text("Skip")
                            .foregroundColor(.black)
                            .opacity(0.7)
                            .font(.title3)
                            .scaleEffect(self.viewAppeared ? 1 : 0)
                            .animation(.default)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            GeometryReader { geo in
                HStack(spacing : 0) {
                    ForEach(Array(zip(appModel.onboardingData.indices, appModel.onboardingData)), id: \.0) {(ix, onboardingData) in
                        OnboardingPage(selectedIndex: $appModel.currentStep, authModel: appModel, onboardingData: onboardingData, step: ix)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }.offset(x: viewOffset)
            }
            Spacer()
            HStack {
                if (appModel.currentStep >= 1) {
                    Button(action: {
                        backwardPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.black)
                            .font(.system(size: 22, weight: .medium))
                            .opacity(0.4)
                    }
                    .frame(width: 44, height: 44)
                }
                Spacer()
                NextButton(background: $backgroundColor)
                    .environmentObject(appModel)
                    .onTapGesture {
                        forwardPage()
                    }
                    .scaleEffect(nextButtonScale)
            }
            .padding(.horizontal)
            
            
        }
        .onAppear() {
            self.viewAppeared = true
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                nextButtonScale = 0.9
            }
        }
    }
    
    // MARK:- functions
    func forwardPage() {
        if (!appModel.animationInProgress) {
            self.appModel.forward = true
            self.appModel.animationInProgress = true
            appModel.previousColor = appModel.onboardingData[appModel.currentStep].associatedColor
            
            if (appModel.currentStep + 1  <= appModel.onboardingData.count - 1) {
                appModel.currentStep += 1
            } else if appModel.currentStep == 2 {
                navigationModel.path.append("login")
            } else {
                appModel.currentStep = appModel.onboardingData.count - 1
            }
            
            self.backgroundColor = appModel.onboardingData[appModel.currentStep].associatedColor
            
            animateColor()
            
            self.appModel.addStep()
            withAnimation(Animation.spring(response: appModel.animationDuration)) {
                    self.viewOffset = -appWidth * CGFloat(appModel.currentStep)
            }
        }
    }
    
    func backwardPage() {
        if (!appModel.animationInProgress) {
            self.appModel.animationInProgress = true
            self.appModel.forward = false
            appModel.previousColor = appModel.onboardingData[appModel.currentStep].associatedColor
            appModel.removeStep(step: appModel.currentStep)
            
            if (appModel.currentStep - 1  >= 0) {
                appModel.currentStep -= 1
            } else {
                appModel.currentStep = 0
            }
            self.backgroundColor = appModel.onboardingData[appModel.currentStep].associatedColor
            animateColor()

            withAnimation(Animation.spring(response: appModel.animationDuration)) {
                if (appModel.currentStep == 1) {
                    self.viewOffset = -appWidth
                } else {
                    self.viewOffset = 0
                }
            }
        }
    }
    
    
    func animateColor() {
        appModel.scale = 0
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation(Animation.spring(response: appModel.animationDuration).speed(0.65)) {
                appModel.scale = 8.5
            }
        }
    }
}
struct OnboardingScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            OnboardingScrollView(backgroundColor: .constant(.yellow))
                .environmentObject(AuthModel())
        }
    }
}
