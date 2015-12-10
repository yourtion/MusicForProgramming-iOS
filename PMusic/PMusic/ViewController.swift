//
//  ViewController.swift
//  PMusic
//
//  Created by YourtionGuo on 11/28/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var musics = Array<Music>()
    private var isDownloading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MusicManager.sharedInstance.getList { (musicList) -> Void in
            print(musicList)
            self.musics = musicList
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")
        let music = self.musics[indexPath.row]
        cell?.textLabel?.text = music.title
        let detail = (music.cached != nil && music.cached != false)  ? "Paly" : "Download"
        cell?.detailTextLabel?.text = detail
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        if (!self.isDownloading) {
            let music = self.musics[indexPath.row]
            self.isDownloading = true
            MusicManager.sharedInstance.downloadMusic(music, task: { (written, total, progress) -> Void in
                let pro = String(format: "%.2f", progress * 100)
//                print("Download : ", written, " - ", total, " - ", pro )
                dispatch_async(dispatch_get_main_queue()) { Void in
                    let str = written + "/" + total + "(" + pro + "%)"
                    cell?.detailTextLabel?.text = str
                }
                }, finish: { (file) -> Void in
                    cell?.detailTextLabel?.text = "Play"
                    print("Done")
            })
        }
    }
    
}
