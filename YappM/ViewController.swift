//
//  ViewController.swift
//  YappM
//
//  Created by REYNIKOV ANTON on 12.04.2018.
//  Copyright © 2018 REYNIKOV ANTON. All rights reserved.
//

import UIKit
import Alamofire

struct  Datas:Decodable {
    let data:[Isos]
}
struct  Isos:Decodable {
    let country_iso_code:String
}

let letters = ["A":"\u{1F1E6}","B":"\u{1F1E7}","C":"\u{1F1E8}","D":"\u{1F1E9}","E":"\u{1F1EA}","F":"\u{1F1EB}","G":"\u{1F1EC}","H":"\u{1F1ED}","I":"\u{1F1EE}","J":"\u{1F1EF}","K":"\u{1F1F0}","L":"\u{1F1F1}","M":"\u{1F1F2}","N":"\u{1F1F3}","O":"\u{1F1F4}","P":"\u{1F1F5}","Q":"\u{1F1F6}","R":"\u{1F1F7}","S":"\u{1F1F8}","T":"\u{1F1F9}","U":"\u{1F1FA}","V":"\u{1F1FB}","W":"\u{1F1FC}","X":"\u{1F1FD}","Y":"\u{1F1FE}","Z":"\u{1F1FF}"]
var dateString = String()
let idAppBinatrix = "1087083"
let idAppHexastar = "1537733"


class ViewController: UIViewController {
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var countRes: UILabel!
    
    @IBAction func reset(_ sender: UIButton) {
        components(date: Date())
        picker.setDate(Date(), animated: true)
        self.spiner.stopAnimating()
        self.spiner.isHidden = true
    }
    @IBOutlet weak var picker: UIDatePicker!

    func request(idApp:String,dateString:String) {
        guard let url = URL(string: "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=\(idApp)&date_since=\(dateString)%2000%3A00%3A00&date_until=\(dateString)%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA") else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.setValue("max-age=120", forHTTPHeaderField: "Cache-Control")
    
            Alamofire.request(urlRequest)
                .responseString { response in
                    let statusCode = (response.response?.statusCode)!
                    switch statusCode {
                    case 202: self.refreshControl.beginRefreshing(); DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.request2(idApp: idApp, dateString: dateString)}
                    case 200: self.spiner.isHidden = true; self.spiner.stopAnimating(); self.refreshControl.endRefreshing(); self.request2(idApp: idApp, dateString: dateString)
                    default: break
                    }
            }
        }
    func request2(idApp:String,dateString:String) {
        guard let url = URL(string: "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=\(idApp)&date_since=\(dateString)%2000%3A00%3A00&date_until=\(dateString)%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA") else { return }
        var urlRequest = URLRequest(url: url)
    
        Alamofire.request(urlRequest)
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)!
                let result = response.data
                
       func jsonCount() {
                var count = 0
                var country = [String]()
                var flagString = String()
        
            do {
                let isoJson = try JSONDecoder().decode(Datas.self, from: result!)
                count = isoJson.data.count
                if count != 0 {
                for i in 0...count - 1 {
                country.append(isoJson.data[i].country_iso_code)
                }
                    for i in 0...count - 1 {
                        flagString.append(letters[String(country[i].first!)]! + letters[String(country[i].last!)]! + " ")
                    }
                    
                self.result.text = flagString
                self.countRes.text = String(count)
                } else {
                    self.result.text = ""
                    self.countRes.text = "0"
                }
            } catch {
                print("error JSON")
            }
        
            }
                switch statusCode {
                case 202: self.refreshControl.beginRefreshing(); DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.request2(idApp: idApp, dateString: dateString)}
                case 200: self.spiner.isHidden = true; self.spiner.stopAnimating(); self.refreshControl.endRefreshing(); jsonCount()
                default: break
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
    }
    @objc func refresh() {
        self.result.text = ""
        self.countRes.text = ""
        request(idApp: idAppBinatrix, dateString: dateString)
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.alwaysBounceVertical = true
        scroll.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        scroll.addSubview(refreshControl)
        spiner.startAnimating()
        components(date: Date())
        picker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
        request(idApp: idAppBinatrix, dateString: dateString)
//        request(idApp: idAppHexastar, dateString: dateString)
    }
}


