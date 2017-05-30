//
//  DrawingExtensions.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 20/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

extension Line {
    var uiColor: UIColor {
        switch self {
        case Line.black:
            return .black
        case Line.blue:
            return .blue
        case Line.green:
            return .green
        case Line.red:
            return .red
        case Line.yellow:
            return .yellow
        }
    }
}
