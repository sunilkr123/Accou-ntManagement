//
//  ExpensePartyVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 10/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
enum ExpensePartyType:String {
    case Individual = "Individual"
    case Enterprise = "Enterprise"
    case One_Time = "One Time"
    case Multy = "Multy"
    case Monthly = "Monthly"
}
class ExpensePartyVC: UIViewController {
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnSelectTypeDropDown: UIButton!
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var btnEnterprise: UIButton!
    @IBOutlet weak var btnOneTime: UIButton!
    @IBOutlet weak var btnMulty: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var txtfMobileNumber: UITextField!
    @IBOutlet weak var txtfEmailId: UITextField!
    @IBOutlet weak var txtfAddress: UITextField!
    @IBOutlet weak var txtfCity: UITextField!
    @IBOutlet weak var txtfBankName: UITextField!
    @IBOutlet weak var txtfAccountNumber: UITextField!
    @IBOutlet weak var txtfConfirmAccountNumber: UITextField!
    @IBOutlet weak var txtfIFSCCode: UITextField!
    @IBOutlet weak var stackContackPerson: UIStackView!
    @IBOutlet weak var txtfContactPerson: UITextField!
    @IBOutlet weak var stackType: UIStackView!
    @IBOutlet weak var stackBankName: UIStackView!
    @IBOutlet weak var stackAccountNumber: UIStackView!
    @IBOutlet weak var stackConfirmAccountNumber: UIStackView!
    @IBOutlet weak var stackIFSCCode: UIStackView!
    
    //MARK:- Class Variables of the Controller-
    let radioController1: RadioButtonController = RadioButtonController()
    let radioController2: RadioButtonController = RadioButtonController()
    var arrSelectPartyDropDown = Array<DropDownDataModel>()
    let dropDownSelectType = DropDown()
    var partyType = ExpensePartyType.Individual.rawValue
    var transactionType = ExpensePartyType.One_Time.rawValue
    var partyObj:Party_head?
    var isComingFromParty = false
    //MARK:- Class Variable here -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyShadowOnView(viewBg)
        setButtonStateForPartyType()
        setButtonStateForTransactionType()
        stackContackPerson.isHidden = true
        setUpDropDown()
        managedForExpenseAndThirdPArty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PopUpAddPartyVC") as! PopUpAddPartyVC
        
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.isComingFromParty = self.isComingFromParty
        popOverVC.complitionHandlerForRemovingParty = {
            success in
            if success{
                self.navigationController?.popViewController(animated: true)
            }
        }
        popOverVC.complitionHandlerPops = { partyObj in
            if let headObj = partyObj as? Party_head{
                self.partyObj = headObj
                self.displayDataToedit(partyObj: headObj)
            }
        }
        self.navigationController?.present(popOverVC, animated: true, completion: nil)
    }
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionIndividual(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.partyType = ExpensePartyType.Individual.rawValue
        stackContackPerson.isHidden = true
    }
    @IBAction func btnEnterPrise(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.partyType = ExpensePartyType.Enterprise.rawValue
        stackContackPerson.isHidden = false
    }
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionOneTime(_ sender: UIButton) {
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        self.transactionType = ExpensePartyType.One_Time.rawValue
    }
    @IBAction func btnEnterMulty(_ sender: UIButton) {
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        self.transactionType = ExpensePartyType.Multy.rawValue
    }
    @IBAction func selectType(_ sender: Any) {
        dropDownSelectType.show()
    }
    @IBAction func saveExpenseParty(_ sender: Any) {
        if isComingFromParty{//for expense party
            if validate(){
                if self.partyObj != nil{//to update
                    self.updateExpensePArty()
                }else{//to add
                    self.saveExpensePArty()
                }
                
            }
        }else{//for third party
            if valiafteThirdParty(){
                if self.partyObj != nil{
                    self.updateThirdParty()
                }else{
                    self.addThirdParty()
                }
            }
        }
    }
}

//MARK:- Custom function
extension ExpensePartyVC{
    
    func managedForExpenseAndThirdPArty() {
        if isComingFromParty{//for expense
            self.hideAndShow(flag: false)
            self.title = "Expense Party"
        }else{//for third party
            self.hideAndShow(flag: true)
            self.title = "Third Party"
        }
    }
    func hideAndShow(flag:Bool)  {
        self.stackType.isHidden = flag
        self.stackAccountNumber.isHidden = flag
        self.stackBankName.isHidden = flag
        self.stackConfirmAccountNumber.isHidden = flag
        self.stackIFSCCode.isHidden = flag
    }
    func displayDataToedit(partyObj:Party_head?)  {
        if let headPrtyObj = partyObj{
            txtfName.text = headPrtyObj.party_name ?? ""
            txtfMobileNumber.text = headPrtyObj.mobile_no ?? ""
            txtfEmailId.text = headPrtyObj.email ?? ""
            txtfAddress.text = headPrtyObj.address ?? ""
            lblType.text = headPrtyObj.type ?? ""
            txtfCity.text = headPrtyObj.city ?? ""
            txtfBankName.text = headPrtyObj.bank_name ?? ""
            txtfContactPerson.text = headPrtyObj.contact_person ?? ""
            txtfAccountNumber.text = headPrtyObj.bank_account_no ?? ""
            txtfConfirmAccountNumber.text = headPrtyObj.bank_account_no ?? ""
            txtfIFSCCode.text = headPrtyObj.iFSC_code ?? ""
            if ExpensePartyType.Individual.rawValue == headPrtyObj.party_type{
                self.partyType = ExpensePartyType.Individual.rawValue
                radioController1.defaultButton =  btnIndividual
                self.stackContackPerson.isHidden = true
            }else {
                self.partyType = ExpensePartyType.Enterprise.rawValue
                radioController1.defaultButton =  btnEnterprise
                self.stackContackPerson.isHidden = false
                
            }
            if ExpensePartyType.Multy.rawValue == headPrtyObj.transaction_type{
                radioController2.defaultButton =  btnMulty
                self.transactionType = ExpensePartyType.Multy.rawValue
            }else {
                
                radioController2.defaultButton =  btnOneTime
                self.transactionType = ExpensePartyType.One_Time.rawValue
            }
        }
    }
    
    func setRadioButtonWhileUpdate(value:ExpensePartyType)  {
        switch value {
        case .Enterprise:
            radioController1.defaultButton =  btnEnterprise
        case .Individual:
            radioController1.defaultButton =  btnIndividual
        case .Multy:
            radioController1.buttonArrayUpdated(buttonSelected: btnMulty)
        case .One_Time:
            radioController1.buttonArrayUpdated(buttonSelected: btnOneTime)
        default:
            print("nothing")
        }
    }
    func setButtonStateForPartyType(){
        radioController1.buttonsArray = [btnIndividual,btnEnterprise]
        radioController1.defaultButton = btnIndividual
    }
    func setButtonStateForTransactionType(){
        radioController2.buttonsArray = [btnOneTime,btnMulty]
        radioController2.defaultButton = btnOneTime
    }
}
//MARK:- For drop down
extension ExpensePartyVC{
    func setUpDropDown(){
        let  arr = ["Resident","Employee","Third Party"]
        arrSelectPartyDropDown.removeAll()
        for obj in arr{
            let dataModel = DropDownDataModel()
            var dict = [String:Any]()
            dict["name"] = obj
            dataModel.item = obj
            arrSelectPartyDropDown.append(dataModel) //appending Value in dropDown
        }
        self.setupDropDown(dropDown: dropDownSelectType)
        dropDownSelectType.dataSource = self.arrSelectPartyDropDown
    }
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = btnSelectTypeDropDown
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectTypeDropDown.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            self.lblType.text = item.item ?? ""
        }
    }
}
//MARK:- Api Calling
extension ExpensePartyVC{
    func validate() ->Bool {
        guard lblType.text! != "Select Type" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.TypeMEssage.rawValue)
            return false
        }
        guard !txtfName.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.emptyNameMEssage.rawValue)
            return false
        }
        if self.partyType == ExpensePartyType.Enterprise.rawValue{
            guard !txtfContactPerson.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.contactPersonMessage.rawValue)
                return false
            }
        }
        guard !txtfMobileNumber.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.mobileNumber.rawValue)
            return false
        }
        guard txtfMobileNumber.text!.count > 9 else {
            self.ShowAlert(title: Alert, message: MessagesEnum.mobileNumberValidate.rawValue)
            return false
        }
        
        guard txtfEmailId.text!.isEmpty == false ? txtfEmailId.text!.isValidEmail() : true else{
            self.ShowAlert(title: Alert, message: MessagesEnum.validEmailMessage.rawValue)
            return false
        }
        guard !txtfAddress.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.addressMessage.rawValue)
            return false
        }
        guard !txtfBankName.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.bankNameMessage.rawValue)
            return false
        }
        guard !txtfAccountNumber.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.accountNumberEmptyMessage.rawValue)
            return false
        }
        
        guard txtfAccountNumber.text!.count > 11 else {
            self.ShowAlert(title: Alert, message: MessagesEnum.validAccountNumber.rawValue)
            return false
        }
        
        guard !txtfAccountNumber.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.confirmAccountNumberMessage.rawValue)
            return false
        }
        guard txtfAccountNumber.text! == txtfConfirmAccountNumber.text! else {
            self.ShowAlert(title: Alert, message: MessagesEnum.accountDoesNotMatch.rawValue)
            return false
        }
        guard !txtfIFSCCode.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.ifscCodeMEssage.rawValue)
            return false
        }
        guard txtfIFSCCode.text!.count > 10 else {
            self.ShowAlert(title: Alert, message: MessagesEnum.validIfscCode.rawValue)
            return false
        }
        // for successfully validate
        return true
    }
    
    //for third party save
    func valiafteThirdParty() ->Bool {
        
        guard !txtfName.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.emptyNameMEssage.rawValue)
            return false
        }
        if self.partyType == ExpensePartyType.Enterprise.rawValue{
            guard !txtfContactPerson.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.contactPersonMessage.rawValue)
                return false
            }
        }
        guard !txtfMobileNumber.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.mobileNumber.rawValue)
            return false
        }
        guard txtfEmailId.text!.isEmpty == false ? txtfEmailId.text!.isValidEmail() : true else{
            self.ShowAlert(title: Alert, message: MessagesEnum.validEmailMessage.rawValue)
            return false
        }
        guard !txtfAddress.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.addressMessage.rawValue)
            return false
        }
        guard !txtfCity.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.cityEmptyMessage.rawValue)
            return false
        }
        return true
    }
    func saveExpensePArty(){
        AuthenticationInterface.shared.addExpenseParty(society_id: Constant.Soiaty_Id, party_name: txtfName.text!, address: txtfAddress.text!,mobile_no: txtfMobileNumber.text!, email: txtfEmailId.text!, type: self.lblType.text!, bank_account_no: txtfAccountNumber.text!, IFSC_code: txtfIFSCCode.text!, bank_name: txtfBankName.text!, contact_person:txtfContactPerson.text!, city: self.txtfCity.text!, transaction_type: self.transactionType, party_type: self.partyType) { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
    func updateExpensePArty(){
        AuthenticationInterface.shared.UpdateExpenseParty(society_id: Constant.Soiaty_Id, party_name: txtfName.text!, party_id: self.partyObj?.party_id ?? "",address: txtfAddress.text!,mobile_no: txtfMobileNumber.text!, email: txtfEmailId.text!, type: self.lblType.text!, bank_account_no: txtfAccountNumber.text!, IFSC_code: txtfIFSCCode.text!, bank_name: txtfBankName.text!, contact_person:txtfContactPerson.text!, city: self.txtfCity.text!, transaction_type: self.transactionType, party_type: self.partyType) { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
    //for the third party
    func addThirdParty()  {
        AuthenticationInterface.shared.addThirdParty(society_id: Constant.Soiaty_Id, party_name: txtfName.text!,address: txtfAddress.text!,mobile_no: txtfMobileNumber.text!, email: txtfEmailId.text!,contact_person:txtfContactPerson.text!, city: self.txtfCity.text!, transaction_type: self.transactionType, party_type: self.partyType) { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
    //update the third party
    func updateThirdParty()  {
        AuthenticationInterface.shared.updateThirdParty(society_id: Constant.Soiaty_Id, party_name: txtfName.text!,address: txtfAddress.text!, recv_party_id: self.partyObj?.recv_party_id ?? "",mobile_no: txtfMobileNumber.text!, email: txtfEmailId.text!,contact_person:txtfContactPerson.text!, city: self.txtfCity.text!, transaction_type: self.transactionType, party_type: self.partyType) { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
}
