//
//  MainView.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct MainView: View {
    @State var selected: Int = 0
    @State var searchText = ""
    @Namespace var namespace
    var safeArea: EdgeInsets
    var size: CGSize
    
    var tabs: [String] = ["Quick Find", "Direct"]
    @StateObject var model: ViewModel
    @StateObject var locationModel: LocationModel = .init()
    init(safeArea: EdgeInsets, size: CGSize, user: ConnectUser) {
        self._model =  StateObject(wrappedValue: ViewModel(user: user))
        self.safeArea = safeArea
        self.size = size
    }
    @State var showingDeleteAlert = false
    @Environment (\.scenePhase) var scenePhase
 
    var body: some View {
       
            TabView(selection: $selected) {
                HomeView(size: size)
                    .environmentObject(model)
                    .tag(0)
//                DirectView()
//                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onChange(of: scenePhase) { phase in
                switch phase {
                    
                case .background:
                    break
                case .inactive:
                    model.goOffline()
                case .active:
                    if let location = locationModel.userLocation {
                        model.gotOnline(location)
                    }
                @unknown default:
                    break
                }
            }
            .overlay {
                if model.connectionState == .disconnected {
                    ZStack {
                        Color.black
                            .opacity(0.9)
                        (Text("Hey \(model.user.name),\n").font(.largeTitle.bold()).fontDesign(.rounded) + Text("Please keep it real :)\n\n\n").font(.title).fontDesign(.rounded).italic().foregroundColor(.red) + Text("1. No users under the age of 13\n2. No harrasment or bullying.\n3. Strictly No nudity or anything that signifies nudity.\n4. Don't be boring :(").fontWeight(.bold).fontDesign(.rounded))
                        VStack(alignment: .leading) {
                            HStack {
                                Image("ConnectIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .grayscale(1)
                                Text("Connect")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                                Menu {
                                    Button("Logout") {
                                        do {
                                            try Auth.auth().signOut()
                                            AuthModel.shared.user = nil
                                        } catch {}
                                    }
                                    Button("Delete My Account") {
                                        showingDeleteAlert = true
                                      
                                    }
                                    .foregroundColor(.white)
                                } label: {
                                    Text("My Account")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .padding(10)
                                        .padding(.horizontal, 10)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(.rect(cornerRadius: 17, style: .continuous))
                                }
                                .foregroundColor(.white)

                            }
                            .padding(.horizontal)
                            Spacer()
                            Button {
                                withAnimation {
                                    model.connectionState = .searching
                                }
                            } label : {
                                Label("Get Chatting", systemImage: "video.fill")
                                    .font(.title.bold()).fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                    .frame(height: 80)
                                //                                .padding(.bottom, safeArea.bottom)
                                    .frame(maxWidth: .infinity)
                                    .background(.linearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottom))
                                    .clipShape(.rect(cornerRadius: 30, style: .continuous))
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .alert("Are you sure you want to delete your account?", isPresented: $showingDeleteAlert, actions: {
                Button("Cancel") {
                    showingDeleteAlert = false
                }
                Button("Confirm") {
                    showingDeleteAlert = false
                    Firestore.firestore().collection("connectUsers").document(model.user.id).delete() { error in
                        if let error {
                            print(error.localizedDescription)
                        }
                        
                        do {
                            try Auth.auth().signOut()
                            AuthModel.shared.user = nil
                        } catch {}
                    }
                }
             
            })
//            .alert(isPresented: $showingDeleteAlert, error: nil) { _ in
//                Button("Confirm") {
//                    
//                }
//                Button("Cancel") {
//                    
//                }
//            } message: { _ in
//                Text("Are you sure you want to delete your account?")
//            }

//            .overlay(alignment: .top) {
//                HeaderView()
//            }
//            .overlay(alignment: .bottom) {
//                TabBarView()
//            }
    }
    
    func HeaderView()->some View{
        GeometryReader{proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height
            
            VStack {
                if searchText.isEmpty {
                    HStack {
                        Text(selected == 0 ? "Connect":"Direct")
                            .font(.largeTitle.bold())
                            .fontDesign(.rounded)
                            .foregroundStyle(.linearGradient(colors: selected == 0 ? [.white]:[.blue, .teal], startPoint: .topLeading, endPoint: .bottom))
                        Spacer()
                        Label("Add Campus", systemImage: "plus")
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .padding(10)
                            .padding(.horizontal, 5)
                            .background(.regularMaterial)
                            .clipShape(.rect(cornerRadius: 14, style: .continuous))
                            .foregroundStyle(.linearGradient(colors: selected == 0 ? [.white]:[.blue, .teal], startPoint: .topLeading, endPoint: .bottom).opacity(0.7))
                    }
                    HStack {
                        Text("Discover locations around and near you")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.linearGradient(colors: selected == 0 ? [.white]:[.blue, .teal], startPoint: .topLeading, endPoint: .bottom).opacity(0.7))

                        Spacer()
                    }
                }
            }
         
            .padding(.top,safeArea.top + 10)
            .padding([.horizontal,.bottom],15)
            .background(content: {
                Color.black
                    .opacity(-progress > 1 ? 1 : 0)
            })
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
    func TabBarView()->some View{
        
        HStack {
            ForEach(tabs.indices, id: \.self) { index in
                
                ZStack {
                    if selected == index {
                        ZStack {
                            if index == 0 {
                                Color.pink
                            } else {
                                Color.green
                            }
                            
                        }
                        .opacity(0.3)
                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                        .matchedGeometryEffect(id: "capsule", in: namespace)
                    }
                    HStack {
                        Image(tabs[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .grayscale(selected == index ? 0:1)
                        
                        if selected == index {
                            Text(tabs[index])
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(index == 0 ? Color.pink:.green)
                        }
                    }
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selected = index
                    }
                }
            }
        }
        .frame(height: 35)
        
        .padding()
        .padding(.bottom,safeArea.bottom)
        .background(content: {
            TransparentBlurView()
                .blur(radius: 2, opaque: false)
                .padding(-20)
                .clipShape(.rect(cornerRadius: 30, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 7)
//                    .opacity(-progress > 1 ? 1 : 0)
            })
        .offset(y: safeArea.bottom)
    }
}

