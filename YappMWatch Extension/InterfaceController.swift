//
//  InterfaceController.swift
//  YappMWatch Extension
//
//  Created by REYNIKOV ANTON on 16.05.2018.
//  Copyright © 2018 REYNIKOV ANTON. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    @IBAction func redButton() {
        if (WCSession.default.isReachable) {
            let messageToPhone = ["Welcome": "Hello"]
            WCSession.default.sendMessage(messageToPhone, replyHandler: nil)
        }
    }
    @IBOutlet var flagPick: WKInterfaceLabel!
    @IBOutlet var resultCount: WKInterfaceLabel!
    
    func session(_ session: WCSession, didReceiveMessage messageToWatch: [String : Any]) {
        WKInterfaceDevice().play(.notification)
        flagPick.setText(messageToWatch["Flags"] as? String)
        resultCount.setText(messageToWatch["Count"] as? String)
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
