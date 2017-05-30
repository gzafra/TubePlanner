//
//  UIViewControllerExtensions.swift
//  TubePlanner
//
//  Created by Guillermo Zafra on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Shows a standard alert view with title, message and an ok button. Callback optional.
    func showOkAlertWith(title titleString: String, message: String, actionBlock: (() -> ())? = nil) {
        let alert: UIAlertController = UIAlertController(title: titleString, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style:.cancel) { (action) -> Void in
            actionBlock?()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

