//
//  ToDo.swift
//  ToDo List Assignment
//
//  Created by YASH SOMPURA on 2018-01-03.
//  Copyright © 2018 YASH SOMPURA. All rights reserved.
//

import Foundation

class ToDo  {
    var title:String
    var done:Bool
    
    public init(title:String)   {
        self.title = title
        self.done = false
    }
}

extension ToDo  {
    public class func getMockData() -> [ToDo]   {
        return[
        ]
    }
}
