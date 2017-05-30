//
//  Route.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

private let staticDuration = 5

struct Route {
    let stations: [Station]!
    let cost: Int // TODO: This might be better off being a double
    let duration: Int
    let stops: Int
    
    init(source: Station, path: Path) {
        var stations = [Station]()
        let trail = path.trail
        stations.append(source)
        stations.append(contentsOf: trail)
        self.stations = stations
        self.cost = path.totalCost
        self.stops = trail.count - path.totalChanges
        self.duration = path.totalDuration
    }
}
