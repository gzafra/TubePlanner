//
//  Station.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

typealias Location = (x: Int, y: Int)

public func == (left: Station, right: Station) -> Bool {
    return left.name == right.name
}

enum Line: String {
    case black = "blackline"
    case blue = "blueline"
    case green = "greenline"
    case red = "redline"
    case yellow = "yellowline"
}

public class Station {
    let stationId: String!
    let name: String!
    let location: Location!
    var neighbours = [Edge]()
    let line: Line
    
    init(jsonData: [String: AnyObject]) throws {
        guard let stationId = jsonData["id"] as? String,
            let name = jsonData["name"] as? String,
            let xLoc = jsonData["x"] as? Int,
            let yLoc = jsonData["y"] as? Int,
            let lineString = jsonData["line"] as? String,
            let lineEnum = Line(rawValue: lineString) else {
                throw JsonErrors.invalidJson
        }
        
        self.stationId = stationId
        self.name = name
        self.location = Location(x: xLoc, y: yLoc)
        self.line = lineEnum
    }
    
    init(id: String, name: String, location: Location, line: Line) {
        self.stationId = id
        self.name = name
        self.location = location
        self.line = line
    }
}

