//
//  stickerSet.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation

class stickerSet {
    
    // MARK: - Property
    // MARK: Common Property
    private let documentPath: AnyObject =
        NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)[0]
    let api = LINEAPI()
    let fileManager = NSFileManager.defaultManager()
    
    // MARK: StickerSet Info
    
    var setID:Int = 0
    var setName:String = ""
    var setAuthor:String = ""
    var validDays:Int = 0
    var price:Int = 0
    var hasAnimation:Bool = false
    var hasSound:Bool = false
    var image:NSData?
    
    // MARK: - Construct
    
    init(){
        // do nothing
    }
    
    
    init(setID:Int, setName:String, setAuthor:String, validDays:Int, price:Int, animation:Int, sound:Int){
        self.setID = setID
        self.setName = setName
        self.setAuthor = setAuthor
        self.validDays = validDays
        self.price = price
        self.image = getImage()
        self.hasAnimation = (animation == 1) ? true : false
        self.hasSound = (sound == 1) ? true : false
        
    }

    init(JSONObject:AnyObject){
        createFromJSON(JSONObject)
    }
    
    // MARK: - Function
    
    func createFromJSON(JSONObject:AnyObject){
        self.setID = JSONObject["packageId"] as! Int
        
        if let setName = JSONObject["title"]!["zh_TW"] as? String {
            self.setName = setName
        }else if let setName = JSONObject["title"]!["zh-Hant"] as? String{
            self.setName = setName
        }else if let setName = JSONObject["title"]!["ja"] as? String{
            self.setName = setName
        }else if let setName = JSONObject["title"]!["en"] as? String{
            self.setName = setName
        }
        
        if let author = JSONObject["author"]!["zh_TW"] as? String {
            self.setAuthor = author
        }else if let author = JSONObject["author"]!["zh-Hant"] as? String{
            self.setAuthor = author
        }else if let author = JSONObject["author"]!["ja"] as? String{
            self.setAuthor = author
        }else if let author = JSONObject["author"]!["en"] as? String{
            self.setAuthor = author
        }
        
        self.validDays = JSONObject["validDays"] as! Int
        
        let priceArray = JSONObject["price"] as! [[String: AnyObject]]
        for priceItem in priceArray{
            if let symbol = priceItem["symbol"] as? String {
                if symbol == "NLC" {
                    let price = priceItem["price"] as! Int
                    self.price = price
                }
            }
        }
        
        let stickerArray = JSONObject["stickers"] as! [[String: AnyObject]]
        for stickerItem in stickerArray{
            if let id = stickerItem["id"] as? Int {
                hasSound = checkIfHasSound(stickerID: id)
                hasAnimation = checkIfHasAnimation(stickerID: id)
                break
            }
        }
        createFolder(hasSound)
        
        self.image = getImage()
        
        
    }
    
    func checkIfHasSound(stickerID sid: Int) -> Bool {
        if let url = NSURL(string: api.getSoundUrl(setID, stickerID: sid)){
            if let _ = NSData(contentsOfURL: url){
                return true
            }
        }
        return false
    }
 
    func checkIfHasAnimation(stickerID sid: Int) -> Bool {
        if let url = NSURL(string: api.getAnimationSticker(setID, stickerID: sid)){
            if let _ = NSData(contentsOfURL: url){
                return true
            }
        }
        return false
    }
    
    func getImage()->NSData?{
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/main.png")
        
        if !fileManager.fileExistsAtPath(path) {
            if let url = NSURL(string: api.getSetMainSticker(setID)) {
                let data = NSData(contentsOfURL: url)
                let success = data!.writeToFile(path, atomically: true)
                if !success {
                    print("Store image '\(setID)/main.png' failed. ")
                }else{
                }
                return data
            }
        }else{
            let data = NSData(contentsOfFile: path)
            return data
        }
        return nil
    }
    
    // MARK: I/O function
    
    func createFolder(hasSound: Bool){
        var path = documentPath.stringByAppendingPathComponent("image/\(setID)")
        
        if(!fileManager.fileExistsAtPath(path)){
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                print("Image folder '\(setID)' create success.")
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }
        
        if(hasSound){
            path = documentPath.stringByAppendingPathComponent("sound/\(setID)")
            if(!fileManager.fileExistsAtPath(path)){
                do {
                    try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                    print("Sound folder '\(setID)' create success.")
                } catch let error as NSError {
                    NSLog(error.localizedDescription);
                }
            }
        }

    }

}