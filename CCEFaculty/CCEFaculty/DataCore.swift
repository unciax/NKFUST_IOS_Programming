//
//  DataCore.swift
//  CCEFaculty
//
//  Created by UnciaX on 2015/12/3.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataCore {
    var teacherArray = [Teacher]()
    //let ccee_api = "http://mlf.twbbs.org/nkfust/ccee_crawler/"
    let ccee_api = "http://www2.nkfust.edu.tw/~u0251055/ccee_crawler/static.txt"
    
    func loadData() -> Bool {
        var JSONObject:JSON=JSON(12345)
        var errCount=0;
        let data = NSData(contentsOfURL: NSURL(string: ccee_api)!)
        if (data != nil ){ JSONObject = JSON(data: data!) }
        while(data == nil){
            errCount++;
            print("try \(errCount) times.")
            let data = NSData(contentsOfURL: NSURL(string: ccee_api)!)
            if (data != nil ){ JSONObject = JSON(data: data!) }
            if(errCount>5) { break }
        }
        if( (data != nil) && !(errCount>5)){
            teacherArray = [Teacher]()
            print(JSONObject.count)
            for (_, subJson):(String,JSON) in JSONObject {
                let name = subJson["name"].string
                let education = subJson["education"].string
                let imageURL = subJson["imageURL"].string
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string:imageURL!)!)!)
                let email = subJson["email"].string
                let ext = subJson["ext"].int
                let office = subJson["office"].string
                print(name)
                teacherArray.append(Teacher(name:name!,education: education!,imageURL: imageURL!,image: image!,email: email!,ext: ext!, office:office!))
            }
            return true
        }else{
            return false
        }

    }
}