//
//  DiscoverViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit


class DiscoverViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var showCollBtn: UIButton!
    @IBOutlet weak var showTableBtn: UIButton!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var shortBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         pushDiscoverController()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
         return cell
    }

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("dsdsdsd")
    pushDiscoverController()
    hideKeyBoard()
    
    }

    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        var _:CGSize = CGSize(width: 100 , height: 300)
        return CGSize(width: 100 , height: 300)
    }
    
    func pushDiscoverController() {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as? DiscoverDetailsViewController
        navigationController?.pushViewController(discoverVC!, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.hideKeyBoard()
        setUpView()
    }

    func setUpView() {
        listView.layer.borderWidth = 1
        listView.layer.borderColor = UIColor.black.cgColor
        shortBtn.layer.borderWidth = 1
        shortBtn.layer.borderColor = UIColor.black.cgColor
    }
    
   
    
    @IBAction func sortItemAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        let newest = UIAlertAction(title: "Newest", style: .default) { (women) in
            
        }
       let lowToHigh = UIAlertAction(title: "Price (low to high", style: .default) { (button) in
            
        }
    let hightToLow = UIAlertAction(title: "Price (High to low", style: .default) { (button) in
        
    }
        let canAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in
            alert.removeFromParent()
        }
        alert.addAction(newest)
        alert.addAction(lowToHigh)
        alert.addAction(hightToLow)
        alert.addAction(canAction)
        alert.view.backgroundColor = .clear
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func showTableView(_ sender: Any) {
        tableView.isHidden = false
        collectionView.isHidden = true
        showTableBtn.setImage(UIImage(named: "square-shape-shadow-black"), for: .normal)
        showCollBtn.setImage(UIImage(named: "four-grey-squares"), for: .normal)
    }
    
    @IBAction func showCollectionView(_ sender: Any) {
        tableView.isHidden = true
        collectionView.isHidden = false
        showCollBtn.setImage(UIImage(named: "four-black-squares"), for: .normal)
        showTableBtn.setImage(UIImage(named: "square-shape-shadow-grey"), for: .normal)
    }
    
}
