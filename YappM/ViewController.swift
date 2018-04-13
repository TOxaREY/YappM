//
//  ViewController.swift
//  YappM
//
//  Created by REYNIKOV ANTON on 12.04.2018.
//  Copyright © 2018 REYNIKOV ANTON. All rights reserved.
//

import UIKit
import WebKit

var dateString = String()
let idAppHexastar = "1087083"
let idAppBinatrix = "1537733"
func request(idApp:String,dateString:String) {
    guard let url = URL(string: "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=\(idApp)&date_since=\(dateString)%2000%3A00%3A00&date_until=\(dateString)%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAATyhPde1n8j-kIhisiVQ7W6WIw") else { return }
    
    let session = URLSession.shared
    session.dataTask(with: url) { (data, response, error) in
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            print(statusCode)
        }
        guard let data = data else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:[])
            print(json)
        } catch {
        }
        }.resume()
}

class ViewController: UIViewController {
    @IBAction func reset(_ sender: UIButton) {
        components(date: Date())
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 3, to: Date())
        picker.setDate(date!, animated: true)
        print("date + 3 = \(date!)")
    }
    @IBOutlet weak var picker: UIDatePicker!

    @IBAction func requestButton(_ sender: UIButton) {
        request(idApp: idAppBinatrix, dateString: dateString)
        request(idApp: idAppHexastar, dateString: dateString)
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
            print(dateString)
            
        }
    }

    @objc func datePicker(_ sender: UIDatePicker) {
          components(date: sender.date)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        components(date: Date())
        picker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)

    }
}

