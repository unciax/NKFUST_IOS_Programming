//
//  DataCore.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/27.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation


class DataCore{
    
    var db:SQLiteDB
    var stickerSetID: [Int] = [1216096,1135932,1201529,1222256,1183925,1040299,1140113,1205314,1000085,1103444,1223891,1112263,1149289,2046,1000404,1064176,5033,5440,2999,1181547,1021884,5298,5271,5072,1579,1228274,4333,5256,5227,1152566,3775,1205692,1084331,5555,5476]
    var setArray:[stickerSet]
    var sArray:[sticker]

    init(){
        db = SQLiteDB()
        setArray = [stickerSet]()
        sArray = [sticker]()
    }
    
    func loadData() -> Bool{
        var isErrorOccured:Bool = false
        print("Process: LoadData")
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
        print("Load sticker set from LINE Website")
        db.open()
        for i in 0...stickerSetID.count-1{
            let apiUrl = "http://dl.stickershop.line.naver.jp/products/0/0/1/\(stickerSetID[i])/android/productInfo.meta"
            let response = NSData(contentsOfURL: NSURL(string: apiUrl)!)
            if response != nil {
                do{
                    //print("Has Response \(stickerSetID[i])")
                    try jsonDecoder(response!,type:"StickerSet",columnID: i+1)
                }catch _ {
                    db.close()
                    return false
                }
            }else{
                print("No Response \(stickerSetID[i])")
                db.close()
                return false
            }
        }
        db.close()
        return true
    }
    
    func getStickerInfo(setID :Int) -> Bool {
        print("Load sticker from LINE Website")
        db.open()
        let apiUrl = "http://dl.stickershop.line.naver.jp/products/0/0/1/\(setID)/android/productInfo.meta"
        let response = NSData(contentsOfURL: NSURL(string: apiUrl)!)
        if response != nil {
            do{
                print("Has Response \(setID)")
                try jsonDecoder(response!,type:"Sticker",columnID: setID)
            }catch _ {
                db.close()
                return false
            }
        }else{
            print("No Response \(setID)")
            db.close()
            return false
        }
        db.close()
        return true
    }

    
    func jsonDecoder(response:NSData, type:String, columnID count:Int) throws {
        db.open()
        let JSONObject:AnyObject = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.AllowFragments)
        switch type{
            case "Sticker":
                let stickerArray = JSONObject["stickers"] as! [[String: AnyObject]]
                for stickerItem in stickerArray{
                    if let id = stickerItem["id"] as? Int {
                        let st = sticker(sID: id, setID: count)
                        //st.loadImage()
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

}