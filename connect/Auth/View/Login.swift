//
//  Login.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

struct Login: View {
    @Binding var showSignup: Bool
    /// View Properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordView: Bool = false
    /// Reset Password View (with New Password and Confimration Password View)
    @State private var showResetView: Bool = false
    /// Optional, Present If you want to ask OTP for login
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    @Environment (\.dismiss) var dismiss
    @Binding var overrideToSignIn: Bool

    @EnvironmentObject var authModel: AuthModel
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Image(systemName: "xmark")
                .font(.largeTitle.bold())
                .contentShape(Rectangle())
                .onTapGesture {
                    dismiss()
                }
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                if let error = authModel.error {
                    Text(error)
                        .font(.caption.bold())
                        .foregroundStyle(.red)
                        .fontDesign(.rounded)
                        .hSpacing(.leading)
                }
                
                CustomTF(sfIcon: "at", hint: "Email ID", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot Password?") {
                    showForgotPasswordView.toggle()
                }
                .font(.callout)
                .fontDesign(.rounded)
                .fontWeight(.heavy)
                .tint(.appYellow)
                .hSpacing(.trailing)
                
                /// Login Button
                GradientButton(title: "Login", icon: "arrow.right") {
                    /// YOUR CODE
//                    askOTP.toggle()
                    
                    authModel.login() {
                        self.overrideToSignIn = true
                    }
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(emailID.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                    .fontDesign(.rounded)
                Button("Create one here.") {
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .tint(.appYellow)
            }
            .font(.callout)
            .hSpacing()
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        /// Asking Email ID For Sending Reset Link
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        /// Resetting New Password
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
        /// OTP Prompt
        .sheet(isPresented: $askOTP, onDismiss: {
            /// YOUR CODE
            /// Reset OTP if You Want
            // otpText = ""
        }, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
            }
        })
    }
}
