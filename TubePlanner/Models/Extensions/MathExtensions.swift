//
//  MathExtensions.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 20/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
