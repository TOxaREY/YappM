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


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var startButtonOut: WKInterfaceButton!
    @IBAction func startButton() {
    }
    @IBOutlet var queryButtonOut: WKInterfaceButton!
    @IBAction func queryButton() {
        flagPick.setText("request")
        resultCount.setText(" ")
        queryButtonOut.setEnabled(false)
        queryButtonOut.setBackgroundColor(UIColor.gray)
        if (WCSession.default.isReachable) {
            let messageToPhone = ["command": "request"]
            WCSession.default.sendMessage(messageToPhone, replyHandler: nil)
        }
    }
    @IBOutlet var resetButtonOut: WKInterfaceButton!
    @IBOutlet var flagPick: WKInterfaceLabel!
    @IBOutlet var resultCount: WKInterfaceLabel!
    @IBAction func resetButton() {
        resetButtonOut.setEnabled(false)
        resetButtonOut.setBackgroundColor(UIColor.gray)
        flagPick.setText("reset")
        if (WCSession.default.isReachable) {
            let messageToPhone = ["command": "reset"]
            WCSession.default.sendMessage(messageToPhone, replyHandler: nil)
        }
    }
    func catchNotification(notification:Notification) -> Void {
        let flags = notification.userInfo!["flags"]
        let count = notification.userInfo!["count"]
        flagPick.setText(flags as? String)
        resultCount.setText(count as? String)
        queryButtonOut.setEnabled(true)
        queryButtonOut.setBackgroundColor(UIColor(red:0.13, green:0.76, blue:0.05, alpha:1.0))
        resetButtonOut.setEnabled(false)
        resetButtonOut.setBackgroundColor(UIColor.gray)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    @objc func resetButtonActive() {
        resetButtonOut.setEnabled(true)
        resetButtonOut.setBackgroundColor(UIColor(red:0.89, green:0.01, blue:0.01, alpha:1.0))
    }
    @objc func resetButtonDeactive() {
        resetButtonOut.setEnabled(false)
        resetButtonOut.setBackgroundColor(UIColor.gray)
        queryButtonOut.setEnabled(true)
        queryButtonOut.setBackgroundColor(UIColor(red:0.13, green:0.76, blue:0.05, alpha:1.0))
        flagPick.setText("⇩")
    }
    
    override func willActivate() {
        super.willActivate()
        resetButtonOut.setBackgroundColor(UIColor.gray)
        resetButtonOut.setEnabled(false)
        queryButtonOut.setBackgroundColor(UIColor(red:0.13, green:0.76, blue:0.05, alpha:1.0))
        NotificationCenter.default.addObserver(self, selector: #selector(resetButtonActive), name: NSNotification.Name(rawValue: "resetButtonActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetButtonDeactive), name: NSNotification.Name(rawValue: "resetButtonDeactive"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "notifToInterContr"), object: nil, queue: nil, using: catchNotification)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
