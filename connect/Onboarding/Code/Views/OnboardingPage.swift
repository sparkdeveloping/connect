//
//  OnboardingView.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import Lottie
import SwiftUI

struct OnboardingPage: View {
    
    // MARK:- variables
    @State var viewAppeared = false
    
    @Binding var selectedIndex: Int
    @StateObject var appModel: AppModel
    
    let onboardingData: OnboardingMetaData
    var step: Int
    
    // MARK:- views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            VStack(alignment: .leading) {
//                Image(onboardingData.imageName)
//                    .resizable()
//                    .scaledToFit()
                LottieView(name: onboardingData.imageName, loopMode: .autoReverse)
                    .scaleEffect(onboardingData.imageScale)
                    .offset(y: onboardingData.imageOffset)
                VStack(alignment: .leading) {
                    
                    Text(onboardingData.title)
                        .foregroundColor(.black)
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .shadow(color: Color(hex: "c0c0c0").opacity(0.4), radius: 5)
                        .opacity(self.viewAppeared ? 1 : 0)
                        .offset(y: self.viewAppeared ? 0 : -100)
                        .frame(height: self.viewAppeared ? 150 : CGFloat.zero, alignment: .leading)
                        .frame(minHeight: 150)
                        .animation(Animation.spring(response: 0.8, dampingFraction: 0.9).delay(0.25), value: self.viewAppeared)
                    
                    Text(onboardingData.subtitle)
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .opacity(0.7)
                        .shadow(color: Color(hex: "c0c0c0").opacity(1), radius: 5)
                        .foregroundColor(.black)
                        .padding(.top, 16)
                        .opacity(self.viewAppeared ? 1 : 0)
                        .offset(y: self.viewAppeared ? 0 : 100)
                        .frame(height: self.viewAppeared ? 80 : CGFloat.zero, alignment: .top)
                        .frame(minHeight: 80)
                        .animation(Animation.spring(response: 0.8, dampingFraction: 0.9).delay(0.325), value: self.viewAppeared)
                }.padding([.leading, .trailing], 42)
                Spacer()
            }.padding(.top, 42)
            
        }.onAppear() {
            showOrHideView()
        }
    }
    
    // MARK:- functions
    func showOrHideView() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if (!viewAppeared && appModel.currentStep == step) {
                animate()
            } else if (viewAppeared && appModel.currentStep != step) {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    hide()
                }
            }
        }
    }
    
    func animate() {
        self.viewAppeared = true
    }
    
    func hide() {
        self.viewAppeared = false
    }
}

struct LottieView: UIViewRepresentable {
    var name = "success"
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
