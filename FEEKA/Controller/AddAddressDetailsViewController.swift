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
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

class AddAddressDetailsViewController: UIViewController, CLLocationManagerDelegate ,MKMapViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var countryname: UITextField!
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
    var addressId = ""
    var isAddress = true
    var  isDefaultAdd = true
    var  defaultCount = 0
    var indicator:NVActivityIndicatorView!
    let userdefault = UserDefaults.standard
    var datePicker = UIDatePicker()
    var urlLink = "https://feeka.co.za/json-api/route/add_address.php"
     let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        cityLbl.delegate = self
        streetAddressLbl.delegate = self
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        navView.setShadow()
        setUPView()
        hideKeyBoard()
    }
    
   
    
    @IBAction func defaultAction(_ sender: Any) {
        if isDefaultAdd {
            defaultCheckBox.setImage(UIImage(named: "3"), for: .normal)
            self.defaultCount = 1
            isDefaultAdd = false
            
        } else {
            self.defaultCount = 0
            defaultCheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
            isDefaultAdd = true
        }
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
        
        dismiss(animated: true, completion: nil)
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
        guard let url = URL(string: urlLink) else {
                           self.view.makeToast( "Please try again later")
                              return
                          }
        if userdefault.value(forKey: "customer_id") != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        if nameLbl.text == "" || suburbLbl.text == "" || sureNameLbl.text == "" || contactNumberLbl.text == "" || streetAddressLbl.text == "" || cityLbl.text == "" || postcodeLbl.text == "" {
            self.view.makeToast("Empty Field")
            return
        } else if (contactNumberLbl.text)?.count != 10 {
            self.view.makeToast("Phone Number Is Invalid")
            return
        } else {
            
                          
                              let paramater = [
                                 "address_id": "\(addressId)",
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
                                 "is_default":"\(defaultCount)"
                                 ]
        
                               print(paramater)
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
                                     print(jsonRespose)
                                      if jsonRespose["status"].stringValue == "1" {
                                        StoredProperty.indexSelectedAddressList = [getCustomerDataModel]()
                                        StoredProperty.indexSelectedAddressList.append(getCustomerDataModel(addressId: self.addressId, customerId: customerId, name: self.nameLbl.text!, surname: self.sureNameLbl.text!, apartment: "", company: self.companyLbl.text!, street: self.streetAddressLbl.text!, suburb: self.suburbLbl.text!, city: self.cityLbl.text!, country: "South Africa", postalCode: self.postcodeLbl.text!, contactNumber: self.contactNumberLbl.text!))
                                            StoredProperty.indexSelectedAddress = 0
                                          StoredProperty.isSelected = -1
                                           NotificationCenter.default.post(name: Notification.Name("confirmReload"), object: nil)

                                       // NotificationCenter.default.post(name: Notification.Name("reloadAddress"), object: nil)
                                        self.navigationController?.popViewController(animated: true)
                                        self.dismiss(animated: true, completion: nil)
                                      } else {
                                        
                                        self.view.makeToast("Something Wrong")
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 12 {
            textField.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            
            let filter = GMSAutocompleteFilter()
            //filter.type = .establishment
            filter.country = "ZA"
            acController.autocompleteFilter = filter
            acController.modalPresentationStyle = .fullScreen
            present(acController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        guard let locValue :CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        print(locValue)
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: -28.4792625, longitudeDelta:  24.6727135))
            
            
        }
    }
}

extension AddAddressDetailsViewController: GMSAutocompleteViewControllerDelegate {
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
       dismiss(animated: true, completion: nil)
     }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        
        self.mapView.clear()

       
       // self.postcodeLbl.text = "\(place.placeID)"
        //self.countryname.text = "\(place.plusCode)"
        getAddressFromLatLon(pdblLatitude: "\(place.coordinate.latitude)", withLongitude: "\(place.coordinate.longitude)")
        
        let cord2D = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
       
        self.userdefault.setValue("\(place.name!)", forKey: "name")
        //StoredProperty.lon =
        //userdefault.setValue(place.coordinate.longitude, forKey: "lon")
        self.userdefault.setValue(place.coordinate.latitude, forKey: "lat")
        self.userdefault.setValue(place.coordinate.longitude, forKey: "lon")
        //StoredProperty.lat = place.coordinate.latitude
        
        let marker = GMSMarker()
        marker.position = cord2D
        marker.title = "Location"
        marker.snippet = place.name
        
        let markerImage = UIImage(named: "city")
        let markerImageView = UIImageView(image: markerImage)
        
        marker.iconView = markerImageView
        marker.map = self.mapView
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
  
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country!)
//                    print(pm.locality!)
//                    print(pm.subLocality!)
//                    print(pm.thoroughfare!)
//                    print(pm.postalCode!)
                   // print(pm.subThoroughfare!)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                        self.suburbLbl.text = pm.subLocality
                        
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                        self.streetAddressLbl.text = pm.thoroughfare
                        
                    } else {
                        self.streetAddressLbl.text = pm.subLocality
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        self.cityLbl.text = pm.locality
                        
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                        self.countryname.text = pm.country!
                    }
                    if pm.postalCode != nil {
                       // addressString = addressString + pm.postalCode! + " "
                        print(pm.postalCode!)
                        self.postcodeLbl.text = pm.postalCode!
                        
                    }


                    print(addressString)
              }
        })

    }
    
}
