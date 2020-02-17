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

    var avPlayer: AVPlayer!
     var avPlayerLayer: AVPlayerLayer!
     var paused: Bool = false

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
    

    
    @objc func playerItemDidReachEnd() {
        avPlayer.seek(to: CMTime.zero)
    }
    
}
