//
//  RouteResultViewController.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

private let nodeHeight: CGFloat = 12
private let verticalSpacing: CGFloat = 40

class RouteResultViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var stationsLabel: UILabel!
    @IBOutlet weak var canvasView: UIView!
    
    // MARK: - Properties
    var route: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let route = route else {
            assertionFailure("Cannot load RouteResultViewController without a valid route")
            return
        }
        
        minutesLabel.text = "\(route.duration)"
        costLabel.text = "\(route.cost)$"
        stationsLabel.text = "\(route.stops)"
        
        renderRoute(route)
    }
    
    // MARK: - Rendering
    
    /// Renders all stations in the route with circles and lines
    func renderRoute(_ route: Route) {
        
        let availableHeight = canvasView.frame.height - verticalSpacing - (nodeHeight * CGFloat(route.stations.count))
        let spacePerUnit = availableHeight / CGFloat(route.stations.count)
        
        
        var currentYOffset = verticalSpacing / 2
        let currentXOffset = canvasView.frame.width * 0.2
        
        var circles = [CAShapeLayer]()
        var lines = [CAShapeLayer]()
        var labels = [UILabel]()
        
        var prevStation: Station! = nil
        
        for station in route.stations {
            // Check if station line has not changed to render a line
            if prevStation != nil && station.line == prevStation.line {
                currentYOffset -= nodeHeight / 2
                let line = ShapeFactory.line(fromPoint: CGPoint(x: currentXOffset, y: currentYOffset) ,
                                             toPoint: CGPoint(x: currentXOffset, y:currentYOffset + spacePerUnit + nodeHeight / 2),
                                             color: prevStation.line.uiColor)
                currentYOffset += spacePerUnit
                lines.append(line)
            }
            
            
            // Always draw station for first or last stations
            if (station == route.stations.last! || station == route.stations.first!) {
                currentYOffset += nodeHeight
                
                let circle = ShapeFactory.circle(atPosition: CGPoint(x: currentXOffset, y: currentYOffset), radious: nodeHeight/2, color: station.line.uiColor)
                circles.append(circle)
                
                labels.append(UIKitFactory.label(withTitle: station.name, position: CGPoint(x: canvasView.frame.width * 0.3 , y: currentYOffset - 8), size: 14, weight: 2))
                
                currentYOffset += nodeHeight
                
            } else if (station.line != prevStation.line) { // Draw the 2 stations when switching lines
                currentYOffset += nodeHeight
                let prevCircle = ShapeFactory.circle(atPosition: CGPoint(x: currentXOffset, y: currentYOffset), radious: nodeHeight/2, color: prevStation.line.uiColor)
                circles.append(prevCircle)
                currentYOffset += nodeHeight
                

                labels.append(UIKitFactory.label(withTitle: "Change at: \(station.name!)", position: CGPoint(x: canvasView.frame.width * 0.3 , y: currentYOffset - 8), size: 14, weight: 2))
                
                currentYOffset += nodeHeight
                let circle = ShapeFactory.circle(atPosition: CGPoint(x: currentXOffset, y: currentYOffset), radious: nodeHeight/2, color: station.line.uiColor)
                currentYOffset += nodeHeight
                circles.append(circle)
            }
            prevStation = station
        }
        
        lines.forEach({ line in canvasView.layer.addSublayer(line) })
        circles.forEach({ circle in canvasView.layer.addSublayer(circle) })
        labels.forEach({ label in canvasView.addSubview(label)})
    }
}
