//
//  ViewController.swift
//  tippy
//
//  Created by Konstantin Novichenko on 8/12/20.
//  Copyright © 2020 konst_nvc. All rights reserved.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var customTipLabel: UILabel!
    @IBOutlet weak var customTipField: UITextField!
    
    
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var billAmountTextLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    var originalBackgroundColor: UIColor!
    var originalTipControlColor: UIColor!
    @IBOutlet weak var uiBar: UIView!
    var uiBarColor: UIColor!
    
    var hideCustomPercentageFields = true
    var darkMode = false
    var viewWasLoaded = false
    
    
    
    
    
    func saveData() {
        print("saving")
        self.defaults.set(billField.text, forKey: "bill")
        self.defaults.set(customTipField.text, forKey: "customTips")
        self.defaults.set(tipControl.selectedSegmentIndex, forKey: "tipControlIndex")
        //let formatter = DateFormatter()
        let exitDate = Date()
        print(exitDate)
        self.defaults.set(exitDate, forKey: "savedOn")
        
    }
    
    @objc func loadSavedData() {
        print("Loading")
        let lastSession = self.defaults.value(forKey: "savedOn") as? Date ?? Date()
        if Date().timeIntervalSince1970 - lastSession.timeIntervalSince1970 < 30.0 {
            print("less than 30s")
            billField.text = self.defaults.string(forKey: "bill")
            customTipField.text = self.defaults.string(forKey: "customTips")
            tipControl.selectedSegmentIndex = self.defaults.integer(forKey: "tipControlIndex")
        }
        else{
            print("more than 30s")
            billField.text = ""
            customTipField.text = ""
            tipControl.selectedSegmentIndex = 0
        }
        
        self.calculateTip(self)
        print("Finished Loading")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadSavedData),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        
        originalBackgroundColor = self.view.backgroundColor
        originalTipControlColor = self.tipControl.tintColor
        uiBarColor = self.uiBar.backgroundColor
        self.loadSavedData()
        
        
        hideCustomPercentageFields = self.defaults.bool(forKey: "hideCustomPercentageFields")
        darkMode = self.defaults.bool(forKey: "darkMode")
        
        hideCustomTipPercentage(hide: hideCustomPercentageFields)
        setDarkMode(mode: darkMode)
        // Do any additional setup after loading the view.
        self.calculateTip(self)
        viewWasLoaded = true
    }
    
    func hideCustomTipPercentage(hide: Bool) {
        if hide {
            customTipLabel.isHidden = true
            customTipField.isHidden = true
            tipControl.isHidden = false
            
        }
        else{
            customTipLabel.isHidden = false
            customTipField.isHidden = false
            tipControl.isHidden = true
        }
        self.calculateTip(self)
    }
    
    func setDarkMode(mode: Bool) {
        if mode {
            self.view.backgroundColor = UIColor.black
            
            self.tipLabel.textColor = UIColor.white
            self.totalLabel.textColor = UIColor.white
            self.uiBar.backgroundColor = UIColor.lightGray
            self.billField.backgroundColor = UIColor.lightGray
            self.billField.textColor = UIColor.white
            self.customTipLabel.textColor = UIColor.white
            self.tipTextLabel.textColor = UIColor.white
            self.billAmountTextLabel.textColor = UIColor.white
            self.totalTextLabel.textColor = UIColor.white
            self.customTipField.backgroundColor = UIColor.lightGray
            self.customTipField.textColor = UIColor.white
        }
        else{
            
            self.view.backgroundColor = originalBackgroundColor
            self.tipLabel.textColor = UIColor.black
            self.totalLabel.textColor = UIColor.black
            self.uiBar.backgroundColor = uiBarColor
            self.tipControl.tintColor = originalTipControlColor
            self.billField.backgroundColor = UIColor.white
            self.billField.textColor = UIColor.black
            self.customTipLabel.textColor = UIColor.black
            self.tipTextLabel.textColor = UIColor.black
            self.billAmountTextLabel.textColor = UIColor.black
            self.totalTextLabel.textColor = UIColor.black
            self.customTipField.backgroundColor = UIColor.white
            self.customTipField.textColor = UIColor.black
        }
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        // Get the bill amount
        let bill = Double(billField.text!) ?? 0
        
        
        // Calculate the tip and total
        var tip: Double
        if hideCustomPercentageFields {
            let tipPercentages = [0.15, 0.18, 0.2]
            
            tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        }
        else{
            let customTipsP = (Double(customTipField.text!) ?? 0 ) / 100
            tip = bill * customTipsP
        }
        
        let total = bill + tip
        // Update the tip label and the total label
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        self.saveData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.darkModeOn = darkMode
        settingsViewController.isCustomTipsOn = !hideCustomPercentageFields
        
    }
    
    deinit {
        NotificationCenter.default .removeObserver(self)
    }
}

