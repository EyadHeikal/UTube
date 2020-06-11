//
//  VideoView.swift
//  UTube
//
//  Created by Eyad Heikal on 6/6/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper

class VideoView: UIView, YTPlayerViewDelegate {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        
        let yPlayer = YTPlayerView(frame: self.frame)
        yPlayer.delegate = self
        yPlayer.load(withVideoId: "ErTgtL1Tjns")
        
        self.addSubview(yPlayer)
        
//        let str = "https://www.youtube.com/embed/ErTgtL1Tjns"
//        if let url = URL(string: str) {
//            let player = AVPlayer(url: url)
//            print("DA")
//
//            let playerLayer = AVPlayerLayer(player: player)
//            self.layer.addSublayer(playerLayer)
//            playerLayer.frame = self.frame
//            player.play()
//
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
