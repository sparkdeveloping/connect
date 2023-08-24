//
//  AppModel.swift
//  Onboarder
//
//  Created by Shubham on 01/05/21.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import SwiftUI

struct ConnectUser: Identifiable {
    
    var id: String
    var name: String
    var email: String
    
    static func transformConnectUser(id: String, data: [String: Any]) -> ConnectUser {
        let name = data["name"] as? String ?? ""
        let email = data["email"] as? String ?? ""
//        let  = data["email"] as? String ?? ""
        return .init(id: id, name: name, email: email)
    }
}

class AuthModel: ObservableObject {
    
    // MARK:- variables
    @Published var onboardingData: [OnboardingMetaData] = [
        OnboardingMetaData(imageName: "Students", title: "YAYY!", subtitle: "finally and renound app for just students!", imageOffset: 0, associatedColor: Color(hex: "ffffff")),
        OnboardingMetaData(imageName: "Nearby", title: "Proximity\nChat ", subtitle: "discover hot conversations and chats next to you!", imageOffset: -24, associatedColor: Color(hex: "f2bac9"), imageScale: 1.2),
        OnboardingMetaData(imageName: "Brain", title: "Stay Smart\nHave fun!", subtitle: "lots more to explore, for now, have stay smart & have fun!", imageOffset: 0, associatedColor: Color(hex: "eddea4"), imageScale: 1.2)

    ]
    
    @Published var previousColor: Color = Color.green
    @Published var passedSteps: [Int] = [0]
    @Published var error: String?
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
    @Published var user: ConnectUser?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    let animationDuration: TimeInterval = 0.8

    // MARK:- inits
    init() {
        previousColor = onboardingData[0].associatedColor
        retrieveCurrentUser()
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
    
    func retrieveCurrentUser() {
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("connectUsers").document(id).getDocument { snapshot, error in
                if let error {
                    
                }
                if let snapshot, let data = snapshot.data() {
                    let user = ConnectUser.transformConnectUser(id: id, data: data)
                    self.user = user
                }
                
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
            }
            if let result {
                let id = result.user.uid
                Firestore.firestore().collection("connectUsers").document(id).setData(["name":self.name,
                                                                                       "email":self.email,
                                                                                       "password":self.password])
                let user = ConnectUser(id: id, name: self.name, email: self.email)
                self.user = user
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
            }
            if let result {
                let id = result.user.uid
                Firestore.firestore().collection("connectUsers").document(id).setData(["name":self.name,
                                                                                       "email":self.email,
                                                                                       "password":self.password])
                let user = ConnectUser(id: id, name: self.name, email: self.email)
                self.user = user
            }
        }
    }
    
}
