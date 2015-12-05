//
//  NetworkKit.swift
//  PMusic
//
//  Created by YourtionGuo on 12/3/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

class NetworkKit: NSObject {
    
    static func request(method: String, url: String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), callback: (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            callback(data: data, response: response , error: error)
        })
        task.resume()
    }
    
    static func get(url: String, callback: (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void) {
        NetworkKit.request("GET", url: url, callback: callback);
    }
    
}

class DwonloadManager:NSObject, NSURLSessionDownloadDelegate {
    
    let finishCallback: (url: NSURL!, file: NSURL!) -> Void
    let taskCallback: (written: Int64, totalBytes: Int64,progress: Float) -> Void
    
    var session: NSURLSession!
    let url: NSURL!
    let file: NSURL!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    init(url: NSURL,file: NSURL!,
        taskCallback: (written: Int64, totalBytes: Int64,progress: Float) -> Void,
        finishCallback: (url: NSURL!, file: NSURL!) -> Void) {
        self.url = url
        self.file = file
        self.request = NSMutableURLRequest(URL: url)
        self.taskCallback = taskCallback
        self.finishCallback = finishCallback
        self.session = nil
    }
    
    func currentSession() -> NSURLSession{
        var predicate:dispatch_once_t = 0
        var currentSession:NSURLSession? = nil
        
        dispatch_once(&predicate, {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            currentSession = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        })
        return currentSession!
    }
    
    //下载文件
    func fire(){
        self.session = currentSession()
        let downloadTask = self.session.downloadTaskWithRequest(request)
        //使用resume方法启动任务
        downloadTask.resume()
    }
    
    //下载代理方法，下载结束
    @objc func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL) {
            //下载结束
            print("下载结束")
            //输出下载文件原来的存放目录
            print("location:\(location)")
            let fileManager:NSFileManager = NSFileManager.defaultManager()
            let filePath = self.file
            do {
                try fileManager.moveItemAtURL(location, toURL: filePath!)
            } catch let error as NSError {
                print("Error :", error.description)
                return self.finishCallback(url: nil, file: nil)
            }
            self.finishCallback(url: self.url, file: self.file)
    }
    
    //下载代理方法，监听下载进度
    @objc func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            //获取进度
            let written = totalBytesWritten
            let total = totalBytesExpectedToWrite
            let progress = Float(written)/Float(total)
            self.taskCallback(written: written, totalBytes: total, progress: progress)
//            print("下载进度：\(pro)")
    }
}