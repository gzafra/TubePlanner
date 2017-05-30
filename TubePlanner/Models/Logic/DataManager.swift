//
//  DataManager.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static var shared = DataManager()
    
    var graphMap = GraphMap()
    
    // Loading methods
    func loadData(_ data: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()),
            let dictionary = object as? [String: AnyObject] else {
                assertionFailure("Failed to parse data from mock file.")
                return
        }
        
        // Parse stations
        if let stationsDictionary = dictionary["stations"] as? [[String: AnyObject]] {
            for stationData in stationsDictionary {
                do {
                    let newStation = try Station(jsonData: stationData)
                    graphMap.stations[newStation.stationId] = newStation
                } catch  {
                    print("Error parsing Station item. Skipping.")
                }
            }
        }
        
        // Parse edges
        if let edgesDictionary = dictionary["edges"] as? [[String: AnyObject]] {
            for edgeData in edgesDictionary {
                do {
                    let newEdge = try Edge(jsonData: edgeData)
                    
                    guard let sourceStation = graphMap.stations[newEdge.sourceId],
                        let destinationStation = graphMap.stations[newEdge.destinationId] else {
                            assertionFailure("Invalid destination and/or source stations ids: \(newEdge.destinationId) \(newEdge.sourceId)")
                            continue
                    }
                    
                    newEdge.destination = destinationStation
                    newEdge.source = sourceStation
                    
                    graphMap.addEdge(newEdge)
                } catch  {
                    print("Error parsing Station item. Skipping.")
                }
            }
        }
    }
}

// MARK: Offline Data loading
extension DataManager {
    static var offlineData: Data? {
        guard let path = Bundle.main.path(forResource: "offlineData", ofType: "json") else {
            assertionFailure("Invalid filename/path.")
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            assertionFailure("Failed to load data from path: \(path)")
            return nil
        }
        
        return data
    }
}
