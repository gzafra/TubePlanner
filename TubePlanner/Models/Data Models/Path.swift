//
//  Path.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

class Path {
    var totalCost: Int!
    var totalDuration: Int!
    var destination: Station!
    var previous: Path!
    var totalChanges: Int!
    
    var trail: [Station] {
        var visitedNodes = [Station]()
        var currentPath: Path? = self
        while currentPath != nil {
            visitedNodes.append(currentPath!.destination)
            currentPath = currentPath!.previous
        }
        return visitedNodes.reversed()
    }
}
