//
//  HotViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/13/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class HotViewController: UIViewController {

    @IBOutlet weak var allFaceImg: UIImageView!
    @IBOutlet weak var brandCareImg: UIImageView!
    @IBOutlet weak var allBodyImg: UIImageView!
    @IBOutlet weak var ConditionerImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpView()
    }
    
    func setUpView() {
        allFaceImg.layer.cornerRadius = 5
        brandCareImg.layer.cornerRadius = 5
        allBodyImg.layer.cornerRadius = 5
        ConditionerImg.layer.cornerRadius = 5
    }
    
}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? HotCollectionViewCell
        cell?.productImg.layer.cornerRadius = 5
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("sdsdsd")
    }
}
