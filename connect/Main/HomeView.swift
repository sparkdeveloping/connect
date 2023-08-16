//
//  HomeView.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

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

