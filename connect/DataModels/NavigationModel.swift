//
//  NavigationModel.swift
//  connect
//
//  Created by Denzel Nyatsanza on 8/9/23.
//

import SwiftUI

class NavigationModel: ObservableObject {
    @Published var path: NavigationPath = .init()
}
