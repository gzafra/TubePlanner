//
//  UIKitFactory.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 21/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

class UIKitFactory {
    
    /// Creates and returns a label with given text, position, size and weight (default to 1)
    static func label(withTitle labelText: String, position: CGPoint, size: CGFloat, weight: CGFloat = 1) -> UILabel {
        let label = UILabel(frame: CGRect(x: position.x, y: position.y, width: 200, height: size + 2))
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = .black
        label.textAlignment = .left
        label.text = labelText
        return label
    }
    
}
