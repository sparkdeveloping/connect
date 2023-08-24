//
//  HomeView.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

/*
import SwiftUI
import _MapKit_SwiftUI

struct HomeView: View {
    
    @Binding var searchText: String
    
    var iconSize: CGFloat = 40
    var safeArea: EdgeInsets
    var size: CGSize
    @StateObject var locationModel: LocationModel = .init()
    @Namespace var namespace
    var suggestions = ["Classes", "Essentials", "Recreational"]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                // MARK: Artwork
                ArtWork()
//                if searchText.isEmpty {
                GeometryReader{proxy in
                    //                        // MARK: Since We Ignored Top Edge
                    let minY = proxy.frame(in: .named("SCROLL")).minY - safeArea.top
                    //
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(POICategory.allCases) { category in
                                ZStack {
                                    if locationModel.selectedCategory == category {
                                        LinearGradient(colors: [.blue, .teal], startPoint: .topLeading, endPoint: .bottom)
                                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                            .matchedGeometryEffect(id: "selection", in: namespace)

                                    }
                                    Text(category.name)
                                        .font(.title3.bold())
                                        .fontDesign(.rounded)
                                        .padding(.horizontal)
                                        .foregroundStyle(locationModel.selectedCategory == category ? Color.white:.gray)
                                }
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        locationModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .padding(.horizontal)
                        .offset(y: minY < 50 ? -(minY - 50) : 0)
                    }
                }
                .frame(height: 50)
                //                    .padding(.top,-34)
                .zIndex(1)
                //                }
//                Map(coordinateRegion: $locationModel.region, showsUserLocation: true)
//                    .frame(height: size.width / 2)
//                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
//                    .shadow(color: .black.opacity(0.1), radius: 20, x: 1, y: 7)
//
//                    .padding(.horizontal)
                    
                VStack(alignment: .leading) {
              
                    ForEach(locationModel.results) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.title3)
                                HStack {
                                    Image(item.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                    Text(item.itemCategory.uppercased().replacingOccurrences(of: "MKPOICATEGORY", with: ""))
                                        .font(.caption2.bold())
                                        .fontDesign(.rounded)
                                        .foregroundStyle(Color.gray)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .padding(.horizontal)
                        .background(Color.background)
                        .clipShape(.rect(cornerRadius: 25, style: .continuous))
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 4)
                    }
                    // MARK: Album View
//                    AlbumView()
                }
//                .zIndex(1)
                .padding(.horizontal)
            }
           
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    func ArtWork()->some View{
        let height = size.height * 0.4
        GeometryReader{proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            LinearGradient(colors: [.blue, .teal], startPoint: .topLeading, endPoint: .bottom)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        // MARK: Gradient Overlay
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    .background.opacity(0 - progress),
                                    .background.opacity(0.1 - progress),
                                    .background.opacity(0.3 - progress),
                                    .background.opacity(0.5 - progress),
                                    .background.opacity(0.8 - progress),
                                    .background.opacity(1),
                                ], startPoint: .top, endPoint: .bottom)
                            )
                      
                        VStack(spacing: 20) {
                           
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.title3.bold())
                                TextField("Seach for any location", text: $searchText)
                                    .font(.title3)
                            }
                            .foregroundStyle(.black.opacity(0.8))
                            .padding(10)
                            .padding(.horizontal, 5)
                            .background(
                                Color.clear.background(.ultraThinMaterial).opacity(searchText.isEmpty ? 1:0)
                            )
                            .clipShape(.rect(cornerRadius: 17, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 20, x: 1, y: 7)
                            .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                ForEach(suggestions, id: \.self) { suggestion in
                                    VStack(spacing: 20) {
                                        ZStack {
                                            Color.background
                                            Image(suggestion)
                                                .resizable()
                                                .scaledToFit()
                                                .shadow(color: .black.opacity(0.2), radius: 20, x: 1, y: 7)
                                                .frame(width: iconSize, height: iconSize)
                                                .background {
                                                    Color.background
                                                        .frame(width: (size.width - 80) / 3, height: (size.width - 80) / 3)
                                                        .clipShape(.rect(cornerRadius: (size.width - 80) / 3 * 0.3))
                                                }
                                        }
                                        .frame(width: (size.width - 80) / 3, height: (size.width - 80) / 3)
                                        .clipShape(.rect(cornerRadius: (size.width - 80) / 3 * 0.3))
                                        .shadow(color: .black.opacity(0.1), radius: 20, x: 1, y: 7)
                                        Text(suggestion)
                                            .font(.caption.bold())
                                            .fontDesign(.rounded)
                                    }
                                    
                                }
                            }
                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.vertical, 40)
                        
                        // Moving With ScrollView
                        .offset(y: minY < 0 ? minY : 0)
                    }
                })
                .offset(y: -minY)
        }
        .frame(height: height + safeArea.top)
    }
    
}

*/


//
//  ContentView.swift
//  Agora-SwiftUI-Example
//
//  Created by Max Cobb on 29/12/2020.
//

import SwiftUI
import AgoraUIKit
import AgoraRtcKit
import AVFoundation
import Firebase

struct HomeView: View {
    @EnvironmentObject var model: ViewModel
    @State var joined = false
    
    var size: CGSize
    
    @State var showingLocalVideo = false
    @State var isDragging = false
    
    @State var smallVideoAlignment: Alignment = .bottomTrailing
    
    @State var offset: CGSize = .zero
    @State var showingOnScreenActions = true
    
    var name: String {
        switch model.connectionState {
            
        case .searching:
            return "Searching"
        case .connecting:
            return "Connecting"
        case .connected:
            return "username"
        case .disconnected:
            return "Offline"
        }
    }
    
    var body: some View {
        let onScreenTapGesture = TapGesture()
            .onEnded { _ in
                withAnimation(.spring()) {
                    showingOnScreenActions.toggle()
                }
            }
        let tapGesture = TapGesture()
            .onEnded { _ in
                withAnimation(.spring()) {
                    showingLocalVideo.toggle()
                }
            }
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { value in
                withAnimation(.spring()) {
                    isDragging = true
                }
                self.offset = value.translation
            }
            .onEnded { value in
                let widthOffset = abs(value.translation.width)
                let heightOffset = abs(value.translation.height)
                
                let shouldHorizontal = widthOffset > size.width / 4 ? true:false
                let shouldVertical = heightOffset > size.width / 4 ? true:false
                
              
                switch smallVideoAlignment {
                case .topLeading:
                    if shouldHorizontal && shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomTrailing
                        }
                    } else if shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomLeading
                        }
                    } else if shouldHorizontal {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topTrailing
                        }
                    }
                case .topTrailing:
                    if shouldHorizontal && shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomLeading
                        }
                    } else if shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomTrailing
                        }
                    } else if shouldHorizontal {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topLeading
                        }
                    }
                case .bottomTrailing:
                    if shouldHorizontal && shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topLeading
                        }
                    } else if shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topTrailing
                        }
                    } else if shouldHorizontal {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomLeading
                        }
                    }
                case .bottomLeading:
                    if shouldHorizontal && shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topTrailing
                        }
                    } else if shouldVertical {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .topLeading
                        }
                    } else if shouldHorizontal {
                        withAnimation(.spring()) {
                            smallVideoAlignment = .bottomTrailing
                        }
                    }
                default:
                    break
                }
                
                withAnimation(.spring()) {
                    isDragging = false
                    self.offset = .zero
                }
            }
            
        ZStack(alignment: smallVideoAlignment) {
            AgoraVideoView(view: showingLocalVideo ? model.manager.localView:model.manager.remoteView)
                .simultaneousGesture(onScreenTapGesture)
            LinearGradient(colors: [.black, .black.opacity(0), .black.opacity(0), .black.opacity(0), .black.opacity(0), .black], startPoint: .bottom, endPoint: .top)
                .opacity(showingOnScreenActions ? 1:0)
                .simultaneousGesture(onScreenTapGesture)
            AgoraVideoView(view: showingLocalVideo ? model.manager.remoteView:model.manager.localView)                .frame(width: size.width / 2 - 40, height: size.width / 2 - 40)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                .padding()
                .padding(.vertical, showingOnScreenActions ? 60:0)
                .opacity(joined ? 1:0.5)
                .offset(offset)
                .simultaneousGesture(tapGesture)
                .simultaneousGesture(dragGesture)
        
            VStack {
                HStack {
                    Text(name)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                  Spacer()
                        Text("Leave")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(height: 40)
                            .padding(.horizontal, 10)
                            .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottom))
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                }
                .frame(height: 60)
                Spacer()
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.gray)
                    Image(systemName: "gift.fill")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.yellow)
                    Image(systemName: "chevron.right")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .frame(height: 60)
                
            }
            .opacity(showingOnScreenActions ? 1:0)
            .padding(.horizontal)
        }
        .clipShape(.rect(cornerRadius: 14, style: .continuous))

        .onAppear {
            Task {
                await self.model.manager.joinChannel() { joined in
                    self.joined = joined
                }
            }
        }
    }
}

class AgoraManager: NSObject, AgoraRtcEngineDelegate {
    
    let videoCanvas = AgoraRtcVideoCanvas()
    let localView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let remoteView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    // The main entry point for Video SDK
    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams.
    var userRole: AgoraClientRole = .broadcaster

    // Update with the App ID of your project generated on Agora Console.
    let appID = "6f5d8b88c33c4ac7a8501dbf38afbc6d"
    // Update with the temporary token generated in Agora Console.
    
    // Update with the channel name you used to generate the token in Agora Console.
    var channelName = "test"
    
    let token = "0066f5d8b88c33c4ac7a8501dbf38afbc6dIADTn2msgvTvzShSwoHjufdqgn9Yze4vAMhNJEfz60fPcAx+f9gh39v0IgApexquqCPhZAQAAQDIWOFkAgDIWOFkAwDIWOFkBADIWOFk"
    
    override init()  {
        super.init()
        initializeAgoraEngine()
    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = appID
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    

    
    func setupLocalVideo() {
        // Enable the video module
        agoraEngine.enableVideo()
        // Start the local video preview
        agoraEngine.startPreview()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        // Set the local video view
        agoraEngine.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel(joined: @escaping (Bool) ->()) async {
//        if await !self.checkForPermissions() {
//            showMessage(title: "Error", text: "Permissions were not granted")
//            return
//        }

        let option = AgoraRtcChannelMediaOptions()

        // Set the client role option as broadcaster or audience.
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
            setupLocalVideo()
        } else {
            option.clientRoleType = .audience
        }

        // For a video call scenario, set the channel profile as communication.
        option.channelProfile = .communication

        // Join the channel with a temp token. Pass in your token and channel name here
        let result = agoraEngine.joinChannel(
            byToken: token, channelId: channelName, uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in }
        )
            // Check if joining the channel was successful and set joined Bool accordingly
        if result == 0 {
            joined(true)
//            showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
    }
/*
    func fetchToken(completionHandler: @escaping ([Film]) -> Void) {
        let url = URL(string: domainUrlString + "films/")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response)")
            return
          }

          if let data = data,
            let filmSummary = try? JSONDecoder().decode(FilmSummary.self, from: data) {
            completionHandler(filmSummary.results ?? [])
          }
        })
        task.resume()
      }
  */
    func leaveChannel() {
        agoraEngine.stopPreview()
        let result = agoraEngine.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
//        if result == 0 { joined(f alse) }
    }

    
//    func checkForPermissions() -> Bool {
//        var hasPermissions =  self.avAuthorization(mediaType: .video)
//        // Break out, because camera permissions have been denied or restricted.
//        if !hasPermissions { return false }
//        hasPermissions =  self.avAuthorization(mediaType: .audio)
//        return hasPermissions
//    }
//    
    func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
    
    
   
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
   
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine.setupRemoteVideo(videoCanvas)
//        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}

enum ConnectionState: String {
    case searching, connecting, connected, disconnected
}

class ViewModel: ObservableObject {
    var manager = AgoraManager()

    var user: ConnectUser
 
    
    @Published var lastTimestamp: Double = .zero
    @Published var connectionState: ConnectionState = .disconnected {
        didSet {
            if connectionState == .searching {
                searchForAUser()
            }
        }
    }
    
    
    init(user: ConnectUser) {
        self.user = user
        listenForConnectionRequests()
        searchForAUser()
    }
    
    func listenForConnectionRequests() {
        // first, check to see if someone wants to chat
        connectionState = .searching
        Database.database().reference().child("connectUsers").child(user.id).child("requesting").observe(.value) { snapshot in
            if let value = snapshot.value as? String {
                print("\n\n\n\n\n SNAPSHOT: \(value) \n\n\n\n\n\n\n")
                Database.database().reference().child("connectUsers").child(value).child("requesting").setValue(self.user.id)
                self.connectionState = .connecting
            } else {
                print("\n\n\n\n\n SNAPSHOT: NON EXISTENT \n\n\n\n\n\n\n")
                self.connectionState = .searching
            }
        }
    }
    
    func searchForAUser() {
        // first lets gather all user id-s
        while connectionState == .searching {
            
            Database.database().reference().child("connectUsers").observeSingleEvent(of: .value) { snapshot in
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    print("\n\n\n\n\n CHILDLREN: \(children) ==== \(children.count) \n\n\n\n\n\n")
                    var currentIndex = 0
                    var setDelay: Double = 0
                    while currentIndex != children.count && self.connectionState == .searching {
                        self.delay(setDelay) {
                            print("Searched with delay: \(setDelay)")
                            if self.connectionState == .searching {
                                let child = children[currentIndex]
                                if let value = child.value as? [String: Any], let requesting = value["requesting"] as? String, !requesting.isEmpty {
                                    setDelay = 0
                                } else {
                                    Database.database().reference().child("connectUsers").child(child.key).child("requesting").setValue(self.user.id)
                                    setDelay = 4
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay *
        Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    func gotOnline(_ coordinates: CLLocation) {
        Database.database().reference().child("connectUsers").child(user.id).updateChildValues(["isOnline":true])
        if Date.now.timeIntervalSince1970 - lastTimestamp > 10000 {
            self.setCurrentLocation(coordinates)
            self.lastTimestamp = Date.now.timeIntervalSince1970
        }
    }
    
    func goOffline() {
        Database.database().reference().child("connectUsers").child(user.id).updateChildValues(["isOnline":false])
    }
    
    func setCurrentLocation(_ coordinates: CLLocation) {
        let rootRef = Database.database().reference()
        let geoRef = GeoFire(firebaseRef: rootRef.child("userLocations"))
        
        geoRef.setLocation(coordinates, forKey: user.id) { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
        
        
    }
    
    func retrieveOnlineUsers() {
//        Database.database().reference().child("onlineUsers").observe(.childAdded, with: <#T##(DataSnapshot) -> Void#>)
    }
}

struct AgoraVideoView: UIViewRepresentable {

    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}
