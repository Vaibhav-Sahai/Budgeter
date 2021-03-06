//
//  BudgetSet.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 28/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
// performSegue(withIdentifier: "segue", sender: self)

import UIKit
import Foundation

class BudgetSet: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButtonPressed(_ sender: Any) {
        resetDefaults()
        validateFields()
        }

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var days: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var initialDateDifference: Int?
    var rightNow = Date()
    //MARK:- Checking Fields
    
    func validateFields(){
        if budgetText.text?.trimmingCharacters(in:  .whitespacesAndNewlines) == "" ||
            currencySymbol.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Label" ||
            days.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.alpha = 1
            
        }else{
            UserDefaults.standard.set(true, forKey: "IsLoggedIn")
            performSegue(withIdentifier: "segue", sender: self)
        }
    }

    //MARK:- Move Screen Up
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + 90
        } else{
            view.frame.origin.y = 0
        }
    }
    
    
    
    //MARK: - Picker View Configuration
    let currency = ["S/.", "$", "R$", "৳", "¥", "₹","€", "£","AED"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySymbol.text = currency[row]
    }
    
    //MARK:- viewWillLoad()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencySymbol.text = currency[0]
    }
    //MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        budgetText.delegate = self
        days.delegate = self
        rightNow = Date()
        print(rightNow)
        homeButton.titleLabel!.numberOfLines = 1
        homeButton.titleLabel!.adjustsFontSizeToFitWidth = true
        homeButton.titleLabel!.minimumScaleFactor = 0.5
        //Listen for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    deinit {
        //Stop listening for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    }
    //MARK: - Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        budgetText.resignFirstResponder()
        days.resignFirstResponder()
        return(true)
    }
    
    // MARK: - Allowed Characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    //MARK: - Transition
    
    
    
    //MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainTabBarController = segue.destination as? MainTabBar{
            mainTabBarController.currency = currencySymbol.text
            mainTabBarController.currentbalance = budgetText.text
            mainTabBarController.initialDate = rightNow
            mainTabBarController.initialDifference = days.text
        }
    }
    
    //MARK:- Making Sure UserDefaults Is Empty
    func resetDefaults() {
        print("Reset Defaults: Done")
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

}
