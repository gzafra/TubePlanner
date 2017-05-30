//
//  FirstViewController.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import UIKit

private let cellIdentifier = "StationCell"

class RoutePlannerViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var originSearchBar: UISearchBar!
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var planRouteButton: UIBarButtonItem!
    
    // MARK: - Properties
    var stationNames: [String]? {
        didSet{
            if let stationNames = stationNames {
                self.stationNames = Array(Set(stationNames.sorted()))
            }
        }
    }
    var filteredNames: [String] = []
    var currentRoute: Route?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let stationNames = stationNames else {
            assertionFailure("Station names not properly set in RoutePlannerViewController")
            return
        }

        filteredNames = stationNames
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkValidFields()
    }
    
    func calculateRouteFrom(_ sourceStation: String, to destination: String) -> Bool {
        guard sourceStation != destination else {
            self.showOkAlertWith(title: "Ummm", message: "You are already there. For free! \n\n Please select different stations to plan another route.")
            return false
        }
        
        guard let route = DataManager.shared.graphMap.calculateRouteFrom(sourceStation, to: destination) else {
            self.showOkAlertWith(title: "Oops", message: "It seems there is no route available at the moment for the stations selected.")
            return false
        }
        
        currentRoute = route
        
        return true
    }
    
    // MARK: - IBActions
    @IBAction func calculateRouteTapped(_ sender: Any) {
        guard let originStation = originSearchBar.text,
            let destinationStation = destinationSearchBar.text else {
                return
        }
        
        if calculateRouteFrom(originStation, to: destinationStation) {
            SegueKey.showRoute.perform(from: self)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! RouteResultViewController
        resultViewController.route = currentRoute
    }
    
    fileprivate func checkValidFields() {
        var allFieldsValid = false
        if let originStation = originSearchBar.text, !originStation.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty,
            let destinationStation = destinationSearchBar.text, !destinationStation.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty {
            allFieldsValid = true
        }
        
        planRouteButton.isEnabled = allFieldsValid
    }
}

// MARK: - UITableViewDelegate
extension RoutePlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stationName = filteredNames[indexPath.row]
        
        if destinationSearchBar.isFirstResponder {
            destinationSearchBar.text = stationName
            
            guard let originStation = originSearchBar.text,
                let destinationStation = destinationSearchBar.text else {
                    return
            }
            
            if calculateRouteFrom(originStation, to: destinationStation) {
                SegueKey.showRoute.perform(from: self)
            }
            
        }else{
            originSearchBar.text = stationName
            destinationSearchBar.becomeFirstResponder()
        }
    }
}

// MARK: - UITableViewDataSource
extension RoutePlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = filteredNames[indexPath.row]

        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UISearchBarDelegate
extension RoutePlannerViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filteredNames = stationNames!
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredNames = stationNames!
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
        checkValidFields()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredNames = stationNames!
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNames = stationNames!.filter({ name in
            return name.localizedCaseInsensitiveContains(searchText)
        })

        if searchText.isEmpty {
            filteredNames = stationNames!
        }
        
        checkValidFields()
        
        self.tableView.reloadData()
    }
}
