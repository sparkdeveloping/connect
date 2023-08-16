//
//  AppModel.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import SwiftUI

class AppModel: ObservableObject {
    
    // MARK:- variables
    @Published var onboardingData: [OnboardingMetaData] = [
        OnboardingMetaData(imageName: "Students", title: "YAYY!", subtitle: "finally and renound app for just students!", imageOffset: 0, associatedColor: Color(hex: "ffffff")),
        OnboardingMetaData(imageName: "Nearby", title: "Proximity\nChat ", subtitle: "discover hot conversations and chats next to you!", imageOffset: -24, associatedColor: Color(hex: "f2bac9"), imageScale: 1.2),
        OnboardingMetaData(imageName: "Brain", title: "Stay Smart\nHave fun!", subtitle: "lots more to explore, for now, have stay smart & have fun!", imageOffset: 0, associatedColor: Color(hex: "eddea4"), imageScale: 1.2)

    ]
    
    @Published var previousColor: Color = Color.green
    @Published var passedSteps: [Int] = [0]
    @Published var currentStep = 0 {
        didSet {
            Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: false) { _ in
                self.animationInProgress = false
            }
        }
    }
    @Published var scale: CGFloat = 0

    @Published var animationInProgress = false
    @Published var forward = true
    
    let animationDuration: TimeInterval = 0.8

    // MARK:- inits
    init() {
        previousColor = onboardingData[0].associatedColor
    }
    
    // MARK:- functions
    func addStep() {
        self.passedSteps.append(self.currentStep)
    }
    
    func removeStep(step: Int) {
        self.passedSteps = self.passedSteps.filter {
            $0 != step
        }
    }
    
    func skip() {
        
    }
}
