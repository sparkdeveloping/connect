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
    var country: String
    
    static func transformConnectUser(id: String, data: [String: Any]) -> ConnectUser {
        let id = id.isEmpty ? data["id"] as? String ?? "":id
        let name = data["name"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let country = data["country"] as? String ?? ""
//        let  = data["email"] as? String ?? ""
        return .init(id: id, name: name, email: email, country: country)
    }
}

class AuthModel: ObservableObject {
    
    static var shared = AuthModel()
    // MARK:- variables
    @Published var isLoading = false
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
    @Published var country: String = ""
    let animationDuration: TimeInterval = 0.8

    // MARK:- inits
    init() {
        previousColor = onboardingData[0].associatedColor
        retrieveCurrentUser() {}
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
    
    func retrieveCurrentUser(_ id: String? = Auth.auth().currentUser?.uid, onSuccess: @escaping()->()) {
        if let id  {
            Firestore.firestore().collection("connectUsers").document(id).getDocument { snapshot, error in
                if let error {
                    withAnimation {
                        self.isLoading = false
                    }
                }
                if let snapshot, let data = snapshot.data() {
                    let user = ConnectUser.transformConnectUser(id: id, data: data)
                    self.user = user
                    withAnimation {
                        self.isLoading = false
                    }
                    
                }
                
            }
        }
    }
    
    func register(onSuccess: @escaping()->()) {
        withAnimation {
            isLoading = true
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
                withAnimation {
                    self.isLoading = false
                }
            }
            if let result {
                let id = result.user.uid
                let country = self.country != "Select Country" ? self.country:""
                Firestore.firestore().collection("connectUsers").document(id).setData(["name":self.name,
                                                                                       "email":self.email,
                                                                                       "password":self.password, "country": country])
                let user = ConnectUser(id: id, name: self.name, email: self.email, country: self.country)
                self.user = user
                
                withAnimation {
                    self.isLoading = false
                }
                onSuccess()
            }
        }
    }
    
    func login(onSuccess: @escaping()->()) {
        withAnimation {
            isLoading = true
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
                withAnimation {
                    self.isLoading = false
                }
            }
            if let result {
                let id = result.user.uid
               
                self.retrieveCurrentUser(id, onSuccess: onSuccess)
                
            }
        }
        
    }
    
}
