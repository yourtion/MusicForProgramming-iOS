//
//  NetworkKit.swift
//  PMusic
//
//  Created by YourtionGuo on 12/3/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

class NetworkKit {
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
