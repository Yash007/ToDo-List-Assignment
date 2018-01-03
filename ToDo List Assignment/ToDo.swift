//
//  ToDo.swift
//  ToDo List Assignment
//
//  Created by YASH SOMPURA on 2018-01-03.
//  Copyright © 2018 YASH SOMPURA. All rights reserved.
//

import Foundation

class ToDo: NSObject, NSCoding {
    var title:String
    var done:Bool
    
    public init(title:String)   {
        self.title = title
        self.done = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String    {
            self.title = title
        }
        else    {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "done")   {
            self.done = aDecoder.decodeBool(forKey: "done")
        }
        else    {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.done, forKey: "done")
    }
}

extension ToDo  {
    public class func getMockData() -> [ToDo]   {
        return[]
    }
}

extension Collection where Iterator.Element == ToDo {
    
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("todo.bin")
    }
    
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "sompurayash.ToDo-List-Assignment", code: 10, userInfo: nil)
        }
    }
    
    static func readFromPersistence() throws -> [ToDo]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDo]
            {
                return array
            }
            else
            {
                throw NSError(domain: "sompurayash.ToDo-List-Assignment", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "sompurayash.ToDo-List-Assignment", code: 12, userInfo: nil)
        }
    }
}
