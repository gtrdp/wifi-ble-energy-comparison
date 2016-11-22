//
//  History.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 25/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class History: NSObject, NSCoding {
    // MARK: Properties
    var method: String
    var sentPackets: String
    var timestamp: String
    var duration: String
    var timeInterval: String
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("histories")
    
    struct PropertyKey {
        static let methodKey = "method"
        static let sentPacketsKey = "packets"
        static let timestampKey = "timestamp"
        static let durationKey = "duration"
        static let timeIntervalKey = "timeInterval"
    }
    
    init(method: String, sentPackets: String, timestamp: String, duration: String, timeInterval: String) {
        self.method = method
        self.sentPackets = sentPackets
        self.timestamp = timestamp
        self.duration = duration
        self.timeInterval = timeInterval
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(method, forKey: PropertyKey.methodKey)
        aCoder.encodeObject(sentPackets, forKey: PropertyKey.sentPacketsKey)
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
        aCoder.encodeObject(duration, forKey: PropertyKey.durationKey)
        aCoder.encodeObject(timeInterval, forKey: PropertyKey.timeIntervalKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let method = aDecoder.decodeObjectForKey(PropertyKey.methodKey) as! String
        let sentPackets = aDecoder.decodeObjectForKey(PropertyKey.sentPacketsKey) as! String
        let timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! String
        let duration = aDecoder.decodeObjectForKey(PropertyKey.durationKey) as! String
        let timeInterval = aDecoder.decodeObjectForKey(PropertyKey.timeIntervalKey) as! String
        
        // Must call designated initializer.
        self.init(method: method, sentPackets: sentPackets, timestamp: timestamp, duration: duration, timeInterval: timeInterval)
    }
}
