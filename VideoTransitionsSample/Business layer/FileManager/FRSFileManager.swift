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
        var timestamp:Double = NSDate().timeIntervalSince1970 * 1000
        var path:String = NSTemporaryDirectory() + "Videos/video-" + String(format:"%f", timestamp) + ".MOV"
        urlForVideo = NSURL(fileURLWithPath: path)
        return urlForVideo

    }
    
    func clearVideosDirectory() -> Bool {
    
        var path:String = NSTemporaryDirectory() + "/Videos/"
        var isDirectory:Bool = NSFileManager.defaultManager().fileExistsAtPath(path)
        
        if (isDirectory == false) {
            return true;
        }
        
        return NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
        
    }
    
    func removeFile(fileURL:NSURL?) -> NSError? {
        
        if (fileURL == nil) {
            return nil
        }
        
        var error: NSError?
        
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL!.path!)) {
            NSFileManager.defaultManager().removeItemAtPath(fileURL!.path!, error: &error)
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
        var isDirectory:Bool = NSFileManager.defaultManager().fileExistsAtPath(path)
        
        if (isDirectory == true) {
            return true;
        }
        
        path = NSTemporaryDirectory() + "/Videos"
        var url: NSURL = NSURL(fileURLWithPath: path)!
        return NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
}