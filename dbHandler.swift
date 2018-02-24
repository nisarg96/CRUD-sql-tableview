//
//  dbHandler.swift
//  sqliteDemo
//
//  Created by tops on 2/17/18.
//  Copyright © 2018 tops. All rights reserved.
//

import Foundation
import UIKit

//step 2 code: Model db file

class dbModel: NSObject {
    
    var dbFilePath = ""
    var dbObj:OpaquePointer?
    
    override init() {
        super.init()
        
        //A: get database file path from appdelegate to this file
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        self.dbFilePath = appDel.dbPath
    }
    
    //B: check it is possible to open this database or not
    
    private func getDbObject() -> Bool {
        
        if(sqlite3_open(self.dbFilePath, &dbObj) == SQLITE_OK)
        {
            print("Database is Open!")
            return true
        }
        else{
            print("Database is not Open!")
            return false
        }
    }
    
    //C: command run
    
    func RunCommand(_ cmd:String) -> Bool {
        
        var isDone = true
        
        if(self.getDbObject())
        {
            //C-1 : Create command pointer
            
            var stmt:OpaquePointer?
            
            if(sqlite3_prepare_v2(dbObj, cmd, -1, &stmt, nil) == SQLITE_OK)
            {
                
            //C-2: execute statment
                
                sqlite3_step(stmt)
                sqlite3_finalize(stmt)
                sqlite3_close(dbObj)
            }
        }
        else {
            isDone = false
        }
        
        return isDone
    }
    
    //D: Query Run
    
    func QueryCommand(_ query:String) -> [[String:Any]] {
        
        var arrData = [[String:Any]]()
        var row = [String:Any]()
        
        if(self.getDbObject())
        {//C-1 : Create query pointer
            
            var stmt:OpaquePointer?
            if(sqlite3_prepare_v2(dbObj, query, -1, &stmt, nil) == SQLITE_OK)
            {//C-2: execute statment
                
                while(sqlite3_step(stmt)==SQLITE_ROW)
                {
                    row = [String:Any]()
                    let nocols = sqlite3_column_count(stmt)
                    
                    for i in 0..<nocols{
                        let key = String.init(cString: (sqlite3_column_name(stmt, i)))
                        let val = String.init(cString: (sqlite3_column_text(stmt, i)))
                        
                        row[key] = val
                    }
                    arrData.append(row)
                }
                sqlite3_finalize(stmt)
                sqlite3_close(dbObj)
            }
        }
        return arrData
    }
}
