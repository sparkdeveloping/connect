//
//  NextButon.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import SwiftUI

struct NextButton: View {
    
    // MARK:- variables
    @Binding var background: Color
    @EnvironmentObject var appModel: AuthModel
    
    // MARK:- views
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.appModel.currentStep == 2 ? 25 : 30)
                .foregroundColor(Color.white)
                .shadow(color: Color.white.opacity(0.4), radius: 5)
            StrokedRectangle(background: $background)
                .environmentObject(appModel)
            Image(systemName: "chevron.right")
                .foregroundColor(appModel.currentStep == 2 ? Color.blue : Color.black)
                .font(.system(size: 17, weight: self.appModel.currentStep == 2 ? .black : .semibold))
                .scaleEffect(self.appModel.currentStep == 2 ? 1.2 : 1)
                .animation(.default)
        }
        .frame(width: 60, height: 60)
        .scaleEffect(self.appModel.currentStep == 2 ? 0.9 : 1)
        .animation(.default)
    }
}
