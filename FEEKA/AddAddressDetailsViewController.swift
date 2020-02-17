//
//  AddAddressDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddAddressDetailsViewController: UIViewController, CLLocationManagerDelegate ,MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var defaultCheckBox: UIButton!
    
    var isDefault = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func womenCheckBoxAction(_ sender: Any) {
           if isDefault {
               
           defaultCheckBox.setImage(#imageLiteral(resourceName: "3"), for: .normal)
               isDefault = false
               
           } else {
               
               isDefault = true
               defaultCheckBox.setImage(nil, for: .normal)
           }
       }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: -28.4792625, longitudeDelta:  24.6727135))
            self.map.setRegion(region, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
