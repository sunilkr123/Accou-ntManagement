//
//  HeadCreationViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 05/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import DatePickerDialog

class HeadCreationViewController: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewForButtons: UIView!
    @IBOutlet weak var btnExpesesHead: UIButton!
    @IBOutlet weak var btnrevenueHead: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var ViewHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //@IBOutlet weak var txtfieldNameOfHead: UITextField!
    @IBOutlet weak var txtfieldNameOfHead: IQTextView!
    @IBOutlet weak var txtfieldNameOfHeadHeightContsraint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldSinglePayment: UITextField!
    @IBOutlet weak var txtFieldHeadFundLimit: UITextField!
    @IBOutlet weak var txtFieldDate: UITextField!
    //MARK:- IBOutlet's of the SatckView-
    @IBOutlet weak var stackFundLimit: UIStackView!
    @IBOutlet weak var stackAutoApplied: UIStackView!
    @IBOutlet weak var stackApplicableOn: UIStackView!
    @IBOutlet weak var stackSingleTransactionLimit: UIStackView!
    @IBOutlet weak var stackAppliedDate: UIStackView!
    @IBOutlet weak var btnTypeTitle: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var btnAvailableOn: UIButton!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    
    //MARK:- Class Variables of the Controller-
    let radioController: RadioButtonController = RadioButtonController()
    let autoAppliedRadioController: RadioButtonController = RadioButtonController()
    var arrDropDownType = Array<DropDownDataModel>()
    let dropDownType = DropDown()
    var typeValues:[String] = ["Monthly","Yearly","Any Time"]
    var appliedOnValues:[String] = ["Resident","OutSider","Employee","Third Party"]
    var isForType = false
    var headType = 1 //1 - expense, 2- revenue
    var autoApplied = ""//N - No, Yes - Y
    
    //MARK:- Life cycle of the view-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyShadowOnView(viewForButtons)
        self.applyShadowOnView(ViewHead)
        self.setButtonState()
        setUpDropDown()
        
        txtFieldDate.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        self.istTextViewAttributes()
    }
    
    func istTextViewAttributes(){
        self.txtfieldNameOfHead.delegate = self
        self.txtfieldNameOfHeadHeightContsraint.constant = 35
    }
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionExpensesHead(_ sender: UIButton) {
        lblTitle.text = "Expenses Head"
        headType = 1
        self.autoApplied = ""
        radioController.buttonArrayUpdated(buttonSelected: sender)
        self.hideAndShow(flag: true)
    }
    
    @IBAction func btnActionRevenueHead(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        lblTitle.text = "Revenue Head"
        headType = 2
        self.autoApplied = "N"
        self.hideAndShow(flag: false)
        setAutoApplied()
    }
    
    @IBAction func btnActionYes(_ sender: UIButton) {
        autoAppliedRadioController.buttonArrayUpdated(buttonSelected: sender)
        stackAppliedDate.isHidden = false
        self.autoApplied = "Y"
    }
    @IBAction func btnActionNo(_ sender: UIButton) {
        autoAppliedRadioController.buttonArrayUpdated(buttonSelected: sender)
        stackAppliedDate.isHidden = true
        self.autoApplied = "N"
    }
    @IBAction func openTypeDropDowm(_ sender: Any) {
        self.isForType = true
        setUpDropDown()
        self.dropDownType.show()
    }
    @IBAction func applicableOn(_ sender: UIButton) {
        self.isForType = false
        setUpDropDown()
        self.dropDownType.show()
    }
    @IBAction func saveHead(_ sender: Any) {
        if self.headType == 1{
            if validate(){
                self.add_expencess_head()
            }
        }else{
            if validateRevenueHead(){
                add_revenue_add()
            }
        }
    }
}
//MARK:- UITextViewDelegate Methods
extension HeadCreationViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let minHeight: CGFloat = 35
        let maxHeight: CGFloat = 60
        textView.textAlignment = .center
        if textView == self.txtfieldNameOfHead {
            if txtfieldNameOfHead.text.isEmpty != true {
                let sizeToFitIn = CGSize(width: self.txtfieldNameOfHead.bounds.size.width, height: CGFloat(MAXFLOAT))
                let newSize = self.txtfieldNameOfHead.sizeThatFits(sizeToFitIn)
                let height = newSize.height > maxHeight ? maxHeight : newSize.height
                self.txtfieldNameOfHeadHeightContsraint.constant = height < minHeight ? minHeight : height
            } else {
                self.txtfieldNameOfHeadHeightContsraint.constant = minHeight
            }
        }
    }
}

//MARK:- Custom functions of the Controller-
extension HeadCreationViewController {
    //to set the date from the datePicker
    @objc func doneButtonPressed() {
        if let  datePicker = self.txtFieldDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constant.dateFormate3
            self.txtFieldDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtFieldDate.resignFirstResponder()
    }
    
    //if Expense head selected
    func validate()->Bool{
        guard !txtfieldNameOfHead.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.ExpenseHeadmessge.rawValue)
            return false
        }
        guard lblMonthly.text != "Select Type" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.ExpenseType.rawValue)
            return false
        }
        guard !txtFieldSinglePayment.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.transactionLimit.rawValue)
            return false
        }
        guard !txtFieldHeadFundLimit.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.fundLimitMessage.rawValue)
            return false
        }
        return true
    }
    
    func validateRevenueHead()->Bool  {
        guard !txtfieldNameOfHead.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.ExpenseHeadmessge.rawValue)
            return false
        }
        guard lblMonthly.text != "Select Type" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.ExpenseType.rawValue)
            return false
        }
        guard !txtFieldSinglePayment.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.transactionLimit.rawValue)
            return false
        }
        guard self.lblAvailable.text! != "Applicable on" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.applicableOnMessage.rawValue)
            return false
        }
        if self.autoApplied == "Y"{
            guard !self.txtFieldDate.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.autoAplliedDateMessage.rawValue)
                return false
            }
        }
        return true
    }
    //to add expense head
    func add_expencess_head(){
        AuthenticationInterface.shared.add_expencess_head(society_id: Constant.Soiaty_Id, type_head: lblMonthly.text ?? "", single_payment_limit: txtFieldSinglePayment.text ?? "", head_fund_limit: txtFieldHeadFundLimit.text ?? "", head_name: txtfieldNameOfHead.text ?? "") { (response, success, message) in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else if let message = message {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    //to add revenue head
    func add_revenue_add()  {
        AuthenticationInterface.shared.add_revenue_head(society_id: Constant.Soiaty_Id, type_head: self.lblMonthly.text!, single_payment_limit: txtFieldSinglePayment.text!, head_fund_limit: self.txtFieldHeadFundLimit.text!, head_name: self.txtfieldNameOfHead.text!, applied_on: lblAvailable.text!, applied_from: self.txtFieldDate.text!, monthly_auto_applied: (self.autoApplied)) { (response, success, msg) in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else if let message = msg {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setButtonState(){
        radioController.buttonsArray = [btnExpesesHead,btnrevenueHead]
        radioController.defaultButton = btnExpesesHead
        setAutoApplied()
    }
    func setAutoApplied()  {
        autoAppliedRadioController.buttonsArray = [btnYes,btnNo]
        autoAppliedRadioController.defaultButton = btnNo
    }
    func hideAndShow(flag:Bool)  {
        stackAutoApplied.isHidden = flag
        stackApplicableOn.isHidden = flag
        stackAppliedDate.isHidden =  true
        stackFundLimit.isHidden = !flag
    }
}

//MARK:- Set for the DropDown
extension HeadCreationViewController{
    func setUpDropDown()  {
        var arrs:[String] = []
        if self.isForType{
            arrs = self.typeValues
        }else{
            arrs = self.appliedOnValues
        }
        arrDropDownType.removeAll()
        for obj in arrs{
            let dataModel = DropDownDataModel()
            var dict = [String:Any]()
            dict["name"] = obj
            dict["id"] = 1
            dataModel.dataObject = dict as AnyObject
            dataModel.item = obj
            arrDropDownType.append(dataModel) //appending Value in dropDown
        }
        self.setupDropDown(dropDown: dropDownType)
        dropDownType.dataSource = arrDropDownType
    }
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = viewType
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnTypeTitle.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Dictionary<String, AnyObject>
            let value = dict["name"] as! String
            // let id = dict["id"] as! String
            print("name is \(value)")
            if self.isForType{
                self.lblMonthly.text = item.item ?? ""
                self.lblMonthly.textColor = .black
            }else{
                self.lblAvailable.text = item.item ?? ""
                self.lblAvailable.textColor = .black
                //self.btnAvailableOn.titleLabel?.text = item.item ?? ""
            }
            
            //Value assigned Place.
        }
    }
}
//Button Class
class RadioButtonController: NSObject {
    var buttonsArray: [UIButton]! {
        didSet {
            for b in buttonsArray {
                b.setImage(#imageLiteral(resourceName: "inactive"), for: .normal)
                b.setImage(#imageLiteral(resourceName: "active"), for: .selected)
            }
        }
    }
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }
    func buttonArrayUpdated(buttonSelected: UIButton) {
        for b in buttonsArray {
            if b == buttonSelected {
                selectedButton = b
                b.isSelected = true
            } else {
                b.isSelected = false
            }
        }
    }
}

