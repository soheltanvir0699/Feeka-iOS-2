//
//  ExangeRefundController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Nuke

class ExangeRefundController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var postalcode: UILabel!
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var firstBg: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var secondBg: UIView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    var orderId = ""
    var indicator:NVActivityIndicatorView!
       var customerId = ""
       let userdefault = UserDefaults.standard
       var dataList = [orderModel]()
    var sName = [String]()
    var sqty = [Int]()
    var sBrand = [String]()
    var sImage = [String]()
    var price = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        
        firstBg?.layer.cornerRadius = 7
        firstBg?.layer.shadowColor = UIColor.black.cgColor
        firstBg?.layer.shadowOpacity = 0.3
        firstBg?.layer.shadowOffset = .zero
        firstBg?.layer.shadowRadius = 0.5
        secondBg?.layer.cornerRadius = 7
        secondBg?.layer.shadowColor = UIColor.black.cgColor
        secondBg?.layer.shadowOpacity = 0.3
        secondBg?.layer.shadowOffset = .zero
        secondBg?.layer.shadowRadius = 0.5
        orderIdLbl.text = orderId
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        ordersApi()

        // Do any additional setup after loading the view.
    }
    @IBAction func refundAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter Reason"
            
        }
        
        alert.addAction(UIAlertAction(title: "CANCLE", style: .default, handler: { (action) in
        }))

        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (action) in
            let text = alert.textFields![0].text
            self.refundRequest(reason: text!, reqType: "4")
           // self.dismiss(animated: true, completion: nil)
        }))
        alert.view.backgroundColor = .black
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func returnPolicyAction(_ sender: Any) {
        if let url = URL(string: "https://feeka.co.za/delivery-return-policy/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @IBAction func exchangeAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
              alert.addTextField { (textfield) in
                textfield.placeholder = "Enter Reason"
                
              }
        
        alert.addAction(UIAlertAction(title: "CANCLE", style: .default, handler: { (action) in
        }))

              alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (action) in
                  let text = alert.textFields![0].text
                  self.refundRequest(reason: text!, reqType: "6")
              }))
              alert.view.backgroundColor = .black
              alert.view.tintColor = .white
              self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func ordersApi() {
           
       indicator = self.indicator()
              indicator.startAnimating()
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/order_detail.php") else {
                  return
              }
        let parameter   = ["customer_id":"\(self.customerId)", "order_id": "\(orderId)"]
           
              
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
                    let dataArray = JSON(data[0])
                    let subTotal = dataArray["sub_total"].stringValue
                    let shipping = dataArray["Shipping"].stringValue
                    let total = dataArray["order_total"].stringValue
                    self.currentDate.text = dataArray["date"].stringValue
                    self.totalLbl.text = total
                    self.subtotal.text = subTotal
                    self.delivery.text = shipping
                    self.total.text = total
                    
                    let address = JSON(dataArray["address"])
                    
                    self.name.text = "\(address["Name"].stringValue) \(address["Surname"].stringValue)"
                    self.contact.text = address["Contact_Number"].stringValue
                    self.street.text = address["Street_Address"].stringValue
                    self.city.text = address["City"].stringValue
                    self.country.text = address["Country"].stringValue
                    self.postalcode.text = address["Postal_Code"].stringValue
                    let productDetail =  dataArray["product_detail"].arrayValue
                       for dataItem in productDetail {
                        let dataIndex = JSON(dataItem)
                        let name = dataIndex["name"].stringValue
                        let qyt1 = dataIndex["qty"].intValue
                        let image = dataIndex["image"].stringValue
                        let price = dataIndex["price"].intValue
                        let brand = dataIndex["brand"].stringValue
                        print(name,image)
                        self.sName.append(name)
                        self.sqty.append(qyt1)
                        self.sImage.append(image)
                        self.price.append(price)
                        self.sBrand.append(brand)
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
    
    
    func  refundRequest(reason: String, reqType:String) {
        
    indicator = self.indicator()
           indicator.startAnimating()
           guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/order_return_request.php") else {
               return
           }
        let parameter   = ["customer_id":"\(self.customerId)", "order_id": "\(orderId)","request_type":"\(reqType)", "return_reason": "\(reason)"]
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
                                    
                print(jsonResponse)
               
                if jsonResponse["status"].stringValue == "1" {
                   
                    let alertView = ShowAlertView().alertView(title: "\(jsonResponse["message"].stringValue)", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)

                } else {
                    
                let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                self.present(alertView, animated: true, completion: nil)
                self.indicator.stopAnimating()
                }
                    
                } else {
                    let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                       self.indicator.stopAnimating()
                   
               
           }
       }
    
    
    }





extension ExangeRefundController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExangeRefundCell
        
        cell?.selectedBackgroundView = UIView()
        cell?.bgView.layer.cornerRadius = 7
        cell?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell?.bgView.layer.shadowOpacity = 0.3
        cell?.bgView.layer.shadowOffset = .zero
        cell?.bgView.layer.shadowRadius = 0.5
        if URL(string: sImage[indexPath.row]) != nil {
        //let url  = URL(string: sImage[indexPath.row])
       // cell?.Producimage.downloadedFrom(url: url! , contentMode: .scaleAspectFill)
            let request2 = ImageRequest(
                url: URL(string: sImage[indexPath.row])!
                )
            Nuke.loadImage(with: request2, into: cell!.Producimage)
        }
        cell?.productName.text = sName[indexPath.row]
        cell?.price.text = "\(price[indexPath.row])"
        cell?.qty.text = "QTY:     \(sqty[indexPath.row])"
        cell?.productBrand.text = sBrand[indexPath.row]
        return cell!
     }
    
    
    
}
