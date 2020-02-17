//
//  HomeProductDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/17/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class HomeProductDetailsViewController: UIViewController {

    @IBOutlet weak var showTblBtn: UIButton!
    @IBOutlet weak var showCollBtn: UIButton!
    @IBOutlet weak var productListCollView: UICollectionView!
    @IBOutlet weak var productListTblView: UITableView!
    @IBOutlet weak var showHideListView: UIView!
    @IBOutlet weak var menuView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let flowLayout = menuView?.collectionViewLayout as? UICollectionViewFlowLayout {
        //  flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        showHideListView.layer.borderColor = UIColor.black.cgColor
        showHideListView.layer.borderWidth = 1
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension HomeProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productListCollView {
            return 10
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productListCollView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath)
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    @IBAction func showTableView(_ sender: Any) {
        productListTblView.isHidden = false
        productListCollView.isHidden = true
        showTblBtn.setImage(UIImage(named: "square-shape-shadow-black"), for: .normal)
        showCollBtn.setImage(UIImage(named: "four-grey-squares"), for: .normal)
    }
    
    @IBAction func showCollectionView(_ sender: Any) {
        productListTblView.isHidden = true
        productListCollView.isHidden = false
        showCollBtn.setImage(UIImage(named: "four-black-squares"), for: .normal)
        showTblBtn.setImage(UIImage(named: "square-shape-shadow-grey"), for: .normal)
    }
    
    
}

extension HomeProductDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
