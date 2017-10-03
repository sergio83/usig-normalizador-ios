//
//  ViewController.swift
//  Example
//
//  Created by Rita Zerrizuela on 9/28/17.
//  Copyright © 2017 GCBA. All rights reserved.
//

import UIKit
import CoreLocation
import USIGNormalizador

class ViewController: UIViewController {
    fileprivate let locationManager = CLLocationManager()
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var geoLabel: UILabel!
    @IBOutlet weak var geoButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        let search = USIGNormalizador.search()
        let navigationController = UINavigationController(rootViewController: search)
        
        search.delegate = self
        search.maxResults = 10
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func geoButtonTapped(sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchLabel.sizeToFit()
        geoLabel.sizeToFit()
    }
    
    // MARK: - Location
    
    fileprivate func requestLocation() {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse, let currentLocation = locationManager.location else { return }
        
        USIGNormalizador.location(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { result, error in
            DispatchQueue.main.async { [unowned self] in
                self.geoLabel.text = result?.address ?? error?.message
            }
        }
    }
}

extension ViewController: USIGNormalizadorControllerDelegate {
    func didChange(_ search: USIGNormalizadorController, value: USIGNormalizadorAddress) {
        DispatchQueue.main.async { [unowned self] in
            self.searchLabel.text = value.address
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocation()
    }
}
