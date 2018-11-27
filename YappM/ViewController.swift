//
//  ViewController.swift
//  YappM
//
//  Created by REYNIKOV ANTON on 12.04.2018.
//  Copyright © 2018 REYNIKOV ANTON. All rights reserved.
//

import UIKit
import Alamofire
import WatchConnectivity

var biCountry = Int()
var biFlagString = String()
var hexCountry = Int()
var hexFlagString = String()
var req = 0

struct  Datas:Decodable {
    let data:[Isos]
}
struct  Isos:Decodable {
    let country_iso_code:String
}
struct Total:Decodable {
    let total:String
}

let letters = ["A":"\u{1F1E6}","B":"\u{1F1E7}","C":"\u{1F1E8}","D":"\u{1F1E9}","E":"\u{1F1EA}","F":"\u{1F1EB}","G":"\u{1F1EC}","H":"\u{1F1ED}","I":"\u{1F1EE}","J":"\u{1F1EF}","K":"\u{1F1F0}","L":"\u{1F1F1}","M":"\u{1F1F2}","N":"\u{1F1F3}","O":"\u{1F1F4}","P":"\u{1F1F5}","Q":"\u{1F1F6}","R":"\u{1F1F7}","S":"\u{1F1F8}","T":"\u{1F1F9}","U":"\u{1F1FA}","V":"\u{1F1FB}","W":"\u{1F1FC}","X":"\u{1F1FD}","Y":"\u{1F1FE}","Z":"\u{1F1FF}"]
var dateString = String()
let idAppBinatrix = "1087083"
let idAppHexastar = "1537733"


class ViewController: UIViewController {
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var lLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var countRes: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func reset(_ sender: Any) {
        reset()
    }
    func reset() {
        req = 1000
        result.text = "reset"
        resetButton.isEnabled = false
    }
    @IBOutlet weak var today: UIButton!
    @IBAction func today(_ sender: UIButton) {
        components(date: Date())
        picker.setDate(Date(), animated: true)
        result.text = "⇩"
        countRes.text = ""
        lLabel.text = ""
        rLabel.text = ""
    }
    @IBOutlet weak var picker: UIDatePicker!

    func putToken()  {
        if UserDefaults.standard.string(forKey: "TokenDevice") != nil {
            let params: [String: Any] = ["tokenDevice" : UserDefaults.standard.string(forKey: "TokenDevice")!]
            Alamofire.request("http://33.33.33.33:8000/token/5b7784e05030c080cd04e160", method: .put, parameters: params).responseJSON { (response) in
                guard response.result.isSuccess else{return}
                let val = (response.value)!
                print("put token \(val)")
            }
        }
    }
    func getTotal() {
        Alamofire.request("http://33.33.33.33:8000/token/5b8294fc39e954f40cde575b", method: .get).responseJSON
            { (response) in
            guard response.result.isSuccess else{return}
            let result = response.data
                do {
                    let totalJson = try JSONDecoder().decode(Total.self, from: result!)
                    let total = totalJson.total
                    print("get total \(total)")
                    if Int(total) != nil {
                    UserDefaults.standard.set(total, forKey: "TotalCount")
                  }
                }
                catch {
                    print("error JSON")
                }
        }
    }
    
    func request(idApp:String,dateString:String) {
        if req == 1000 {
            if idApp=="1087083" {
                if rLabel.text == "OK" || rLabel.text == "error" {
                    rLabel.text = "reset"
                    lLabel.text = "reset"
                } else {
                lLabel.text = "reset"
                }
            } else {
                if lLabel.text == "OK" || lLabel.text == "error" {
                    lLabel.text = "reset"
                    rLabel.text = "reset"
                } else {
                    rLabel.text = "reset"
                }
            }
            if  rLabel.text == "reset" && lLabel.text == "reset" {
                result.text = "⇩"
                rLabel.text = ""
                lLabel.text = ""
                refreshControl.endRefreshing()
                today.isEnabled = true
                picker.isEnabled = true
                req = 0
                if (WCSession.default.isReachable) {
                    let messageToWatch = ["command": "resetOff"]
                    WCSession.default.sendMessage(messageToWatch, replyHandler: nil)
                }
            }
        } else {
               if req < 20 {
        // guard let url = URL(string: "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=\(idApp)&date_since=\(dateString)%2000%3A00%3A00&date_until=\(dateString)%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA") else { return }
            guard let url = URL(string: "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=\(idApp)&date_since=\(dateString)%2000%3A00%3A00&date_until=\(dateString)%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code") else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.setValue("max-age=60", forHTTPHeaderField: "Cache-Control")
            urlRequest.setValue("OAuth AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA", forHTTPHeaderField: "Authorization")
            urlRequest.timeoutInterval = 30
        
           Alamofire.request(urlRequest)
                .responseString { response in
                    guard response.result.isSuccess else {
                        print("Error response: \(String(describing: response.result.error))")
                        return self.request(idApp: idApp, dateString: dateString)
                    }
                    let statusCode = (response.response?.statusCode)!
                    let result = response.data
                    if idApp=="1087083" {
                        if statusCode == 202 {
                            self.lLabel.text = "request"
                        }
                        if statusCode == 200 {
                            self.lLabel.text = "OK"
                        }
                    } else {
                        self.resetButton.isEnabled = true
                        if statusCode == 202 {
                            self.rLabel.text = "request"
                        }
                        if statusCode == 200 {
                            self.rLabel.text = "OK"
                        }
                    }
                            switch statusCode {
                            case 202: req += 1; self.result.text = String(req); DispatchQueue.main.asyncAfter(deadline: .now() + 6) {self.request(idApp: idApp, dateString: dateString)}
                            case 200: self.jsonCount(result: result!, idApp: idApp); self.resulView()
                            default: break
                             }
                        }
               } else {
                            if idApp=="1087083" {
                                lLabel.text = "error"
                                } else {
                                   rLabel.text = "error"
                            }
                            if rLabel.text == "error" && lLabel.text == "error" {
                                resetButton.isEnabled = false
                                result.text = "reload⇩"
                                rLabel.text = ""
                                lLabel.text = ""
                                today.isEnabled = true
                                picker.isEnabled = true
                                refreshControl.endRefreshing()
                           }
                }
         }
    }
    
    func jsonCount(result:Data, idApp:String) {
        if idApp == "1087083"{
            biFlagString = ""
            biCountry = 0
        } else {
            hexFlagString = ""
            hexCountry = 0
        }
        var count = 0
        var country = [String]()
        var flagString = String()
        
        do {
            let isoJson = try JSONDecoder().decode(Datas.self, from: result)
            count = isoJson.data.count
            if count != 0 {
                for i in 0...count - 1 {
                    country.append(isoJson.data[i].country_iso_code)
                }
                for i in 0...count - 1 {
                    if country[i] == "" {
                        flagString.append("\u{1F3F3}" + "\u{FE0F}" + "\u{200D}" + "\u{1F308}")
                    } else {
                    flagString.append(letters[String(country[i].first!)]! + letters[String(country[i].last!)]! + " ")
                  }
                }
                if idApp == "1087083"{
                  biFlagString += flagString
                  biCountry += count
                } else {
                    hexFlagString += flagString
                    hexCountry += count
                }
            }
        } catch {
            print("error JSON")
      }
    }
    func resulView() {
    if rLabel.text == "OK" && lLabel.text == "OK" {
        req = 0
        today.isEnabled = true
        picker.isEnabled = true
        resetButton.isEnabled = false
        refreshControl.endRefreshing()
        result.text = biFlagString + hexFlagString
        if UserDefaults.standard.string(forKey: "Today") == dateString {
        countRes.text = String(biCountry + hexCountry) + "/" + String(Int(UserDefaults.standard.string(forKey: "TotalCount")!)! + biCountry + hexCountry)
            if (WCSession.default.isReachable) {
                let messageToWatch = ["Flags": "\(biFlagString)\(hexFlagString)","Count":"\(String(biCountry + hexCountry) + "/" + String(Int(UserDefaults.standard.string(forKey: "TotalCount")!)! + biCountry + hexCountry))"]
                WCSession.default.sendMessage(messageToWatch, replyHandler: nil)
            }
        } else {
            countRes.text = String(biCountry + hexCountry)
        if (WCSession.default.isReachable) {
            let messageToWatch = ["Flags": "\(biFlagString)\(hexFlagString)","Count":"\(String(biCountry + hexCountry))"]
            WCSession.default.sendMessage(messageToWatch, replyHandler: nil)
          }
        }
    }
}
    
    func components(date:Date){
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let months:String
        let days:String
        let years:String
        if let day = components.day, let month = components.month, let year = components.year {
            if day < 10 {
                days = "0"+"\(String(day))"
            } else {
                days = String(day)
            }
            if month < 10 {
                months = "0"+"\(String(month))"
            } else {
                months = String(month)
            }
            years = String(year)
            dateString = "\(years)-\(months)-\(days)"
        }
    }

    @objc func datePicker(_ sender: UIDatePicker) {
        components(date: sender.date)
        picker.maximumDate = Date()
        result.text = "⇩"
        countRes.text = ""
        lLabel.text = ""
        rLabel.text = ""
    }
    
    @objc func refresh() {
        req = 0
        lLabel.text = ""
        rLabel.text = ""
        resetButton.isEnabled = false
        result.text = "start"
        countRes.text = ""
        today.isEnabled = false
        picker.isEnabled = false
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.request(idApp: idAppBinatrix, dateString: dateString)
            self.lLabel.text = "request"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.request(idApp: idAppHexastar, dateString: dateString)
            self.rLabel.text = "request"
            if (WCSession.default.isReachable) {
                let messageToWatch = ["command": "reset"]
                WCSession.default.sendMessage(messageToWatch, replyHandler: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        putToken()
        getTotal()
        result.text = "⇩"
        lLabel.text = ""
        rLabel.text = ""
        resetButton.isEnabled = false
        scroll.alwaysBounceVertical = true
        scroll.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        scroll.addSubview(refreshControl)
        components(date: Date())
        UserDefaults.standard.set(dateString, forKey: "Today")
        picker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
     }
}



