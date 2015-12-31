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
    
    init(sID:Int, setID:Int){
        self.sID = sID
        self.setID = setID
    }
    
    func loadImage(){
        sImage = getImage()
        image = UIImage(data: sImage!)
    }
    
    func getImage()->NSData?{
        
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/\(sID).png")
        if !fileManager.fileExistsAtPath(path) {
            let apiUrl = "http://dl.stickershop.line.naver.jp/products/0/0/1/\(setID)/PC/stickers/\(sID).png"
            //print("APIURL: \(apiUrl)")
            if let url = NSURL(string: apiUrl) {
                let data = NSData(contentsOfURL: url)
                let success = data!.writeToFile(path, atomically: true)
                if !success {
                    print("Store image '\(setID)/\(sID).png' failed. ")
                }else{
                    print("Store image '\(setID)/\(sID).png'. ")
                }
                return data
            }
        }else{
            let data = NSData(contentsOfFile: path)
            return data
        }
        return nil
    }

    
}