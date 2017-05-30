//
//  Edge.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

class Edge {
    let edgeId: String!
    var destination: Station!
    let destinationId: String!
    var source: Station!
    let sourceId: String
    let cost: Int!
    let duration: Int!
    
    init(jsonData: [String: AnyObject]) throws {
        guard let id = jsonData["id"] as? String,
            let source = jsonData["source"] as? String,
            let target = jsonData["target"] as? String,
            let cost = jsonData["cost"] as? Int,
            let duration = jsonData["duration"] as? Int else {
                throw JsonErrors.invalidJson
        }
        
        self.edgeId = id
        self.sourceId = source
        self.destinationId = target
        self.cost = cost
        self.duration = duration
    }
}
