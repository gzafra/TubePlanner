//
//  ShapeFactory.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 20/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

final class ShapeFactory {
    
    /// Returns a CAShapeLayer line from given points with specific color. Fixed width to 1.6
    static func line(fromPoint start: CGPoint, toPoint end:CGPoint, color: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.lineWidth = 6
        line.opacity = 1.0
        line.strokeColor = color.cgColor
        return line
    }
    
    /// Returns a CAShapeLayer circle for a given position, radious and color. Always filled
    static func circle(atPosition position: CGPoint, radious: CGFloat, color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: position, radius: radious, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 3.0
        return shapeLayer
    }
}
