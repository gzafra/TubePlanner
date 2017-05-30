//
//  StoryboardUtils.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

enum SegueKey: String {
    case showRoute = "ShowRoute"
    
    func perform(from vc: UIViewController) {
        vc.performSegue(withIdentifier: self.rawValue, sender: nil)
    }
}
