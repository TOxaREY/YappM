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

var i = 0

class InterfaceController: WKInterfaceController {

    @IBOutlet var redButtonOut: WKInterfaceButton!
    @IBAction func redButton() {
        i += 1
        if i == 1 {
        redButtonOut.setBackgroundColor(.green)
        } else {
            redButtonOut.setBackgroundColor(.red)
            i = 0
        }

        if (WCSession.default.isReachable) {
            let messageToPhone = ["command": "watch"]
            WCSession.default.sendMessage(messageToPhone, replyHandler: nil)
        }

    }
    @IBOutlet var flagPick: WKInterfaceLabel!
    @IBOutlet var resultCount: WKInterfaceLabel!
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
