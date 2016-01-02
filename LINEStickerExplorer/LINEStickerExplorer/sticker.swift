//
//  sticker.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation
import UIKit

class sticker{
    var sID:Int = 0
    var setID:Int = 0
    var isAnimation:Bool = false
    var sImage:NSData?
    var image:UIImage?
    
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
    
    func loadImage(){
        sImage = getImage()
        image = UIImage(data: sImage!)
    }
    
    func getImage()->NSData?{
        
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/\(sID).png")
        if !fileManager.fileExistsAtPath(path) {
            let apiUrl = "https://sdl-stickershop.line.naver.jp/products/0/0/1/\(setID)/android/animation/\(sID).png"
            //print("APIURL: \(apiUrl)")
            if let url = NSURL(string: apiUrl) {
                if let data = NSData(contentsOfURL: url){
                    let success = data.writeToFile(path, atomically: true)
                    if !success {
                        print("Store image '\(setID)/\(sID).png' failed. ")
                    }else{
                        print("Store image '\(setID)/\(sID).png'. ")
                    }
                    return data
                }else{
                    let staticUrl = "https://sdl-stickershop.line.naver.jp/products/0/0/1/\(setID)/android/stickers/\(sID).png"
                    if let surl = NSURL(string: staticUrl){
                        if let sdata = NSData(contentsOfURL: surl){
                            let success = sdata.writeToFile(path, atomically: true)
                            if !success {
                                print("Store image '\(setID)/\(sID).png' failed. ")
                            }else{
                                print("Store image '\(setID)/\(sID).png'. ")
                            }
                            return sdata
                        }
                    }
                }
            }
            
        }else{
            let data = NSData(contentsOfFile: path)
            return data
        }
        return nil
    }

    
}