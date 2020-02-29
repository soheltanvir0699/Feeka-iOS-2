//
//  OrdersAndReturnController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class OrdersAndReturnController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var track: UIButton!
    var indicator:NVActivityIndicatorView!
    var customerId = ""
    let userdefault = UserDefaults.standard
    var dataList = [orderModel]()
    @IBOutlet weak var tblView: UITableView!
    var addList = [orderandreturn]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? OrderAndReturnCell
        cell?.bgView.layer.cornerRadius = 7
        cell?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell?.bgView.layer.shadowOpacity = 0.3
        cell?.bgView.layer.shadowOffset = .zero
        cell?.bgView.layer.shadowRadius = 0.5
        cell?.trackOrder.tag = indexPath.row + 1000
        cell?.viewOrder.tag = indexPath.row + 2000
        cell?.trackOrder.addTarget(self, action: #selector(trackAction(sender:)), for: .touchUpInside)
        cell?.viewOrder.addTarget(self, action: #selector(viewOrder(sender:)), for: .touchUpInside)
        cell?.selectedBackgroundView = UIView()
        cell?.date.text = dataList[indexPath.row].date
        cell?.orderId.text = dataList[indexPath.row].orderId
        cell?.totalPrice.text = dataList[indexPath.row].totalPrice
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBOutlet weak var navView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        navView.setShadow()
        ordersApi()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
        //NotificationCenter.default.post(name: Notification.Name("backWeb"), object: nil, userInfo: nil)
    }
   @objc func trackAction(sender: UIButton) {
    let indexpath = sender.tag - 1000
        let vc = storyboard?.instantiateViewController(withIdentifier: "TrackController") as? TrackController
        vc?.orderIdTxt = dataList[indexpath].orderId
        vc?.array = self.addList
    print(addList)
        vc?.index = indexpath
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        
    }
@objc func viewOrder(sender: UIButton) {
    let indexpath = sender.tag - 2000
    let vc = storyboard?.instantiateViewController(withIdentifier: "ExangeRefundController") as? ExangeRefundController
    vc?.orderId = dataList[indexpath].orderId
    vc?.modalPresentationStyle = .fullScreen
    present(vc!, animated: true, completion: nil)
    }
    
    
    func ordersApi() {
        
    indicator = self.indicator()
           indicator.startAnimating()
           guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/order_listing_v2.php") else {
               return
           }
        let parameter   = ["customer_id":"\(self.customerId)"]
        
           
           Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
           
           if let error = response.error {
               self.indicator.stopAnimating()
               let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
               self.present(alertView, animated: true, completion: nil)
               print(error)
               
           }
           
               if let response = response.result.value {
                   let jsonResponse = JSON(response)
                                     
                let data =  jsonResponse["data"].arrayValue
                print(data)
                print(parameter)
                if data.isEmpty == true {
                    let alert = UIAlertController(title: "", message: "No Orders Found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: Notification.Name("backWeb"), object: nil, userInfo: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                if jsonResponse["status"].stringValue == "1" {
                    for dataItem in data {
                     let dataIndex = JSON(dataItem)
                        let date = dataIndex["date"].stringValue
                        let orderId = dataIndex["id"].stringValue
                        let totalPrice = dataIndex["total_price"].stringValue
                        let subrub = dataIndex["Suburb"].stringValue
                        let unitnumber = dataIndex["Unit_Number"].stringValue
                        let apartment = dataIndex["Apartment"].stringValue
                        let company = dataIndex["Company"].stringValue
                        let street = dataIndex["Street_Address"].stringValue
                        let city = dataIndex["City"].stringValue
                        let country = dataIndex["Country"].stringValue
                        let postal = dataIndex["Postal_Code"].stringValue
                        let status = dataIndex["status"].stringValue
                        self.addList.append(orderandreturn(name: "", suburb: subrub, unit: unitnumber, apart: apartment, company: company, street: street, city: city, country: country, postalCode: postal, status: status))
                        self.dataList.append(orderModel(date: date, orderId: orderId, totalPrice: totalPrice))
                        self.tblView.reloadData()
                    }
                } else {
                    let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                       self.indicator.stopAnimating()
                   
               
           }
       }
    
    
    }
    
  

}
