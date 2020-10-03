//
//  SettingsViewController.swift
//  tippy
//
//  Created by Konstantin Novichenko on 10/2/20.
//  Copyright © 2020 konst_nvc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var customPercentageSwitch: UISwitch!
    var isCustomTipsOn: Bool!
    var darkModeOn: Bool!
    var originalBackgroundColor: UIColor!
    @IBOutlet weak var customTipPercentageLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        originalBackgroundColor = self.view.backgroundColor
        customPercentageSwitch.isOn = isCustomTipsOn
        darkModeSwitch.isOn = darkModeOn
        navigationController?.delegate = self
        self.setDarkMode(mode: darkModeOn)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func darkModeSwitchFlipped(_ sender: UISwitch) {
        self.setDarkMode(mode: darkModeSwitch.isOn)
    }
    

    @IBAction func percentageSwitchFlipped(_ sender: UISwitch) {
        if customPercentageSwitch.isOn {
            isCustomTipsOn = true
        }
        else {
            isCustomTipsOn = false
        }
        self.defaults.set(!isCustomTipsOn, forKey: "hideCustomPercentageFields")
    }
    
    func setDarkMode(mode: Bool) {
        if mode {
            self.view.backgroundColor = UIColor.black
            self.customTipPercentageLabel.textColor = UIColor.white
            self.darkModeLabel.textColor = UIColor.white
            darkModeOn = true
            isCustomTipsOn = true
        }
        else{
            self.view.backgroundColor = originalBackgroundColor
            self.customTipPercentageLabel.textColor = UIColor.black
            self.darkModeLabel.textColor = UIColor.black
            darkModeOn = false
        }
        self.defaults.set(darkModeOn, forKey: "darkMode")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let viewController = segue.destination as! ViewController
        viewController.hideCustomTipPercentage(hide: isCustomTipsOn)
        
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let navigationController: UINavigationController = self.navigationController!
        
        let controllers: [ViewController] = navigationController.viewControllers.filter({ $0 is ViewController }) as! [ViewController]
        
        if let viewController: ViewController = controllers.first {
            viewController.hideCustomPercentageFields = !isCustomTipsOn
            viewController.hideCustomTipPercentage(hide: !isCustomTipsOn)
            viewController.darkMode = darkModeOn
            viewController.setDarkMode(mode: darkModeOn)
        }
    }
}
