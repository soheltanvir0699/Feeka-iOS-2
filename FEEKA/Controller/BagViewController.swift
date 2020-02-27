//
//  BagViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 22/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Nuke

class BagViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var conBtn: UIButton!
    var indicator:NVActivityIndicatorView!
    var dataList = [bagDataModel]()
    var shipping = ""
    var totalPrice = 0
    let userdefault = UserDefaults.standard
     var customerId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 1
        topView.layer.shadowOffset = .zero
        topView.layer.shadowRadius = 1.3
        
               
    NotificationCenter.default.addObserver(self, selector: #selector(goHome), name: Notification.Name("goHome"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
//        if  userdefault.value(forKey: "customer_id") as! String != "" {
            
//        }
      
            if userdefault.value(forKey: "customer_id") as? String == nil {
                
                signOutAction()
                
            }else {
                customerId = userdefault.value(forKey: "customer_id") as! String
                bagApiCalling()
        }
        
    }
    
    
    @objc func goHome() {
        tabBarController?.selectedIndex = 0
    }
    
    func signOutAction() {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
    }
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        let deliveryVC = storyboard?.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        deliveryVC.modalPresentationStyle = .fullScreen
        
        self.present(deliveryVC, animated: true, completion: nil)
    }
    
    func bagApiCalling() {
        dataList = [bagDataModel]()
        indicator = self.indicator()
        indicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
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
                                  
                  let shipping = jsonResponse["Shipping"].stringValue
                  let totalPrice = jsonResponse["total_price"].intValue
                self.shipping = shipping
                self.totalPrice = totalPrice
                    let data = jsonResponse["data"].arrayValue
                
                for i in data {

                  let outofstock = i["IsOutOfStock"].stringValue
                  let id = i["id"].stringValue
                  let brand = i["brand"].arrayValue[0].stringValue
                  let title = i["title"].stringValue
                  let image = i["image"].stringValue
                  let price = i["price"].intValue
                  let Qty = i["quantity"].stringValue
                    let cardId = i["cart_id"].stringValue
                    
                    self.dataList.append(bagDataModel(title: title, shipping: shipping, totalPrice: "\(totalPrice)", quantity: Qty, id: id, brand: brand, price: "\(price)", image: image, outOfStock: outofstock, cardId: cardId))
                    self.tblView.reloadData()
                }
                if let tabItems = self.tabBarController?.tabBar.items {
                               
                               // In this case we want to modify the badge number of the third tab:
                               let tabItem = tabItems[2]
                               tabItem.badgeValue = "\(self.dataList.count)"
                           }
                if self.dataList.count == 0 {
                    self.mainView.isHidden = true
                    //self.conBtn.isHidden = true
               } else {
                    self.mainView.isHidden = false
                    //self.conBtn.isHidden = false
               }
                self.indicator.stopAnimating()
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
    }
    
    func alertView(index: Int) {
        let alertController = UIAlertController(title: "QUANTITY", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "1", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 1)
        }
        
        let action2 = UIAlertAction(title: "2", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 2)
        }
        let action3 = UIAlertAction(title: "3", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 3)
        }
        let action4 = UIAlertAction(title: "4", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 4)
        }
        let action5 = UIAlertAction(title: "5", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 5)
        }
        let action6 = UIAlertAction(title: "6", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 6)
        }
        let action7 = UIAlertAction(title: "7", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 7)
        }
        let action8 = UIAlertAction(title: "8", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 8)
        }
        let action9 = UIAlertAction(title: "9", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 9)
        }
        let action10 = UIAlertAction(title: "10", style: .default) { (alert) in
            self.qtyApi(sender: index, qty: 10)
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        alertController.addAction(action6)
        alertController.addAction(action7)
        alertController.addAction(action8)
        alertController.addAction(action9)
        alertController.addAction(action10)
        alertController.view.tintColor = .black
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension BagViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            return dataList.count
        } else {
            return dataList.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DiscoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as! DiscoverDetailsViewController
        DiscoverDetailsVC.productId = "\(dataList[indexPath.row].id)"
        self.navigationController?.pushViewController(DiscoverDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == dataList.count  {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as? BagSecondCell
            //cell2?.cellView.setShadow()
            cell2?.cellView.layer.shadowColor = UIColor.gray.cgColor
            cell2?.cellView.layer.shadowOpacity = 1
            cell2?.cellView.layer.shadowOffset = .zero
            cell2?.cellView.layer.shadowRadius = 1.3
            cell2?.deliveryPrice.text = "R \(self.shipping)"
            cell2?.totalPrice.text = "R \(self.totalPrice)"
            cell2?.selectedBackgroundView = UIView()
            //cell2?.contentView.setShadow()
            return cell2!
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BagFirstCell
            //cell?.productImg.downloaded(from: dataList[indexPath.row].image)
            if (self.dataList[indexPath.row].image).isEmpty != true {
            let request = ImageRequest(
                url: URL(string: self.dataList[indexPath.row].image)!
                )
                
            Nuke.loadImage(with: request, into: cell!.productImg)
            cell?.productPrice.text = "R \(dataList[indexPath.row].price)"
            }
            cell?.qtyBtn.addTarget(self, action: #selector(showQTY(sender:)), for: .touchUpInside)
            cell?.qtyBtn.tag = indexPath.row + 3000
            cell?.productName.text = dataList[indexPath.row].title
            cell?.brandLbl.text = dataList[indexPath.row].brand
            cell?.qtyBtn.setTitle(dataList[indexPath.row].quantity, for: .normal)
            cell?.deleteBtn.tag = indexPath.row + 1000
            cell?.isWishBtn.tag = indexPath.row + 2000
            cell?.deleteBtn.addTarget(self, action: #selector(deleteApi(sender:)), for: .touchUpInside)
            cell?.isWishBtn.addTarget(self, action: #selector(wishApi(sender:)), for: .touchUpInside)
            cell?.selectedBackgroundView = UIView()
        
            return cell!
            
        }
    }
    
    @objc func deleteApi(sender: UIButton) {
        indicator = self.indicator()
        indicator.startAnimating()
        let index = sender.tag - 1000
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/delete_cart.php") else {
            return
        }
        let customerId = userdefault.value(forKey: "customer_id") as! String
        
        let parameter = ["cart_id":"\(dataList[index].cardId)"]
        
        
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
                    self.totalPrice = self.totalPrice - Int(self.dataList[index].price)!
                    self.dataList.remove(at: index)
                    if let tabItems = self.tabBarController?.tabBar.items {
                        
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[2]
                        tabItem.badgeValue = "\(self.dataList.count)"
                        
                    }
                    if self.dataList.count == 0 {
                         self.mainView.isHidden = true
                         //self.conBtn.isHidden = true
                    } else {
                         self.mainView.isHidden = false
                         //self.conBtn.isHidden = false
                    }
                }
                    self.tblView.reloadData()
               
               
                self.indicator.stopAnimating()
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
        
    }
    
    @objc func wishApi(sender: UIButton) {
        let index = sender.tag - 2000
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/move_to_wishlist_v3.php") else {
            return
        }
        
        
        let parameter = ["cart_id":"\(dataList[index].cardId)","customer_id":"\(self.customerId)","product_id":"\(dataList[index].id)","variation_id":"0"]
        
        
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
                    self.bagApiCalling()
                }
              
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
        
    }
    
    func qtyApi(sender: Int, qty: Int) {
        let index = sender
               guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/update_cart_v4.php") else {
                   return
               }
               
               
        let parameter = ["cart_id":"\(dataList[index].cardId)","color":"","customer_id":"\(customerId)","quantity":"\(qty)","size":"","variation_id":"0"]
        
               
               
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
                           self.bagApiCalling()
                       } else {
                        let alert = ShowAlertView().alertView(title: "", action: "OK", message: "Item isn't available")
                        self.present(alert, animated: true, completion: nil)
                    }
                     
                   
                   }else {
                     let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                     self.present(alertView, animated: true, completion: nil)
                 }
                   
               }
    }
    
    @objc func showQTY(sender:UIButton) {
        let index = sender.tag - 3000
        alertView(index: index)
    }
    
    
}
