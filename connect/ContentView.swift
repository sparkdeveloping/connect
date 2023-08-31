//
//  ContentView.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/8/23.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @StateObject var navigationModel: NavigationModel = .init()
    @State private var showSignup: Bool = false
    /// Keyboard Status
    @State private var isKeyboardShowing: Bool = false
    @StateObject var authModel: AuthModel = .shared
    
    @State var override = false
    var body: some View {
        GeometryReader {
            
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            
            NavigationStack(path: $navigationModel.path) {
                ZStack {
                    if override {
                        MainView(safeArea: safeArea, size: size, user: authModel.user!)
                    } else if let user = authModel.user {
                        MainView(safeArea: safeArea, size: size, user: user)
                        
                    } else if Auth.auth().currentUser != nil {
                        LottieView(name: "Globe")
                            .frame(width: 80, height: 80)
                    } else {
                        
                        Login(showSignup: $showSignup, overrideToSignIn: $override)
                            .environmentObject(authModel)
                            .overlay(alignment: showSignup ? .leading:.trailing) {
                                /// iOS 17 Bounce Animations
                                if #available(iOS 17, *) {
                                    /// Since this Project Supports iOS 16 too.
                                    CircleView()
                                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
                                } else {
                                    CircleView()
                                        .animation(.spring(), value: showSignup)
                                        .animation(.spring(), value: isKeyboardShowing)
                                }
                            }
                            .navigationDestination(isPresented: $showSignup) {
                                SignUp(showSignup: $showSignup, overrideToSignIn: $override)
                                    .environmentObject(authModel)
                            }
                        /// Checking if any Keyboard is Visible
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                                /// Disabling it for signup view
                                if !showSignup {
                                    isKeyboardShowing = true
                                }
                            })
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                                isKeyboardShowing = false
                            })
                         
                    }
                    //                OnboardingView(background: Color.green)
                    //                    .environmentObject(navigationModel)
                   
                }
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .navigationDestination(for: String.self) { string in
                    /*
                    if string == "login" {
                        Login(showSignup: $showSignup)
                            .overlay(alignment: showSignup ? .leading:.trailing) {
                                /// iOS 17 Bounce Animations
                                if #available(iOS 17, *) {
                                    /// Since this Project Supports iOS 16 too.
                                    CircleView()
                                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
                                } else {
                                    CircleView()
                                        .animation(.spring(), value: showSignup)
                                        .animation(.spring(), value: isKeyboardShowing)
                                }
                            }
                            .navigationDestination(isPresented: $showSignup) {
                                SignUp(showSignup: $showSignup)
                            }
                        /// Checking if any Keyboard is Visible
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                                /// Disabling it for signup view
                                if !showSignup {
                                    isKeyboardShowing = true
                                }
                            })
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                                isKeyboardShowing = false
                            })
                    }
                     */
                }
            }
            .background {
                Color.background
            }
            .overlay {
                if authModel.isLoading {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.6)
                        LottieView(name: "Globe")
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.appYellow, .orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            /// Moving When the Signup Pages Loads/Dismisses
            .offset(x: showSignup ? -90 : 90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
//            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}
