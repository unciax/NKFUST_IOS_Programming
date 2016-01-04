//
//  sticker.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation
import UIKit
import APNGKit

class sticker{
    var sID:Int = 0
    var setID:Int = 0
    var isAnimation:Bool = false
    var sImage:NSData?
    var image:UIImage?
    var aniImage:APNGImage?
    var sound:String?
    var api = LINEAPI()
    
    private let documentPath: AnyObject =
    NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask,
        true)[0]
    
    init(){
        // do nothing
    }
    
    init(sID:Int, setID:Int, isAnimation:Bool){
        self.sID = sID
        self.setID = setID
        self.isAnimation = isAnimation
    }
    
    func load(){
        sound = getSound()
        sImage = getStaticImage()
        aniImage = getDynamicImage()
        image = UIImage(data: sImage!)
    }
    
    func getDynamicImage()->APNGImage?{
        
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/\(sID)_ani.apng")
        if !fileManager.fileExistsAtPath(path) {
            if let url = NSURL(string: api.getAnimationSticker(setID, stickerID: sID)) {
                if let data = NSData(contentsOfURL: url){
                    let success = data.writeToFile(path, atomically: true)
                    if !success {
                        print("'\(setID)/\(sID)' has no animation image. ")
                    }
                    let img = APNGImage(data: data)
                    return img
                }
            }
        }else{
            let data = APNGImage(contentsOfFile: path)
            return data
        }
        return nil
    }

    func getStaticImage()->NSData?{
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/\(sID).png")
        if !fileManager.fileExistsAtPath(path) {
            if let url = NSURL(string: api.getStickerImage(setID, stickerID: sID)) {
                if let data = NSData(contentsOfURL: url){
                    let success = data.writeToFile(path, atomically: true)
                    if !success {
                        print("Store image'\(setID)/\(sID)' failed. ")
                    }
                    return data
                }
            }
        }else{
            let data = NSData(contentsOfFile: path)
            return data
        }
        return nil
    }
    
    func getSound()->String?{
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("sound/\(setID)/\(sID).m4a")
        if !fileManager.fileExistsAtPath(path) {
            if let url = NSURL(string: api.getSoundUrl(setID, stickerID: sID)) {
                if let data = NSData(contentsOfURL: url){
                    let success = data.writeToFile(path, atomically: true)
                    if !success {
                        print("Store sound'\(setID)/\(sID)' failed. ")
                    }
                    return path
                }
            }
        }else{
            return path
        }
        return nil
    }

    
}