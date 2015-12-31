//
//  stickerSet.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation

class stickerSet {
    var setID:Int = 0
    var setName:String = ""
    var setAuthor:String = ""
    var validDays:Int = 0
    var price:Int = 0
    var image:NSData?
    
    private let documentPath: AnyObject =
    NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask,
        true)[0]
    
    init(){
        // do nothing
    }
    
    init(setID:Int, setName:String, setAuthor:String, validDays:Int, price:Int){
        self.setID = setID
        self.setName = setName
        self.setAuthor = setAuthor
        self.validDays = validDays
        self.price = price
        self.image = getImage()
        
    }
    
    init(JSONObject:AnyObject){
        createFromJSON(JSONObject)
    }
    
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
        self.image = getImage()
        
    }
    
    func getImage()->NSData?{
        createFolder()
        
        let fileManager = NSFileManager.defaultManager()
        let path = documentPath.stringByAppendingPathComponent("image/\(setID)/main.png")
        if !fileManager.fileExistsAtPath(path) {
            let apiUrl = "https://sdl-stickershop.line.naver.jp/products/0/0/1/\(setID)/LINEStorePC/main.png"
            if let url = NSURL(string: apiUrl) {
                let data = NSData(contentsOfURL: url)
                let success = data!.writeToFile(path, atomically: true)
                if !success {
                    print("Store image '\(setID)/main.png' failed. ")
                }else{
                    //print("Store image '\(setID)/main.png'. ")
                }
                return data
            }
        }else{
            let data = NSData(contentsOfFile: path)
            return data
        }
        return nil
    }
    
    func createFolder(){
        var path = documentPath.stringByAppendingPathComponent("image")
        let fileManager = NSFileManager.defaultManager()
        
        if(!fileManager.fileExistsAtPath(path)){
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                print("Folder 'image' create success.")
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }
        path = documentPath.stringByAppendingPathComponent("image/\(setID)")
        if(!fileManager.fileExistsAtPath(path)){
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                print("Folder '\(setID)' create success.")
            } catch let error as NSError {
                NSLog(error.localizedDescription);
            }
        }

    }

}