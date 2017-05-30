//
//  RootTabBarViewController.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 20/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Inject data into ViewControllers from DataManager
        let routePlannerViewController = self.viewControllers?.first?.childViewControllers.first as! RoutePlannerViewController
        routePlannerViewController.stationNames = DataManager.shared.graphMap.stationsArray.map({ station in return station.name })
        let mapViewController = self.viewControllers?.last as! MapViewController
        mapViewController.stationsData = DataManager.shared.graphMap.stationsArray
        mapViewController.edgesData = DataManager.shared.graphMap.edges
    }
}
