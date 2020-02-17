//
//  ProductDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/15/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var discriptonBorder: UILabel!
    @IBOutlet weak var infoBorder: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func discriptionAction(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        collView.scrollToItem(at: indexPath, at: .left, animated: true)
        discriptonBorder.backgroundColor = .red
        infoBorder.backgroundColor = .black
    }
    @IBAction func informationAction(_ sender: Any) {
        let indexPath = IndexPath(row: 1, section: 0)
        collView.scrollToItem(at: indexPath, at: .left, animated: true)
        discriptonBorder.backgroundColor = .black
        infoBorder.backgroundColor = .red
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductDetailsCollectionViewCell
        
        if indexPath.row == 0 {
        cell?.colorLabel.text = "Free delivery* in SA within 1-3 days | Free & easy returns | All Prices Vat Incl."
            cell?.colorLabel.textColor = .red
            cell?.colorLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell?.sizeLabel.text = "This word (Discription) may be misspelled. Below you can find the suggested words which we believe are the correct spellings for what you were searching for.his word (Discription) may be misspelled. Below you can find the suggested words which we believe are the correct spellings for what you were searching for."
            discriptonBorder.backgroundColor = .red
            
        }else {
            cell?.colorLabel.text = "Colour: N/A"
            cell?.sizeLabel.text = "Size: 150g"
        }
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currenindex = Int(scrollView.contentOffset.x/collView.frame.size.width)
        if currenindex == 0 {
            discriptonBorder.backgroundColor = .red
            infoBorder.backgroundColor = .black
        } else {
            discriptonBorder.backgroundColor = .black
            infoBorder.backgroundColor = .red
        }
    }
    
    
}
