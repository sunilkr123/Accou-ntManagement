//
//  MonthYearViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 23/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
import MonthYearPicker

class MonthYearViewController: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewDatePicker: MonthYearPickerView!
    
    var onComplition:((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewDatePicker.minimumDate = Date()
        viewDatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        viewDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        //view.addSubview(picker)
    }
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        print("date changed: \(picker.date)")
    }
    @IBAction func datePickerDone(_ sender: Any) {
        print("date changed: \(viewDatePicker.date)")
        self.dismiss(animated: true) {
            self.onComplition?(self.viewDatePicker.date)
        }
    }
    
    @IBAction func pickerViewCacel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
