//
//  RoutePlanner.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

class GraphMap {
    var stations = [String: Station]()
    var stationsArray: [Station] {
        return Array(stations.values)
    }
    var edges = [Edge]()
    
    // MARK: - Utility methods
    
    func stationForName(_ stationName: String) -> [Station] {
        return stationsArray.filter({ station in station.name.contains(stationName)})
    }

    func addEdge(_ edge: Edge) {
        edge.source.neighbours.append(edge)
        edge.destination.neighbours.append(edge)
        edges.append(edge)
    }
    
    // MARK: - Path search methods
    
    /// Calculates the cheapest route from station to station. Parameters are Station names
    func calculateRouteFrom(_ sourceName: String, to destinationName: String) -> Route? {
        let possibleSourceStations = self.stationForName(sourceName)
        let possibleDestinationStations = self.stationForName(destinationName)
        
        // Check there are stations matching provided names
        if possibleSourceStations.count == 0 || possibleDestinationStations.count == 0 {
            return nil
        }
        
        /* Since stations with more than one line are processed as different:
           For multiple destination stations the own algorithm will get the shortest path automatically
           For multiple source stations we have to process for each of them.
           The reason for this is that it might make sense to also calculate station interchange time later on and
           at the moment performance is not an issue
         */
        
        var optimalRoute: Route?
        
        for startStation in possibleSourceStations {
            guard let newPath = calculatePathFrom(startStation, to: possibleDestinationStations.first!) else {
                continue
            }
            if optimalRoute == nil || newPath.totalCost < optimalRoute!.cost {
                optimalRoute = Route(source: startStation, path: newPath)
            }
        }

        return optimalRoute
    }
    
    /// Calculate cheapest path from station to station. Parameters are Station instances
    private func calculatePathFrom(_ source: Station, to destination: Station) -> Path? {
        var pathsToEvaluate = [Path]()
        var finalBestPath: Path? = nil
        var visitedStations = [Station]()
        
        // Create frontier using source station
        pathsToEvaluate.append(contentsOf: pathsFromStation(source))
        visitedStations.append(source)
        
        var bestPath = Path()
        
        while pathsToEvaluate.count != 0 {
            
            // Sort by total (cheapest first)
            pathsToEvaluate = pathsToEvaluate.sorted(by: { (path1, path2) -> Bool in
                return path1.totalCost < path2.totalCost
            })
            
            // Remove cheapest path to evaluate
            bestPath = pathsToEvaluate.removeFirst()
            
            // Get new paths filtering out those already contained with higher or equal total cost
            let newPaths = pathsFromStation(bestPath.destination, currentPath: bestPath).filter({ (path) -> Bool in
                return !pathsToEvaluate.contains(where: {path.destination.stationId == $0.destination.stationId && path.totalCost >= $0.totalCost })
            }).filter({ path in // Filter out already visited station
                return !visitedStations.contains(where: { path.destination.stationId == $0.stationId })
            })
            
            // Filter out paths already in the list that are worst than the new ones
            pathsToEvaluate = pathsToEvaluate.filter({ (path) -> Bool in
                return !newPaths.contains(where: {path.destination == $0.destination && path.totalCost > $0.totalCost })
            })
            
            // Add new paths to evaluate
            pathsToEvaluate.append(contentsOf: newPaths)
            
            // If current bestPath leads to destination, add it as final
            if destination == bestPath.destination && (finalBestPath == nil || bestPath.totalCost < finalBestPath!.totalCost) {
                finalBestPath = bestPath
            }
            
            visitedStations.append(bestPath.destination)
        }
        
        return finalBestPath
    }
    
    /// Returns the resulting paths from a given station to all it's edges. If a currentPath is added it will add its accumulated cost
    private func pathsFromStation(_ station: Station, currentPath: Path? = nil) -> [Path] {
        var paths = [Path]()
        
        // Create path for each of the edges
        for edge in station.neighbours {
            let newPath = Path()
            
            // Destination depends on the direction. If source stations matches the station we are checking paths from then it's forwards, otherwise it'd be backwards
            newPath.destination = edge.source!.stationId == station.stationId ? edge.destination : edge.source
            newPath.previous = currentPath
            newPath.totalCost = (currentPath?.totalCost ?? 0) + edge.cost
            newPath.totalDuration = (currentPath?.totalDuration ?? 0) + edge.duration
            newPath.totalChanges = (currentPath?.totalChanges ?? 0) + (newPath.destination == station ? 1 : 0)
            
            paths.append(newPath)
        }
        return paths
    }
}
