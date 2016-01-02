//
//  ShowLargeStickerViewController.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/31.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit
import AVFoundation

class ShowLargeStickerViewController: UIViewController {

    var st:sticker = sticker()
    var player = AVQueuePlayer()
    var api = LINEAPI()
    var img = UIImageView(frame: CGRectZero)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        img.image = UIImage(data:st.sImage!)
        let frameOfImage = CGRect(x: 8, y: 8  , width: img.image!.size.width, height: img.image!.size.height)
        img.frame = frameOfImage
        let singleTap = UITapGestureRecognizer(target: self, action:"playAgain")
        singleTap.numberOfTapsRequired = 1
        img.userInteractionEnabled = true
        img.addGestureRecognizer(singleTap)
        view.addSubview(img)
        
        img.sizeThatFits(CGSize(width: st.image!.size.width, height: st.image!.size.height))
        if img.image?.images != nil {
            img.startAnimating()
        }
        
        player.removeAllItems()
        player.insertItem(AVPlayerItem(URL: NSURL(string: api.getSoundUrl(st.setID, stickerID: st.sID))!), afterItem: nil)
        player.actionAtItemEnd = .Pause
        player.play()
        
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue())
            { notification in
                self.player.seekToTime(kCMTimeZero)
            }
        
    }
    
    func playAgain(){
        player.play()
    }

}
