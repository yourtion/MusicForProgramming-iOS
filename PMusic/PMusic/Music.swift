//
//  Music.swift
//  PMusic
//
//  Created by YourtionGuo on 11/28/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

class Music: NSObject, NSCoding {
    var title : String!
    var url : NSURL!
    var path : NSURL!
    
    init(url:NSURL) {
        super.init()
        self.title = ""
        self.url = url
        self.path = NSURL.init()
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.title = decoder.decodeObjectForKey("title") as! String
        self.url = decoder.decodeObjectForKey("url") as! NSURL
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
}
