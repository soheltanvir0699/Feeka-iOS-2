//
//  ConfirmOrderViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ConfirmOrderViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tblView: UITableView!
    var indicator:NVActivityIndicatorView!
    var methodArray = [confirmMethodModel]()
    var addressArray = [confirmAddress]()
    var itemArray = [confirmProductModel]()
    var customerId = ""
    var userdefault = UserDefaults.standard
    var address_id = ""
    var method = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        if userdefault.value(forKey: "address_id") as? String != nil {
            address_id =  userdefault.value(forKey: "address_id") as! String
        }
        confirmOderApi()
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: Notification.Name("backcon"), object: nil)
    }
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func confirmOderApi() {
        indicator = self.indicator()
        indicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/Confirm_order_listing_v3.php") else {
            return
        }
        
        let parameter = ["address_id":"\(address_id)","customer_id":"\(customerId)","method":"\(method)"]
        
        Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        
        if let error = response.error {
            self.indicator.stopAnimating()
            let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
            self.present(alertView, animated: true, completion: nil)
            print(error)
            
        }
        
            if let response = response.result.value {
                let jsonResponse = JSON(response)
             
               // print(totalPage)
                if jsonResponse["status"] == "1" {
                    let totalPrice = jsonResponse["total_price"].intValue
                    let subTotal = jsonResponse["final_sub_total"].stringValue
                    let shipping = jsonResponse["Shipping"].stringValue
                    self.methodArray.append(confirmMethodModel(total: "\(totalPrice)", subTotal: subTotal, shipping: shipping))
                    let addressDetails = JSON(jsonResponse["address_detail"])
                    let addressId = addressDetails["address_id"].stringValue
                    let customerId = addressDetails["customerId"].stringValue
                    let name = addressDetails["Name"].stringValue
                    let surename = addressDetails["Surname"].stringValue
                    let contact = addressDetails["Contact_Number"].stringValue
                    let unitNumer = addressDetails["Unit_Number"].stringValue
                    let apartment = addressDetails["Apartment"].stringValue
                    let company = addressDetails["Company"].stringValue
                    let street = addressDetails["Street_Address"].stringValue
                    let subrub = addressDetails["Suburb"].stringValue
                    let city = addressDetails["City"].stringValue
                    let postalcode = addressDetails["Postal_Code"].stringValue
                    let country = addressDetails["Country"].stringValue
                    self.addressArray.append(confirmAddress(addressId: addressId, customerId: customerId, name: name, sureName: surename, contact: contact, unitNumber: unitNumer, apartment: apartment, company: company, street: street, suburb: subrub, city: city, postalCode: postalcode, country: country))
                for i in jsonResponse["cart_iteam"].arrayValue {
                    let data = JSON(i)
                    let title = data["title"].stringValue
                    let image = data["image"].stringValue
                    let qty = data["quantity"].stringValue
                    let price = data["total_price"].stringValue
                    let brand = data["brand"].stringValue
                    self.itemArray.append(confirmProductModel(image: image, title: title, qty: qty, totalPrice: price, brand: brand))
                    self.tblView.reloadData()
                }
                    self.indicator.stopAnimating()
                } else {
                    print("error")
                }
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
    }


    
    @IBAction func paymentAction(_ sender: Any) {
        
        indicator = self.indicator()
        indicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/payment_getway_v3.php") else {
            return
        }
        
        let parameter = ["address_id":"\(address_id)","customer_id":"\(customerId)","method":"\(method)", "quoteId":"\(StoredProperty.quoteId)"]
        print(parameter)
        Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        
        if let error = response.error {
            self.indicator.stopAnimating()
            let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
            self.present(alertView, animated: true, completion: nil)
            print(error)
            
        }
        
            if let response = response.result.value {
                let jsonResponse = JSON(response)
             print(response)
               // print(totalPage)
                if jsonResponse["status"] == "1" {
                    let url = jsonResponse["url"].stringValue
                    let returnUrl = jsonResponse["return_url"].stringValue
                    let cancel_url = jsonResponse["cancel_url"].stringValue
                    
                    self.indicator.stopAnimating()
                    
                    let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
                    webViewController?.currentUrl = url
                    webViewController?.cancleUrl = cancel_url
                    webViewController?.successUrl = returnUrl
                    webViewController?.modalPresentationStyle = .fullScreen
                    self.present(webViewController!, animated: true, completion: nil)
                } else {
                    self.indicator.stopAnimating()
    
                }
            }
        }
    }
    

}

extension ConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemArray.count == 0 {
            return itemArray.count
        }else {
        return itemArray.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1  = tableView.dequeueReusableCell(withIdentifier: "cell1") as? ConfirmFirstCell
        cell1?.bgFirstView.layer.cornerRadius = 4
        cell1?.bgFirstView.layer.shadowColor = UIColor.black.cgColor
        cell1?.bgFirstView.layer.shadowOpacity = 0.3
        cell1?.bgFirstView.layer.shadowOffset = .zero
        cell1?.bgFirstView.layer.shadowRadius = 0.5
//        cell1?.bgView.layer.cornerRadius = 7
//        cell1?.bgView.layer.shadowColor = UIColor.black.cgColor
//        cell1?.bgView.layer.shadowOpacity = 0.3
//        cell1?.bgView.layer.shadowOffset = .zero
//        cell1?.bgView.layer.shadowRadius = 0.5
        cell1?.selectedBackgroundView = UIView()
        
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as? ConfrimSecondCell
        
        cell2?.selectedBackgroundView = UIView()
        cell2?.bgView.layer.cornerRadius = 7
        cell2?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell2?.bgView.layer.shadowOpacity = 0.3
        cell2?.bgView.layer.shadowOffset = .zero
        cell2?.bgView.layer.shadowRadius = 0.5
        cell2?.bgView2.layer.cornerRadius = 7
        cell2?.bgView2.layer.shadowColor = UIColor.black.cgColor
        cell2?.bgView2.layer.shadowOpacity = 0.3
        cell2?.bgView2.layer.shadowOffset = .zero
        cell2?.bgView2.layer.shadowRadius = 0.5

        if addressArray.count != 0 {
        if indexPath.row ==  itemArray.count {
            cell2?.bgView2.isHidden = true
            cell2?.apartment.text = addressArray[0].apartment
            cell2?.city.text = addressArray[0].city
            cell2?.company.text = addressArray[0].company
            cell2?.postalCode.text = addressArray[0].postalCode
            cell2?.number.text = addressArray[0].contact
            cell2?.country.text = addressArray[0].country
            cell2?.name.text = "\(addressArray[0].name) \(addressArray[0].sureName))"
            cell2?.surub.text = addressArray[0].suburb
            
            return cell2!
        } else if indexPath.row == itemArray.count + 1  {
            cell2?.bgView2.isHidden = false
            cell2?.subTotalPrice.text = methodArray[0].subTotal
            cell2?.total.text = methodArray[0].total
            cell2?.stander.text = StoredProperty.quote
            cell2?.delivery.text = methodArray[0].shipping
            return cell2!
            
        } else {
            //cell1?.imageView?.downloaded(from: itemArray[indexPath.row].image)
            let url = URL(string: itemArray[indexPath.row].image)
            cell1?.imageImg?.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
            cell1?.name.text = itemArray[indexPath.row].title
            cell1?.brand.text = itemArray[indexPath.row].brand
            cell1?.qty.text = "QTY:    \(itemArray[indexPath.row].qty)"
            cell1?.price.text = "R \(itemArray[indexPath.row].totalPrice)"
            return cell1!
        }
            
        } else {
            return cell1!
        }
        
    }
    
    
}
