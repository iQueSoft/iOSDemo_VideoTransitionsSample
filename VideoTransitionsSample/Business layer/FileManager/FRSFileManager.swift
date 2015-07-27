//
//  FRSFileManager.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/7/15.
//  Copyright (c) 2015 Work. All rights reserved.
//

import UIKit

class FRSFileManager: NSObject {
   
    func urlForVideo() -> NSURL? {
        
        if (self.checkVideosDirectory() == false) {
            return nil
        }

        var urlForVideo:NSURL? = nil
        let timestamp:Double = NSDate().timeIntervalSince1970 * 1000
        let path:String = NSTemporaryDirectory() + "Videos/video-" + String(format:"%f", timestamp) + ".MOV"
        urlForVideo = NSURL(fileURLWithPath: path)
        return urlForVideo

    }
    
    func clearVideosDirectory() -> Bool {
    
        let path:String = NSTemporaryDirectory() + "/Videos/"
        let isDirectory:Bool = NSFileManager.defaultManager().fileExistsAtPath(path)
        
        if (isDirectory == false) {
            return true;
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
            return true
        } catch _ {
            return false
        }
        
    }
    
    func removeFile(fileURL:NSURL?) -> NSError? {
        
        if (fileURL == nil) {
            return nil
        }
        
        var error: NSError?
        
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL!.path!)) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(fileURL!.path!)
            } catch let error1 as NSError {
                error = error1
            }
        }
        
        return error
    }
    
    func checkFileExists(fileURL:NSURL?) -> Bool {
        if (fileURL == nil) {
            return false
        }
        return NSFileManager.defaultManager().fileExistsAtPath(fileURL!.path!)
    }
    
    // MARK: private
    
    private func checkVideosDirectory() -> Bool {
        
        var path:String = NSTemporaryDirectory() + "/Videos/"
        let isDirectory:Bool = NSFileManager.defaultManager().fileExistsAtPath(path)
        
        if (isDirectory == true) {
            return true;
        }
        
        path = NSTemporaryDirectory() + "/Videos"
        let url: NSURL = NSURL(fileURLWithPath: path)
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch _ {
            return false
        }
    }
}