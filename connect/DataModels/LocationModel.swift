//
//  LocationModel.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

import SwiftUI

enum POIType: String {
    case transport = "transport", fun = "fun", finance = "finance", food = "food", drinks = "drinks", vehicles = "vehicles", emergency = "emergency", fitness = "fitness", medical = "medical", accommodation = "accommodation", school = "school", general = "general"
}

struct POICategory: Identifiable, Equatable {
    var id: String {
        return name
    }
    var type: POIType
    var name: String {
        return type.rawValue.capitalized
    }
    var imageName: String {
        return type.rawValue.capitalized
    }
    var subCatgories: [MKPointOfInterestCategory] {
        return switch type {
        case .transport:
            [.airport, .marina, .parking, .publicTransport]
        case .fun:
            [.amusementPark, .aquarium, .campground, .movieTheater, .museum, .park, .nationalPark, .nightlife, .theater, .zoo, .restaurant]
        case .finance:
            [.atm, .bank]
        case .food:
            [.bakery, .foodMarket, .store]
        case .drinks:
            [.brewery, .cafe, .winery]
        case .vehicles:
            [.carRental, .evCharger]
        case .emergency:
            [.fireStation, .police]
        case .fitness:
            [.fitnessCenter]
        case .medical:
            [.hospital, .pharmacy]
        case .accommodation:
            [.hotel]
        case .school:
            [.university, .school]
        case .general:
            [.laundry, .library, .restroom, .stadium, .postOffice]
        }
      
    }
    
    var naturalLanguaryQuery: [String] {
        return switch self.type {
        case .transport:
            ["Transport"]
        case .fun:
            ["Things to do"]
        case .finance:
            ["Bank", "Atm"]
        case .food:
            ["Groceries"]
        case .drinks:
            ["Coffee", "Drinks"]
        case .vehicles:
            ["Car rental", "EV"]
        case .emergency:
            ["Police"]
        case .fitness:
            ["Gym"]
        case .medical:
            ["Hospital"]
        case .accommodation:
            ["Hotel"]
        case .school:
            ["School", "College"]
        case .general:
            ["Laundry", "Library"]
        }
    }
    
    static var allCases: [Self] = [.init(type: .accommodation),
                                   .init(type: .drinks),
                                   .init(type: .emergency),
                                   .init(type: .finance),
                                   .init(type: .fitness),
                                   .init(type: .food),
                                   .init(type: .fun),
                                   .init(type: .general),
                                   .init(type: .medical),
                                   .init(type: .school),
                                   .init(type: .transport),
                                   .init(type: .vehicles)]
}

struct LocationItem: Identifiable {
    var id = UUID().uuidString
    var item: MKMapItem
    var name: String {
        item.name ?? "Unknown Name"
    }
    var itemCategory: String {
        return item.pointOfInterestCategory?.rawValue ?? ""
    }
    var imageName: String {
        return category.imageName
    }
    var category: POICategory {
        
        switch item.pointOfInterestCategory {
            // transport
        case .airport?, .marina?, .parking?, .publicTransport?:
            return .init(type: .transport)
            // fun
        case .amusementPark?, .aquarium?, .campground?, .movieTheater?, .museum?, .park?, .nationalPark?, .nightlife?, .theater?, .zoo?, .restaurant?:
            return .init(type: .fun)
            // finance
        case .atm?, .bank?:
            return .init(type: .finance)

            // food
        case .bakery?, .foodMarket?, .store?:
            return .init(type: .food)

            // drinks
        case .brewery?, .cafe?, .winery?:
            return .init(type: .drinks)
            // vehicles
        case .carRental?, .evCharger?:
            return .init(type: .vehicles)

            // emergency
        case .fireStation?, .police?:
            return .init(type: .emergency)
            // fitness
        case .fitnessCenter?:
            return .init(type: .fitness)

            // medical
        case .hospital?, .pharmacy?:
            return .init(type: .medical)

            // accomodation
        case .hotel?:
            return .init(type: .accommodation)

            // general
        case .laundry?, .library?, .restroom?, .stadium?, .postOffice?:
            return .init(type: .general)

            // schools
        case .university?, .school?:
            return .init(type: .school)
        default:
            return .init(type: .fun)

        }
    }
}

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocation? {
        didSet {
            if let location = self.userLocation {
                self.region = .init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            }
        }
    }
    
    @Published var results: [LocationItem] = []
    @Published var region: MKCoordinateRegion = .init()
    @Published var selectedCategory: POICategory = .init(type: .fun) {
        didSet {
            results.removeAll()
        }
    }
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func retrieveGroceries() {
//        let searches = ["restaurant", "coffee", "hospital", "natural history museum"]
        let searches = selectedCategory.naturalLanguaryQuery
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        if let coordinate = userLocation?.coordinate {
            for (i, searchText) in searches.enumerated() {
                queue.addOperation(SearchOperation(identifier: i, searchText: searchText, region: MKCoordinateRegion(center: coordinate, span: .init())) { items in
                    withAnimation(.easeInOut) {
                        self.results.append(contentsOf: items.map { .init(item: $0) })
                    }
                })
            }
            
            queue.addOperation {
               
            }
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
//                retrieveGroceries()
        print(#function, location)
    }
    
    
    
}

class SearchOperation: AsynchronousOperation {
    let identifier: Int
    let searchText: String
    let region: MKCoordinateRegion
    var completion: ([MKMapItem]) -> ()
    init(identifier: Int, searchText: String, region: MKCoordinateRegion, completion: @escaping([MKMapItem])->Void) {
        self.identifier = identifier
        self.searchText = searchText
        self.region = region
        self.completion = completion
        super.init()
    }
    
    

    override func main() {
        print("%d started", identifier)

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region

        if #available(iOS 13, *) {
            request.resultTypes = .pointOfInterest
        }

        let search = MKLocalSearch(request: request)

        search.start { response, error in
            defer { self.finish() }

            guard let mapItems = response?.mapItems else {
                print("  %d failed", self.identifier)
                return
            }
            self.completion(mapItems)
            print("  %d succeeded, found %d:", self.identifier, mapItems.count)
        }
    }
    
}

class AsynchronousOperation: Operation {
    
    /// State for this operation.
    
    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    /// Concurrent queue for synchronizing access to `state`.
    
    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
    
    /// Private backing stored property for `state`.
    
    private var rawState: OperationState = .ready
    
    /// The state of the operation
    
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }
    
    // MARK: - Various `Operation` properties
    
    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    
    // KVO for dependent properties
    
    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    // Start
    
    public final override func start() {
        if isCancelled {
            finish()
            return
        }
        
        state = .executing
        
        main()
    }
    
    /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.
    
    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }
    
    /// Call this function to finish an operation that is currently executing
    
    public final func finish() {
        if !isFinished { state = .finished }
    }
}

class DownloadOperation : AsynchronousOperation {
    var task: URLSessionTask!
    
    init(session: URLSession, url: URL) {
        super.init()
        
        task = session.downloadTask(with: url) { temporaryURL, response, error in
            defer { self.finish() }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode
            else {
                // handle invalid return codes however you'd like
                return
            }

            guard let temporaryURL = temporaryURL, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            do {
                let manager = FileManager.default
                let destinationURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(url.lastPathComponent)
                try? manager.removeItem(at: destinationURL)                   // remove the old one, if any
                try manager.moveItem(at: temporaryURL, to: destinationURL)    // move new one there
            } catch let moveError {
                print("\(moveError)")
            }
        }
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
    
}
