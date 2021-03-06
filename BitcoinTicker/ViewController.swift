//
//  ViewController.swift
//  BitcoinTracker
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
   let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
   let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
   let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
   var currencySelected = ""
   var finalURL = ""

   // IBOutlets
   @IBOutlet weak var bitcoinPriceLabel: UILabel!
   @IBOutlet weak var currencyPicker: UIPickerView!

   // View Loads (App Finishes Loading)
   override func viewDidLoad() {
      super.viewDidLoad()

      // Currency Picker Config
      currencyPicker.delegate = self
      currencyPicker.dataSource = self
   }

    
   // UIPickerView delegate methods
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return currencyArray.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return currencyArray[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      finalURL = baseURL + currencyArray[row]
      currencySelected = currencySymbolArray[row]
      getBitcoinData(url: finalURL)
      
   }
   
   
   // MARK: - Networking
   /***************************************************************/

   func getBitcoinData(url: String) {

     Alamofire.request(url, method: .get)
      .responseJSON { response in
         if response.result.isSuccess {
            // Debug: print("Sucess! Got the weather data")
            // Store JSON and Update data
            let bitcoinJSON : JSON = JSON(response.result.value!)
            self.updateBitcoinData(json: bitcoinJSON)

          } else { // Error Handling
            // Debug: print("Error: \(String(describing: response.result.error))")
            self.bitcoinPriceLabel.text = "Connection Issues"
          }
      }
   }
   
   // MARK: - JSON Parsing
   /***************************************************************/

   func updateBitcoinData(json : JSON) {
      if let bitcoinResult = json["ask"].double {
         bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinResult)"
      } else {
         bitcoinPriceLabel.text = "Price Unavailable"
      }
   }
   
}

