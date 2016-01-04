//
//  ShowLargeStickerViewController.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/31.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit
import AVFoundation
import APNGKit

class ShowLargeStickerViewController: UIViewController {

    var st:sticker = sticker()
    var player = AVQueuePlayer()
    var api = LINEAPI()
    var img = UIImageView(frame: CGRectZero)
    var ani:APNGImageView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var frameOfImage = CGRectZero
        
        let singleTap = UITapGestureRecognizer(target: self, action:"playAgain")
        singleTap.numberOfTapsRequired = 1

        if st.aniImage != nil {
            ani = APNGImageView(image: st.aniImage)
            frameOfImage = CGRect(x: 8, y: 8  , width:  ani!.image!.size.width, height:  ani!.image!.size.height)
            ani!.frame = frameOfImage
            ani!.userInteractionEnabled = true
            ani!.addGestureRecognizer(singleTap)
            view.addSubview(ani!)
            ani!.startAnimating()
        }else{
            img.image = UIImage(data:st.sImage!)
            frameOfImage = CGRect(x: 8, y: 8  , width: img.image!.size.width, height: img.image!.size.height)
            img.frame = frameOfImage
            img.userInteractionEnabled = true
            img.addGestureRecognizer(singleTap)
            view.addSubview(img)
        }
        
                
        
        img.sizeThatFits(CGSize(width: st.image!.size.width, height: st.image!.size.height))
        if img.image?.images != nil {
            img.startAnimating()
        }
        
        if (st.sound != nil){
            player.removeAllItems()
            //player.insertItem(AVPlayerItem(URL: NSURL(string: api.getSoundUrl(st.setID, stickerID: st.sID))!), afterItem: nil)
            player.insertItem(AVPlayerItem(URL: NSURL(fileURLWithPath: st.sound!)), afterItem: nil)
            player.actionAtItemEnd = .Pause
            player.play()
        }
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue())
            { notification in
                self.player.seekToTime(kCMTimeZero)
            }
        
    }
    
    func playAgain(){
        if ani != nil { ani?.startAnimating() }
        player.play()
    }

}
