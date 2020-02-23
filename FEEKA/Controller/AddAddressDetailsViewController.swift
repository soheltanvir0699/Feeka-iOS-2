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
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class AddAddressDetailsViewController: UIViewController, CLLocationManagerDelegate ,MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var defaultCheckBox: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var sureNameLbl: UITextField!
    @IBOutlet weak var contactNumberLbl: UITextField!
    @IBOutlet weak var companyLbl: UITextField!
    @IBOutlet weak var streetAddressLbl: UITextField!
    @IBOutlet weak var suburbLbl: UITextField!
    @IBOutlet weak var cityLbl: UITextField!
    @IBOutlet weak var postcodeLbl: UITextField!
    
    var name = ""
    var sureName = ""
    var phone = ""
    var country = ""
    var streetAdd = ""
    var suburb = ""
    var city = ""
    var postalCode = ""
    var isDefault = true
    var company = ""
    var indicator:NVActivityIndicatorView!
    let userdefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navView.setShadow()
        setUPView()
    }
    
    func setUPView() {
        nameLbl.text = name
        sureNameLbl.text = sureName
        contactNumberLbl.text = phone
        streetAddressLbl.text = streetAdd
        suburbLbl.text = suburb
        cityLbl.text = city
        postcodeLbl.text = postalCode
        companyLbl.text = company
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
        var customerId = ""
        indicator = self.indicator()
        guard let url = URL(string: "https://feeka.co.za/json-api/route/add_address.php") else {
                           self.view.makeToast( "Please try again later")
                              return
                          }
        if userdefault.value(forKey: "customer_id") != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        if nameLbl.text == "" || suburbLbl.text == "" || sureNameLbl.text == "" || contactNumberLbl.text == "" || streetAddressLbl.text == "" || cityLbl.text == "" || postcodeLbl.text == "" || companyLbl.text == "" {
            self.view.makeToast("Please Enter Correct Value")
            return
        } else if (contactNumberLbl.text)?.count != 10 {
            self.view.makeToast("Phone Number Is Invalid")
            return
        } else {
                          
                              let paramater = [
                                 "address_id": "",
                                 "customer_id": "\(customerId)",
                                "Name": "\(nameLbl.text!)",
                                "Surname": "\(sureNameLbl.text!)",
                                 "Unit_Number": "",
                                 "Apartment": "",
                                 "Company": "\(companyLbl.text!)",
                                "Street_Address": "\(streetAddressLbl.text!)",
                                "Suburb": "\(suburbLbl.text!)",
                                 "Country": "South Africa",
                                 "Postal_Code": "\(postcodeLbl.text!)",
                                "City": "\(cityLbl.text!)",
                                "Contact_Number": "\(contactNumberLbl.text!)",
                                 "is_default":"0"
                                 ]
        
                              Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: nil).response { (response) in
                                  self.indicator.startAnimating()
                                  if let error = response.error {
                                      self.indicator.stopAnimating()
                                      let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                                      self.present(alertView, animated: true, completion: nil)
                                      print(error)
                                      
                                  }
                                  
                                  if let result = response.data {
                                      let jsonRespose = JSON(result)
                                     
                                      if jsonRespose["status"].stringValue == "1" {
                                        self.navigationController?.popViewController(animated: true)
                                      } else {
                                        
                                        self.view.makeToast("Something Wrong")
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: -28.4792625, longitudeDelta:  24.6727135))
            self.map.setRegion(region, animated: true)
        }
    }
}
