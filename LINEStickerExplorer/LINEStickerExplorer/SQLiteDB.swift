//
//  SQLiteDB.swift
//  JewelryDIY
//
//  Created by UnciaX on 2015/12/11.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation

class SQLiteDB {
    private var m_db:FMDatabase
    private var m_dbPath:String
    private let dbFilename:String = "my.db"
    
    init() {
        //create database file path at the document Directory
        let documentPath: AnyObject =
        NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)[0]
        
        m_dbPath = documentPath.stringByAppendingPathComponent(dbFilename)
        
        print("datebase file path : %@", m_dbPath)
        m_db = FMDatabase(path:m_dbPath)
        
        //initialize schema if does not create schema ever.
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(m_dbPath) {
            //db file not exist
            //initialize db schema
            if m_db.open() {
                m_db.executeUpdate(
                    "create table stickerSet(ID integer primary key, setID integer, setName text, setAuthor text, validDays integer, price integer)",
                    withArgumentsInArray: [])
                m_db.executeUpdate(
                    "create table sticker(sID integer primary key, setID integer)",
                    withArgumentsInArray: [])
                m_db.close()
                print("initialize database schema.")
            }
        }
    }
    
    func open() -> Bool {
        return m_db.open()
    }
    
    func close() -> Bool {
        return m_db.close()
    }
    
    func commit() -> Bool {
        return m_db.commit()
    }
 
    func insert(stickerSetStruct sSet:stickerSet,columnID id: Int)->Bool{
        // 插入珠寶資料進入SQLite
        if m_db.goodConnection() {
            m_db.beginTransaction()
            m_db.executeUpdate("insert into stickerSet(ID, setID, setName, setAuthor, validDays, price) values (?, ?, ?, ?, ?, ?)", withArgumentsInArray: [id, sSet.setID, sSet.setName, sSet.setAuthor, sSet.validDays, sSet.price])
            m_db.commit()
            return true
        }
        print("Insert a new record failed.")
        return false
    }
    
    func insert(stickerStruct s:sticker)->Bool{
        // 插入分類資料進入SQLite
        if m_db.goodConnection() {
            m_db.beginTransaction()
            m_db.executeUpdate("insert into sticker(sID, setID) values (?, ?)", withArgumentsInArray: [s.sID, s.setID])
            m_db.commit()
            return true
        }
        print("Insert a new record failed.")
        return false
    }
    
    func stickerSetQuery() -> [stickerSet]{
        open()
        var setArray = [stickerSet]()
        if !m_db.goodConnection() {
            return setArray;
        }
        
        let resultSet:FMResultSet =
        m_db.executeQuery("select * from stickerSet order by ID", withArgumentsInArray: [])
        
        while resultSet.next() {
            let item = stickerSet(setID: Int(resultSet.intForColumn("setID")), setName: resultSet.stringForColumn("setName"), setAuthor: resultSet.stringForColumn("setAuthor"), validDays: Int(resultSet.intForColumn("validDays")), price: Int(resultSet.intForColumn("price")))
            setArray.append(item)
        }
        close()
        return setArray
    }
    
    func stickerQuery(setID:Int) -> [sticker] {
        open()
        var sArray = [sticker]()
        if !m_db.goodConnection() {
            return sArray;
        }
        
        let resultSet:FMResultSet =
        m_db.executeQuery("select * from sticker where setID = ? order by sID", withArgumentsInArray: [setID])
        
        while resultSet.next() {
            let item = sticker(sID: Int(resultSet.intForColumn("sID")), setID: Int(resultSet.intForColumn("setID")))
            sArray.append(item)
            
        }
        close()
        return sArray
    }
    
    func count(tableName: String) -> Int? {
        open()
        if !m_db.goodConnection() {
            return nil
        }
        
        let resultSet:FMResultSet =
        m_db.executeQuery("select count(*) from \(tableName)", withArgumentsInArray: [])
        
        resultSet.next()
        let count:Int32 = resultSet.intForColumnIndex(0)
        close()
        return Int(count)
    }

    
    
}