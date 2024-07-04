//
//  SecondViewController.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

private let gridSize: (cols: CGFloat, rows: CGFloat) = (16,10)

class MapViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var canvasView: UIView!
    
    var stationsData: [Station]?
    var edgesData: [Edge]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let stations = stationsData, let edges = edgesData else {
            assertionFailure("Stations data not properly set in MapViewController")
            return
        }

        renderMap(stations, withEdges: edges)
        
        // Setup scrollview
        scrollView.contentSize = canvasView.frame.size
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.45
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleDoubleTap(sender: UITapGestureRecognizer?) {
        guard let recognizer = sender else {
            return
        }
        
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = canvasView.frame.size.height / scale
        zoomRect.size.width  = canvasView.frame.size.width  / scale
        let newCenter = canvasView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    // MARK: - Rendering
    
    func renderMap(_ stations: [Station], withEdges edges: [Edge]) {
        var circles = [CAShapeLayer]()
        var lines = [CAShapeLayer]()
        var labels = [UILabel]()

        // Render stations and labels
        for station in stations {
            let position = positionForLoc(x: CGFloat(station.location.x), y: CGFloat(station.location.y))
            let circle = ShapeFactory.circle(atPosition: position, radious: 6, color: station.line.uiColor)
            circles.append(circle)

            // Add station name
            let label = UIKitFactory.label(withTitle: station.name, position: CGPoint(x: position.x + 12, y: position.y), size: 10)
            label.rotateBy(30)
            labels.append(label)
        }
        
        // Render lines between stations
        for edge in edges {
            let startPosition = positionForLoc(x: CGFloat(edge.source.location.x), y: CGFloat(edge.source.location.y))
            let endPosition = positionForLoc(x: CGFloat(edge.destination.location.x), y: CGFloat(edge.destination.location.y))
            let line  = ShapeFactory.line(fromPoint: startPosition, toPoint: endPosition, color: edge.source.line.uiColor)
            lines.append(line)
        }
        
        lines.forEach({ line in canvasView.layer.addSublayer(line) })
        circles.forEach({ circle in canvasView.layer.addSublayer(circle) })
        labels.forEach({ label in canvasView.addSubview(label)})
    }
    
    /// Returns the absolute position in the canvas for the given coords based on a delimited grid
    func positionForLoc(x: CGFloat, y: CGFloat) -> CGPoint {
        let verticalSpacing = (canvasView.frame.height - canvasView.frame.width)
        let availableSpace = CGSize(width: canvasView.frame.width,
                                    height: canvasView.frame.height - verticalSpacing)
        let unitSize = CGSize(width: availableSpace.width / gridSize.cols,
                              height: availableSpace.height / gridSize.rows)
        
        return CGPoint(x: 6 + (x * unitSize.width),
                       y: verticalSpacing / 2 + (y * unitSize.height))
    }
}

// MARK: - UIScrollViewDelegate

extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollView.subviews[0]
    }
}

// MARK: - Label presentation extensions

private extension UILabel {
    func rotateBy(_ degrees: CGFloat) {
        let shift = CGAffineTransform(translationX: self.frame.size.width/2,y: self.frame.size.height/2);
        let rotation = CGAffineTransform(rotationAngle: degrees.degreesToRadians)
        let shiftBack = CGAffineTransform(translationX: -self.frame.size.width/2,y: -self.frame.size.height/2);
        let transform = shift.concatenating(rotation).concatenating(shiftBack);
        
        self.transform = self.transform.concatenating(transform)
    }
}
