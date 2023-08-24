//
//  MainView.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

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
        self._model = StateObject(wrappedValue: ViewModel(user: user))
        self.safeArea = safeArea
        self.size = size
    }
    
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

