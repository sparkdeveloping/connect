//
//  StrokedRectange.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import SwiftUI

struct StrokedRectangle: View {
    
    // MARK:- variables
    @EnvironmentObject var appModel: AppModel
    @Binding var background: Color
    
    let animationDuration: TimeInterval = 0.5
    
    // MARK:- views
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.43, to: 0.73)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .opacity(0.1)
                
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.43, to: self.appModel.passedSteps.contains(0) ? 0.73 : 0.43)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundColor(background)
                    .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .animation(Animation.easeInOut(duration: animationDuration))
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.1, to: 0.4)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .opacity(0.1)
                
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.1, to: self.appModel.passedSteps.contains(1) ? 0.4 : 0.1)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundColor(background)
                    .animation(Animation.easeInOut(duration: animationDuration))
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.43, to: 0.73)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .opacity(0.1)
                
                RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                    .trim(from: 0.43, to: self.appModel.passedSteps.contains(2) ? 0.73 : 0.43)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundColor(background)
                    .animation(Animation.easeInOut(duration: animationDuration))
        }
        .frame(width: 48, height: 48)
    }
}

struct StrokedRectange_Previews: PreviewProvider {
    static var previews: some View {
        StrokedRectangle(background: .constant(.green))
            .environmentObject(AppModel())
    }
}
