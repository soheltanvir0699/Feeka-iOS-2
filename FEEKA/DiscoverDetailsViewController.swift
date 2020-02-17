//
//  DiscoverDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class DiscoverDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: [String] = ["Fashion","Fashion"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfPages = image.count
        for index in 0..<image.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: image[index])
            imgView.contentMode = .scaleAspectFit
            self.scrollView.addSubview(imgView)
        }
        
        scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width) * CGFloat(image.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func productDetailsAction(_ sender: Any) {
        let discoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")
        self.navigationController?.pushViewController(discoverDetailsVC!, animated: true)
    }
}

extension DiscoverDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath)
        return cell
    }
    
    
}
