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
    
    var size: CGSize
    
    @State var showingLocalVideo = false
    @State var isDragging = false
    
    @State var smallVideoAlignment: Alignment = .bottomTrailing
    
    @State var offset: CGSize = .zero
    @State var showingOnScreenActions = true
    @State private var shouldBlink = true
    @State private var opacity = 1.0
@State var showingReportAlert = false
    @State var reportMessage = ""
    var name: String {
        switch model.connectionState {
            
        case .searching:
            return "Searching"
        case .connecting:
            return "Connecting"
        case .connected:
            return model.connectedUser?.name ?? "Unknown User"
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
                .opacity(showingOnScreenActions ? 1:model.connectionState == .connected ? 0:1)
                .simultaneousGesture(onScreenTapGesture)
            if model.connectionState != .searching {
                AgoraVideoView(view: showingLocalVideo ? model.manager.remoteView:model.manager.localView)                .frame(width: size.width / 2 - 40, height: size.width / 2 - 40)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .padding()
                    .padding(.vertical, showingOnScreenActions ? 60:model.connectionState == .connected ? 0:60)
                    .opacity(model.connectionState == .connected ? 1:0.5)
                    .offset(offset)
                    .simultaneousGesture(tapGesture)
                    .simultaneousGesture(dragGesture)
            }
            if model.connectionState != .disconnected {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .italic(model.connectionState != .connected)
                            //                            .opacity(model.connectionState == .searching ? opacity : 1)
                                .onAppear {
                                    if model.connectionState == .searching {
                                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                            opacity = 0
                                        }
                                    }
                                }
                            if let user = model.connectedUser, model.connectionState == .connected {
                                Text(user.country.isEmpty ? "Someone on Earth":user.country)
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                model.connectionState = .disconnected
                            }
                        } label: {
                            Text("Leave")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .frame(height: 40)
                                .padding(.horizontal, 10)
                                .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottom))
                                .clipShape(.rect(cornerRadius: 15, style: .continuous))
                        }
                    }
                    .frame(height: 60)
                    if model.connectionState != .connected {
                        Spacer()
                        (Text("Finding fantabulous people\n\n").font(.title.bold()) + Text(model.didYouKnowFacts[Int.random(in: 0..<20)]).italic())
                    }
                    Spacer()
                    if model.connectionState == .connected {
                        HStack {
                            Menu {
                                Button("Sexual content and/or nudity") {
                                    
                                }
                                Button("Harrassment or Bullying") {
                                    
                                }
                                Button("Minor or child") {
                                    
                                }
                                Button("Other") {
                                    showingReportAlert = true
                                }
                            } label: {
                                Image(systemName: "exclamationmark.octagon.fill")
                                    .font(.largeTitle.bold())
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.gray)
                                //                            Image(systemName: "gift.fill")
                                //                                .font(.largeTitle.bold())
                                //                                .frame(maxWidth: .infinity)
                                //                                .foregroundStyle(.orange)
                            }
                            Color.clear
                            Button {
                                withAnimation {
                                    model.connectionState = .searching
                                }
                            } label: {
                                HStack {
                                    Text("Next")
                                        .font(.title.bold())
                                        .fontDesign(.rounded)
                                    Image(systemName: "chevron.right")
                                        .font(.largeTitle.bold())
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .contentShape(.rect)
                             
                            }
                        }
                        .frame(height: 60)
                    } else if model.connectionState == .searching {
                        LoadingView()
                            .frame(width: 100, height: 100)
                    }
                }
                .opacity(showingOnScreenActions ? 1:model.connectionState == .connected ? 0:1)
                .padding(.horizontal)
            }
        }
        .clipShape(.rect(cornerRadius: 14, style: .continuous))
    
        .alert("What are you reporting about?", isPresented: $showingReportAlert) {
            TextField("e.g promoting Violence", text: $reportMessage)
            Button("Cancel") {
                showingReportAlert = false
            }
            
            Button("Report") {
                showingReportAlert = false
            }
        } message: {
            Text("e.g promoting Violence")
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

    
   
    
    var tokenURL = "https://studentsconnect-f319888a67a0.herokuapp.com/"
    
    override init()  {
        super.init()
        self.initializeAgoraEngine()
    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = appID
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    
    func fetchToken(
        tokenType: String = "rtc",
        channel: String,
        role: String = "publisher",
        uid: String = "0",
        expire: Int = 10000,
        completion: @escaping (String?, Error?) -> Void
    ) {
        // Define the request parameters
        let params: [String: Any] = [
            "tokenType": tokenType,
            "channel": channel,
            "role": role,
            "uid": uid,
            "expire": expire
        ]
        
        // Convert the dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else {
            completion(nil, NSError(domain: "JSONError", code: 1, userInfo: nil))
            return
        }
        
        // Create the URL and request
        if let url = URL(string: "https://studentsconnect-f319888a67a0.herokuapp.com/rtc/\(channel)/publisher/uid/0/?expiry=3600") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set the request headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Attach JSON data to the request body
            request.httpBody = jsonData
            
            // Perform the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    completion(nil, NSError(domain: "NoData", code: 3, userInfo: nil))
                    return
                }

                let rawString = String(data: data, encoding: .utf8)
                print("Raw String: \(rawString ?? "")")

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any],
                       let token = jsonDict["rtcToken"] as? String {
                        completion(token, nil)
                    } else {
                        completion(nil, NSError(domain: "InvalidResponse", code: 2, userInfo: nil))
                    }
                } catch {
                    completion(nil, error)
                }
            }
            
            task.resume()
        }
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
    
    func joinChannel(token: String, channel: String, joined: @escaping (Bool) ->()) async {
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
            byToken: token, channelId: channel, uid: 0, mediaOptions: option,
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
    func leaveChannel(joined: @escaping (Bool) ->()) async {
        agoraEngine.stopPreview()
        let result = agoraEngine.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if result == 0 { joined(false) }
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
            switch connectionState {
            case .searching:
                self.cleanAll()
                self.manager.setupLocalVideo()
                self.addToWaitingRoom()
                self.listenForChatRoomUpdates()
            case .connecting:
                break
            case .connected:
                break
            case .disconnected:
                cleanAll()
            }
        }
    }
    
    var userId: String {
        return user.id
    }
    init(user: ConnectUser) {
        self.user = user

    }
    
    var currentChatId: String?
    var connectedUser: ConnectUser?
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration? = nil
    
    let didYouKnowFacts: [String] = [
        "That a group of flamingos is called a 'flamboyance'?",
        "That the shortest war in history was between Britain and Zanzibar on August 27, 1896? Zanzibar surrendered after 38 minutes.",
        "The 'D' in D-Day stands for 'Day'?",
        "Cats can't taste sweetness?",
        "The dot over the letters 'i' and 'j' is called a 'tittle'?",
        "The longest time between two twins being born is 87 days?",
        "A 'jiffy' is an actual unit of time? It's 1/100th of a second!",
        "Honey never spoils?",
        "The inventor of the frisbee was turned into a frisbee?",
        "It's impossible to hum while holding your nose?",
        "The smell of freshly-cut grass is actually a plant distress call?",
        "An octopus has three hearts?",
        "Wombat feces are cube-shaped?",
        "The shortest scientific paper ever published contains zero words?",
        "The first oranges were not orange but green?",
        "Snails can sleep for up to 3 years?",
        "The unicorn is the national animal of Scotland?",
        "There's enough gold in Earth's core to coat its entire surface in about 1.5 feet of gold?",
        "A single rainforest can produce 20% of the Earth's oxygen?",
        "You can't create a folder named 'CON' on a Windows computer?"
    ]
    
    func report(_ message: String) {
        Firestore.firestore().collection("reportedConnectUsers").document().setData(["reportedID":"", "reason":message, "reporterID":user.id])
    }

    func removeFromWaitingRoom() {
        db.collection("connectUsers").document(user.id).updateData(["currentChatRoom":FieldValue.delete()])
    }
    func fetchConnectedUser(_ id: String) {
        Firestore.firestore().collection("connectUsers").document(id).getDocument { snapshot, error in
            if let _ = error {
                self.connectionState = .searching
            }
            if let snapshot, let data = snapshot.data() {
                let user = ConnectUser.transformConnectUser(id: snapshot.documentID, data: data)
                self.connectedUser = user
            }
        }
    }
    
    func cleanAll() {
        if let currentChatId {
            db.collection("chatRooms").document(currentChatId).delete()
            self.currentChatId = nil
        }
        Task {
            await manager.leaveChannel { _ in
                //
            }
        }
        db.collection("waitingRoom").document(user.id).delete()
        listener?.remove()
        listener = nil
    }
    
    func addToWaitingRoom() {
        let data: [String: Any] = ["id": user.id, "name": user.name, "timestamp": Timestamp(date: Date()), "email": user.email, "country": user.country]
        if !userId.isEmpty {
            db.collection("waitingRoom").document(userId).setData(data)
//            connectionState = .searching
        }
    }
    
    func listenForChatRoomUpdates() {

        let userDocRef = db.collection("chatRooms").whereField("userIds", arrayContains: user.id)
//        self.connectionState = .searching
        listener = userDocRef.addSnapshotListener { (snapshot, error) in
            
            print("we are here")

            guard let snapshot, !snapshot.documents.isEmpty else {
//                print("Error fetching document: \(error!)")
             
                if self.connectionState == .connected {
                    self.connectionState = .searching
                }
                return
            }
            print("we are here 2")
            self.connectionState = .connecting

            if let document = snapshot.documents.first, let users = document.data()["users"] as? [[String: Any]] {
                let cUsers = users.map { data in
                    return ConnectUser.transformConnectUser(id: "", data: data)
                }
                let user = cUsers.first(where: { $0.id != self.user.id })
                self.connectedUser = user
//                self.fetchChatRoom(id: currentChatRoom)
                self.currentChatId = document.documentID
                self.connectionState = .connected

                Task {
                    await self.manager.joinChannel(token: document.data()["token"] as? String ?? "", channel: document.documentID) { joined in
                        if joined {
                            self.connectionState = .connected
                        }
                    }
                }
            }
            
            
//            print("User has been assigned to chat room \(currentChatRoom)")

           
            
            // Proceed to chat interface, perhaps?
        }
    }

//    func fetchChatRoom(id: String) {
//        let chatRoomRef = db.collection("chatRooms").document(id)
//        
//        chatRoomRef.getDocument { snapshot, error in
//            if let error {
//                
//            }
//            
//            if let snapshot, let data = snapshot.data(), let token = data["token"] as? String {
//                Task {
//                    await self.manager.joinChannel(token: token, channel: id) { joined in
//                        if joined {
//                            self.connectionState = .connected
//                        }
//                    }
//                }
//            }
//        }
//
//    }
//    
    
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

struct LoadingView: View {
    
    var body: some View {
        LottieView(name: "Searching")
    }
}
