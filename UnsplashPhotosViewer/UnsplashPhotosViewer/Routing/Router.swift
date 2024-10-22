//
//  Router.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 18/10/24.
//

import SwiftUI

// MARK: - Router

class Router<Route: Hashable>: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
