//
//  DatePickerVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 27/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var onComplition:((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ picker: UIDatePicker) {
        print("date changed: \(picker.date)")
    }
    
    @IBAction func datePickerDone(_ sender: Any) {
        print("date changed: \(datePicker.date)")
        self.dismiss(animated: true) {
            self.onComplition?(self.datePicker.date)
        }
    }
    
    @IBAction func pickerViewCacel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
