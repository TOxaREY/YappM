//
//  ExtensionDelegate.swift
//  YappMWatch Extension
//
//  Created by REYNIKOV ANTON on 16.05.2018.
//  Copyright © 2018 REYNIKOV ANTON. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func applicationDidFinishLaunching() {
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    func session(_ session: WCSession, didReceiveMessage messageToWatch: [String : Any]) {
        if messageToWatch["command"] as? String == "reset" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetButtonActive"), object: nil)
        }
        if messageToWatch["command"] as? String == "resetOff" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetButtonDeactive"), object: nil)
        }
        if messageToWatch["Count"] as? String != nil {
            WKInterfaceDevice().play(.notification)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notifToInterContr"), object: nil, userInfo: ["flags": messageToWatch["Flags"] as? String as Any, "count": messageToWatch["Count"] as? String as Any])
        }
    }
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
}
