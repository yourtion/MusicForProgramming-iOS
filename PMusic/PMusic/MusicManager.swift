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
    
//    private let RSS_URL = "http://musicforprogramming.net/rss.php"
    private let RSS_URL = "http://192.168.31.186:8080/rss.xml"
    private let MUSIC_KEY = "MusicList"
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    
    func getList(withCache:Bool = true,callback: (musicList: Array<Music>!) -> Void) {
        let musicList = self.getCachedList()
        if(musicList != nil && withCache){
            return callback(musicList: musicList)
        }
        NetworkKit.get(self.RSS_URL) { (data, response, error) -> Void in
            if data == nil {
                print("dataTaskWithRequest error: \(error)")
                return callback(musicList: [])
            }
            let list = self.parseXML(data)
            self.cacheList(list)
            callback(musicList: list)
        }
    }
    
    func parseXML(data: NSData) -> Array<Music> {
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
        return (musicList)
    }
    
    func cacheList(list:Array<Music>) {
        if (list.count > 0) {
            let obj = NSKeyedArchiver.archivedDataWithRootObject(list)
            self.defaults.setObject(obj, forKey: self.MUSIC_KEY)
            self.defaults.synchronize()
        }
    }
    
    func getCachedList() -> Array<Music>! {
        let obj = self.defaults.objectForKey(self.MUSIC_KEY)
        if (obj != nil){
            return NSKeyedUnarchiver.unarchiveObjectWithData(obj as! NSData) as! Array<Music>
        }
        return nil
    }
    
    func downloadMusic(music: Music,
        task: (written: String, total: String, progress: Float) -> Void,
        finish: (file: NSURL!) -> Void) {
        let down = DwonloadManager.init(url: music.url, file: music.path, taskCallback: { (written, totalBytes, progress) -> Void in
            print(progress)
            let finish = NSByteCountFormatter.stringFromByteCount(written, countStyle: .File)
            let total = NSByteCountFormatter.stringFromByteCount(totalBytes, countStyle: .File)
            task(written: finish, total: total, progress: progress)
            }) { (url, file) -> Void in
                finish(file: file)
            }
        down.fire()
    }
}
