//
//  MusicManager.swift
//  PMusic
//
//  Created by YourtionGuo on 12/3/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation
import SWXMLHash

class MusicManager: NSObject {
    
    static let sharedInstance = MusicManager()
    private override init() {}
    
    private let RSS_URL = "http://musicforprogramming.net/rss.php"
    
    func getList() {
        NetworkKit.get(self.RSS_URL) { (data, response, error) -> Void in
            if data == nil {
                print("dataTaskWithRequest error: \(error)")
                return
            }
            self.parseXML(data)
            
        }
    }
    
    func parseXML(data: NSData) {
        let xml = SWXMLHash.parse(data)
//        print(xml["rss"]["channel"][0])
        let channel = xml["rss"]["channel"][0]
        var musicList : [Music] = []
        for elem in channel["item"] {
//            print(elem["title"].element!.text!)
//            print(elem["guid"].element!.text!)
            let titleElem = elem["title"].element!.text!
            let url = elem["guid"].element!.text!
            var titleArray = titleElem.componentsSeparatedByString(" ")
            let id = titleArray[1].stringByReplacingOccurrencesOfString(":", withString: "")
            let repleceString = titleArray[0] + " " + titleArray[1] + " "
            let title = titleElem.stringByReplacingOccurrencesOfString(repleceString, withString: "")
//            print(id ,titleArray, title)
            let music = Music.init(id: id, title: title, url: url)
            musicList.append(music)
        }
        print(musicList)
    }
}
