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
    var id : String!
    var url : NSURL!
    var path : NSURL!
    var cached : Bool!
    
    let fileManager = NSFileManager()
    let cacheDirectory = NSURL.init(string: NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String)
    
    
    init(id: String, title: String, url:String) {
        super.init()
        self.title = title
        self.id = id
        self.url = NSURL.init(string: url)
        self.path = cacheDirectory!.URLByAppendingPathComponent(self.url.lastPathComponent!)
        self.cached = fileManager.fileExistsAtPath(path.path!)
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.title = decoder.decodeObjectForKey("title") as! String
        self.url = decoder.decodeObjectForKey("url") as! NSURL
        self.id = decoder.decodeObjectForKey("id") as! String
        self.path = decoder.decodeObjectForKey("path") as! NSURL
        self.cached = fileManager.fileExistsAtPath(path.path!)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(path, forKey: "path")
    }
}
