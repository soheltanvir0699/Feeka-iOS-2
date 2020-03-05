//
//  DeliveryViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 23/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import GoogleMaps

class DeliveryViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var mkmapView: MKMapView!
    @IBOutlet weak var appCompact: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var suburb: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var appartment: UILabel!
    
    var customerId = ""
    let userdefault = UserDefaults.standard
    var dataList = [getCustomerDataModel]()
    var isAddress = true
    
    var indicator:NVActivityIndicatorView!
   // let userdefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addressView.setShadow()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPage), name: Notification.Name("reloadAddress"), object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if  userdefault.value(forKey: "customer_id") as! String != "" {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        if userdefault.value(forKey: "customer_id") as? String == nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        getAddressApi()

    }
    
    @objc func reloadPage() {
        getAddressApi()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addNewAddressAction(_ sender: Any) {
        let addressVc = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as! AddAddressDetailsViewController
        addressVc.isAddress = self.isAddress
        addressVc.modalPresentationStyle = .fullScreen
        present(addressVc, animated: true, completion: nil)
        
    }
    
    @IBAction func editAndChangeAction(_ sender: Any) {
        
        let addressVc = storyboard?.instantiateViewController(withIdentifier: "EditChangeAddressController") as! EditChangeAddressController
        //addressVc.modalPresentationStyle = .fullScreen
       // present(addressVc, animated: true, completion: nil)
        self.navigationController?.pushViewController(addressVc, animated: true)
        
    }
    
    
    @IBAction func continueToDeliSchedule(_ sender: Any) {
        let deli2VC = storyboard?.instantiateViewController(withIdentifier: "DeliverySecondController") as? DeliverySecondController
       // deli2VC?.modalPresentationStyle = .fullScreen
        //present(deli2VC!, animated: true, completion: nil)
        navigationController?.pushViewController(deli2VC!, animated: true)
    }
    
    func setMapLocation(suburb:String,address: String,country: String) {
        let address2 = address.replacingOccurrences(of: " ", with: "%20")
        guard let urlToExcute = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(address2)&key=AIzaSyBaTY6bQWJElnvG5c6g4Q9MMu3soiLXXeg") else {
                   return
               }
        
        Alamofire.request(urlToExcute, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        
        if let error = response.error {
            self.indicator.stopAnimating()
            let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
            self.present(alertView, animated: true, completion: nil)
            print(error)
            
        }
            
            if let response = response.result.value {
            let jsonResponse = JSON(response)
                print(jsonResponse)
                let result = JSON(jsonResponse["results"].arrayValue[0])
                let formattedAddress = JSON(result["geometry"])
                let bounds = JSON(formattedAddress["location"])
                let lat = bounds["lat"].doubleValue
                let lon = bounds["lng"].doubleValue
                print(lat , lon)
                print(lat)
                let cord2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                let marker = GMSMarker()
                marker.position = cord2D
                marker.title = "Location"
                marker.snippet = address
                
                let markerImage = UIImage(named: "city")
                let markerImageView = UIImageView(image: markerImage)
                
                marker.iconView = markerImageView
                marker.map = self.mapView
                self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
            }
            
            
        }
    }
    
    func getAddressApi() {
        indicator = self.indicator()
        indicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/get_address.php") else {
            return
        }
        
        
        let parameter = ["customer_id":"\(self.customerId)"]
        
        
        Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        
        if let error = response.error {
            self.indicator.stopAnimating()
            let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
            self.present(alertView, animated: true, completion: nil)
            print(error)
            
        }
        
            if let response = response.result.value {
                let jsonResponse = JSON(response)
                                  
                if jsonResponse["status"].stringValue == "1" {
                    let data = jsonResponse["data"].arrayValue[0]
                    if data.isEmpty == false {
                        let address = data["address_id"].stringValue
                        let customerid = data["customer_id"].stringValue
                        let name = data["Name"].stringValue
                        let surname = data["Surname"].stringValue
                        let apartment = data["Apartment"].stringValue
                        let company = data["Company"].stringValue
                        let streetAddress = data["Street_Address"].stringValue
                        let suburb = data["Suburb"].stringValue
                        let city = data["City"].stringValue
                        let country = data["Country"].stringValue
                        let postalCode = data["Postal_Code"].stringValue
                        let contact = data["Contact_Number"].stringValue
                        let unit = data["Unit_Number"].stringValue
                        print(city)
                        self.setMapLocation(suburb: suburb,address: city, country : country)
                        self.userdefault.setValue(address, forKey: "address_id")
                        self.dataList.append(getCustomerDataModel(addressId: address, customerId: customerid, name: name, surname: surname, apartment: apartment, company: company, street: streetAddress, suburb: suburb, city: city, country: country, postalCode: postalCode, contactNumber: contact))
                        self.postalCode.text = postalCode
                        self.name.text = "\(name) \(surname)"
                        self.phoneNumber.text = contact
                        self.appartment.text = "\(unit) \(apartment)"
                        self.appCompact.text = company
                        self.street.text = streetAddress
                        self.suburb.text = suburb
                        self.city.text = city
                        self.country.text = country
                        self.isAddress = false
                        self.indicator.stopAnimating()
                        StoredProperty.addressData = self.dataList
                    }
                } else {
                    self.view.makeToast("Address Not Found")
                    self.isAddress = true
                    self.indicator.stopAnimating()
                }
              
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                self.indicator.stopAnimating()
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
    }
}
