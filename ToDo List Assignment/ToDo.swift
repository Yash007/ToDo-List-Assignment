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
        return[
        ]
    }
}
