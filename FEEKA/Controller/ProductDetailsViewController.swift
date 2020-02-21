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
            let string1: String = "<span style=\"color: #ff0000;\"><strong>Free delivery* in SA within 1-3 days | Free &amp; easy returns | All prices Vat incl.</strong></span>\r\n\r\nThe TRESemmé Colour Revitalise system, with Advanced Colour Vibrancy technology, helps to keep colour vibrant for up to eight weeks.* This system, with green tea, rosemary and sunflower extracts, gently cleanses and conditions the hair to help replenish vital moisture and keep hair looking healthy. Your hair colour will be vibrant and long-lasting, while every strand is soft and manageable. For best results, use in conjunction with TRESemmé Colour Revitalise Conditioner.\r\n\r\n*TRESemmé Colour Revitalise Shampoo and Conditioner versus non-conditioning shampoo."
            cell?.sizeLabel.text = string1.htmlToString
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
