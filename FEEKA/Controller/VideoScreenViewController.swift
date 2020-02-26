//
//  VideoScreenViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/13/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import AVFoundation

class VideoScreenViewController: UIViewController {

    @IBOutlet weak var fikkaLogo: UIImageView!
    var avPlayer: AVPlayer!
     var avPlayerLayer: AVPlayerLayer!
     var paused: Bool = false
    var userdefault = UserDefaults.standard
   
    @IBOutlet weak var joinClubBtn: UIButton!
    
    @IBOutlet weak var videoBackgroundView: UIView!
    override func viewDidLoad() {
         super.viewDidLoad()
         let url = Bundle.main.url(forResource: "vid_file2", withExtension: "mp4")


         avPlayer = AVPlayer(url: url!)
         avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
         avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none

        avPlayerLayer.frame = self.videoBackgroundView.frame
         videoBackgroundView.backgroundColor = UIColor.clear;
         videoBackgroundView.layer.insertSublayer(avPlayerLayer, at: 0)

        NotificationCenter.default.addObserver(self,selector:#selector(playerItemDidReachEnd),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer.currentItem)
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
        self.avPlayer.isMuted = true
    }
    override func viewWillAppear(_ animated: Bool) {
        var isCheck = ""
        if userdefault.value(forKey: "isOpen") != nil {
            isCheck = userdefault.value(forKey: "isOpen") as! String
            if isCheck == "1" {
                joinClubBtn.isHidden = true
                fikkaLogo.isHidden = true
                perform(#selector(pushAction), with: nil, afterDelay: 0.0)
            }
            
        }else {
          userdefault.setValue("1", forKey: "isOpen")
            joinClubBtn.isHidden = false
            fikkaLogo.isHidden = false
        }
        
    }
    
    @objc func pushAction () {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        navigationController?.pushViewController(vc!, animated: true)
    }
    

    
    @objc func playerItemDidReachEnd() {
        avPlayer.seek(to: CMTime.zero)
    }
    
}
