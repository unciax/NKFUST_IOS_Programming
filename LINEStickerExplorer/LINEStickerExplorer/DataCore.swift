//
//  DataCore.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation


class DataCore{
    // MARK: - Property
    // MARK: Database, API Property
    
    private let documentPath: AnyObject =
    NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask,
        true)[0]
    let api = LINEAPI()
    
    // MARK: DataCore variable
    
    var stickerSetID: [Int] = [1216096,1135932,1201529,1222256,1183925,1040299,1140113,1205314,1000085,1103444,1223891,1112263,1149289,2046,1000404,1064176,5033,5440,2999,1181547,1021884,5298,5271,5072,1579,1228274,4333,5256,5227,1152566,3775,4329,1084331,5555,5476]
    var db:SQLiteDB
    var setArray:[stickerSet]
    var sArray:[sticker]

    // MARK: Construct
    
    init(){
        db = SQLiteDB()
        setArray = [stickerSet]()
        sArray = [sticker]()
    }
    
    //MARK: - Function
    //MARK: Load Sticker / StickerSet
    
    func loadData() -> Bool{
        var isErrorOccured:Bool = false
        print("Process: LoadData")
        createTopFolder()
        db.open()
        setArray = db.stickerSetQuery()
        if setArray.count == 0 || db.count("stickerSet") != stickerSetID.count {
            isErrorOccured = !getStickerSetInfo()
            print("\(setArray.count)")
        }
        db.close()
        return isErrorOccured
    }
    
    func getStickerSetInfo() -> Bool {
        print("Downloading sticker set from LINE Website")
        db.open()
        for i in 0...stickerSetID.count-1{
            let response = NSData(contentsOfURL: NSURL(string: api.getSetInfo(stickerSetID[i]))!)
            if response != nil {
                do{
                    try jsonDecoder(response!,type:"StickerSet",columnID: i+1)
                }catch _ {
                    db.close()
                    return false
                }
            }else{
                print("Sticker:\(stickerSetID[i]) NO Response ")
                db.close()
                return false
            }
        }
        db.close()
        return true
    }
    
    func getStickerInfo(setID :Int) -> Bool {
        print("Downloading sticker from LINE store website")
        db.open()
        let response = NSData(contentsOfURL: NSURL(string: api.getSetInfo(setID))!)
        if response != nil {
            do{
                try jsonDecoder(response!,type:"Sticker",columnID: setID)
            }catch _ {
                db.close()
                return false
            }
        }else{
            print("Set:\(setID) NO Response.")
            db.close()
            return false
        }
        db.close()
        return true
    }

    // MARK: JSON Decoder
    
    func jsonDecoder(response:NSData, type:String, columnID count:Int) throws {
        db.open()
        let JSONObject:AnyObject = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.AllowFragments)
        switch type{
            case "Sticker":
                let stickerArray = JSONObject["stickers"] as! [[String: AnyObject]]
                for stickerItem in stickerArray{
                    if let id = stickerItem["id"] as? Int {
                        let st = sticker(sID: id, setID: count, isAnimation: setArray[setArray.indexOf({ $0.setID == count})!].hasAnimation)
                        sArray.append(st)
                        db.insert(stickerStruct: st)
                    }
                }
                break
            case "StickerSet":
                if let arrayList = JSONObject as? [String: AnyObject]{
                    let sSet = stickerSet(JSONObject: arrayList)
                        setArray.append(sSet)
                        db.insert(stickerSetStruct: sSet, columnID: count)
                }
                break
            default: break
        }
        db.close()
        
    }
    
    // MARK: I/O function
    
    func createTopFolder(){
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
        path = documentPath.stringByAppendingPathComponent("sound")
        if(!fileManager.fileExistsAtPath(path)){
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                print("Folder 'sound' create success.")
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        }
        
    }


}