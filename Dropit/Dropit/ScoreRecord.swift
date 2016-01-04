//
//  Score.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/17.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation

class ScoreRecord {
    
    struct Score {
        var score:Int
        var date:NSDate
        var mode:Int
        var duration:NSTimeInterval
    }
    
    var highestScore:Int = 0
    var ScoreList = [Score]()
    
    init(){
        getRecord()
        if ScoreList.count != 0 {
            highestScore = ScoreList[0].score
        }else{
            highestScore = 0
        }
    }
    
    func createANewRecord(score:Int, date:NSDate, mode:Int, duration:NSTimeInterval) -> Bool{
        // Will return ture if broke highest score record
        var isBroke = false
        let record = Score(score: score, date: date, mode: mode, duration: duration)
        if record.score > highestScore {
            highestScore = record.score
            isBroke = true
        }
        ScoreList.append(record)
        ScoreList.sortInPlace({$0.score > $1.score})
        saveRecord()
        return isBroke
    }
    
    func getRecord(){
        if let scoreRecord = NSUserDefaults.standardUserDefaults().arrayForKey("score") as? [Int]{
            if let dateRecord = NSUserDefaults.standardUserDefaults().arrayForKey("date") as? [NSDate]{
                if let modeRecord = NSUserDefaults.standardUserDefaults().arrayForKey("mode") as? [Int]{
                    if let durationRecord = NSUserDefaults.standardUserDefaults().arrayForKey("duration") as? [NSTimeInterval]{
                        for i in 0 ..< scoreRecord.count {
                            ScoreList.append(Score(score: scoreRecord[i], date: dateRecord[i], mode: modeRecord[i], duration: durationRecord[i]))
                        }
                    }
                }
            }
        }
    }
    
    func saveRecord(){
        let prefs = NSUserDefaults.standardUserDefaults()
        var scoreRecord = [Int]()
        var dateRecord = [NSDate]()
        var modeRecord = [Int]()
        var durationRecord = [NSTimeInterval]()
        for i in 0 ..< ScoreList.count {
            scoreRecord.append(ScoreList[i].score)
            dateRecord.append(ScoreList[i].date)
            modeRecord.append(ScoreList[i].mode)
            durationRecord.append(ScoreList[i].duration)
        }
        prefs.setObject(scoreRecord, forKey:"score")
        prefs.setObject(dateRecord, forKey:"date")
        prefs.setObject(modeRecord, forKey:"mode")
        prefs.setObject(durationRecord, forKey:"duration")
        prefs.synchronize()
    }
}

