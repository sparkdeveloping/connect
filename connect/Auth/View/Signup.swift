//
//  Signup.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

struct SignUp: View {
    @Binding var showSignup: Bool
    /// View Properties
    @State private var emailID: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    /// Optional, Present If you want to ask OTP for Signup
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
    @EnvironmentObject var authModel: AuthModel
    
    @Binding var overrideToSignIn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            /// Back Button
            Button(action: {
                showSignup = false
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("SignUp")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                if let error = authModel.error {
                    Text(error)
                        .font(.caption.bold())
                        .foregroundStyle(.red)
                        .hSpacing(.leading)
                }
                
                CustomTF(sfIcon: "person.fill", hint: "Username", value: $authModel.name)
                    .padding(.top, 5)
                CustomTF(sfIcon: "at", hint: "Email", value: $authModel.email)
                CustomTF(sfIcon: "globe", hint: "Country", isCountry: true, value: $authModel.country)

                CustomTF(sfIcon: "lock.fill", hint: "Password", isPassword: true, value: $authModel.password)
                    .padding(.top, 5)
                
                Text("By signing up, you're agreeing to our **[Terms & Condition](https://www.freeprivacypolicy.com/live/39b988c5-88f0-43d4-9dcf-28d925050ecc)** and **[Privacy Policy](https://www.freeprivacypolicy.com/live/39b988c5-88f0-43d4-9dcf-28d925050ecc)**")
                    .font(.caption)
                    .tint(.appYellow)
                    .foregroundStyle(.gray)
                    .frame(height: 50)
                
                /// SignUp Button
                GradientButton(title: "Continue", icon: "arrow.right") {
                    /// YOUR CODE
                    authModel.register() {
                        self.overrideToSignIn = true
                    }
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(authModel.email.isEmpty || authModel.password.isEmpty || authModel.name.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Already have an account?")
                    .foregroundStyle(.gray)
                
                Button("Login") {
                    showSignup = false
                }
                .fontWeight(.bold)
                .tint(.appYellow)
            }
            .font(.callout)
            .hSpacing()
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
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

#Preview {
    ContentView()
}
