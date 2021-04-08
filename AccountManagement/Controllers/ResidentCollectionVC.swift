//
//  ResidentCollectionVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 06/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

class ResidentCollectionVC: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewForBtns: UIView!
    @IBOutlet weak var btnOneTime: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnSelectBuilding: UIButton!
    @IBOutlet weak var btnSelectFlat: UIButton!
    @IBOutlet weak var lblSelectBuilding: UILabel!
    @IBOutlet weak var lblflatNo: UILabel!
    @IBOutlet weak var lblHeadName: UILabel!
    @IBOutlet weak var txtFieldAmount: UITextField!
    @IBOutlet weak var txtFieldConfirmedAmount: UITextField!
    @IBOutlet weak var btnImpose: UIButton!
    @IBOutlet weak var btnAlreadyPaired: UIButton!
    @IBOutlet weak var txtFieldAutoAppliedOn: UITextField!
    @IBOutlet weak var txtFieldAppliedForm: UITextField!
    @IBOutlet weak var txtFieldAppliedTill: UITextField!
    @IBOutlet weak var btnSelectHead: UIButton!
    @IBOutlet weak var objViewModel: ResidentCollectionViewModel!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnCheque: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var txtFieldCheckNo: UITextField!
    @IBOutlet weak var txtFieldPayingAmount: UITextField!
    @IBOutlet weak var btnResident: UIButton!
    
    //MARK:- Stack Views's IBOutlet's -
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var stackViewSelectFlat: UIStackView!
    @IBOutlet weak var stackViewImposeBtns: UIStackView!
    @IBOutlet weak var stackViewAutoAppliedOn: UIStackView!
    @IBOutlet weak var stackViewAppliedFrom: UIStackView!
    @IBOutlet weak var stackViewAppliedTill: UIStackView!
    @IBOutlet weak var stackViewPaymentMode: UIStackView!
    @IBOutlet weak var stackViewChequeNo: UIStackView!
    @IBOutlet weak var stackViewPayingAmount: UIStackView!
    @IBOutlet weak var stackViewUploadReiept: UIStackView!
    
    //MARK:- Class Variables of the Controller-
    let dropDownSelectBuilding = DropDown()
    let dropDownSelectflat = DropDown()
    let dropDownSelectHead = DropDown()
    let radioController1: RadioButtonController = RadioButtonController()
    let radioController2: RadioButtonController = RadioButtonController()
    let radioController3: RadioButtonController = RadioButtonController()
    var imagePicker: ImagePicker!
    var requestPara = ResidentCollection()
    var isAlreadyPaidSelected = false
    var isSelectedBuilding = false
    var isSelectedFlatNo = false
    var isSelectedHead = false
    var isChequeSelected = false
    var appliedFromDate:Date?
    var aplliedTilDate:Date?
    var isFirstTime:Bool = false
    var isFirstTime1:Bool = false
    var isForOneTimeOrMonthly = false
    
    //MARK:- view's life cycle of the Controller-
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfig()
        dropDownSeting()
        hideStuf()
    }

    //to select from date in formate mm-yyyy
    @IBAction func btnActionFromMonth(_ sender: UIButton) {
        if !self.txtFieldAutoAppliedOn.text!.isEmpty{
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = { date in
            self.appliedFromDate = date
            if let selectedFromDate = self.aplliedTilDate {
                if (date.compare(.isEarlier(than:self.aplliedTilDate!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                    self.txtFieldAppliedForm.text = "\(self.txtFieldAutoAppliedOn.text!)-\(date.toString(format: .custom(Constant.dateFormate2)))"
                    self.requestPara.appliedFromDate = date.toString(format: .custom(Constant.dateFormate2))
                }else{
                    self.txtFieldAppliedForm.text = ""
                    self.appliedFromDate = nil
                    self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                }
            } else {
                self.txtFieldAppliedForm.text = "\(self.txtFieldAutoAppliedOn.text!)-\(date.toString(format: .custom(Constant.dateFormate2)))"
                 self.requestPara.appliedFromDate = date.toString(format: .custom(Constant.dateFormate2))
            }
        }
        self.present(vc, animated: true, completion: nil)
        } else {
            self.ShowAlert(title: Alert, message: "Please select Auto applied on date")
        }
    }
    
    //to select til date in formate mm-yyyy
    @IBAction func btnActionTillMonth(_ sender: UIButton) {
         if !self.txtFieldAutoAppliedOn.text!.isEmpty{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.onComplition = { date in
                self.aplliedTilDate = date
                if let selectedFromDate = self.appliedFromDate {
                    if (date.compare(.isLater(than:self.appliedFromDate!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                        self.txtFieldAppliedTill.text = "\(self.txtFieldAutoAppliedOn.text!)-\(date.toString(format: .custom(Constant.dateFormate2)))"
                         self.requestPara.appliedTilDate = date.toString(format: .custom(Constant.dateFormate2))
                    }else{
                        self.txtFieldAppliedTill.text = ""
                        self.aplliedTilDate = nil
                        self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                    }
                } else {
                    self.txtFieldAppliedTill.text = "\(self.txtFieldAutoAppliedOn.text!)-\(date.toString(format: .custom(Constant.dateFormate2)))"
                     self.requestPara.appliedTilDate = date.toString(format: .custom(Constant.dateFormate2))
                }
            }
            self.present(vc, animated: true, completion: nil)
        }else {
            self.ShowAlert(title: Alert, message: "Please select Auto applied on date")
        }
    }
    
    @IBAction func btnAppliedDate(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = { date in
            self.txtFieldAutoAppliedOn.text = date.toString(format: .custom(Constant.dayFormate))
        }
        self.present(vc, animated: true, completion: nil)
    }
    
  
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionOneTime(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.hideAndShow(true)
        self.stackViewUploadReiept.isHidden = true
        self.isForOneTimeOrMonthly = false
        radioController2.defaultButton = btnImpose
        self.requestPara.mode = ExpensePartyType.One_Time.rawValue//"One Time"
    }
    
    @IBAction func btnActionMonthly(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.hideAndShow1(true)
        self.hideAndShow(false)
        self.isAlreadyPaidSelected = false
        self.stackViewUploadReiept.isHidden = true
        self.isForOneTimeOrMonthly = true
        self.requestPara.mode = ExpensePartyType.Monthly.rawValue
    }
    @IBAction func btnActionSelectBuildingAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.requestPara.collection_for = "R"
        }else {
            self.requestPara.collection_for  = "F"
        }
    }
    @IBAction func btnActionSelectFlatAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.btnSelectFlat.isUserInteractionEnabled = false
             self.lblflatNo.text = "All flats"
            self.isSelectedFlatNo = true
            objViewModel.json_for_society_details1(society_id: self.requestPara.society_id ?? "", building_id: self.requestPara.building_id ?? "") { (success, message) in
                if success {
                    self.runOnMainThread {
                        let arrflatNo = self.objViewModel.arrOfFlatNo.map { $0.resident_flat_no ?? "" }
                        self.requestPara.flat_no = arrflatNo.joined(separator: ",")
                        let arrOfresidentId = self.objViewModel.arrOfFlatNo.map { $0.resident_id ?? "" }
                        self.requestPara.resident_id = arrOfresidentId.joined(separator: ",")
                    }
                } else {
                    self.ShowAlert(title: Alert, message: message)
                }
            }
        }else {
            self.btnSelectFlat.isUserInteractionEnabled = true
             self.lblflatNo.text = "Select Flat"
            self.isSelectedFlatNo = false
        }
    }
    @IBAction func btnActionSelectBuildingDropDown(_ sender: UIButton) {
        self.lblflatNo.text = "Select Flat"
        self.setUpDropDown()
        self.dropDownSelectBuilding.show()
    }
    @IBAction func btnActionSelectFlatDropDown(_ sender: UIButton) {
        self.setUpDropDown1()
        self.dropDownSelectflat.show()
    }
    @IBAction func btnActionSelectHeadDropDown(_ sender: UIButton) {
        self.setUpDropDown2()
        self.dropDownSelectHead.show()
    }
    @IBAction func btnActionImpose(_ sender: UIButton) {
        self.hideAndShow1(true)
        self.isAlreadyPaidSelected = false
        self.stackViewUploadReiept.isHidden = true
        self.stackViewChequeNo.isHidden = true
        self.requestPara.already_paid = "N"
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        radioController3.defaultButton = btnCash
    }
    @IBAction func btnActionAlreadyPaid(_ sender: UIButton) {
        self.hideAndShow1(false)
        self.isAlreadyPaidSelected = true
        self.stackViewChequeNo.isHidden = true
        self.stackViewUploadReiept.isHidden = true
         self.requestPara.already_paid = "Y"
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        radioController3.defaultButton = btnCash
    }
    @IBAction func btnActionAutoAppliedOn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.requestPara.isAutoAppliedOn = "Y"
        } else {
            self.requestPara.isAutoAppliedOn = "N"
        }
    }
  
    @IBAction func btnActionCash(_ sender: UIButton) {
        radioController3.buttonArrayUpdated(buttonSelected: sender)
        self.stackViewChequeNo.isHidden = true
        self.stackViewUploadReiept.isHidden = true
        self.requestPara.mode_of_payment = Mode_of_payment.cash.rawValue
        self.isChequeSelected = false
    }
    @IBAction func btnActionCheque(_ sender: UIButton) {
        radioController3.buttonArrayUpdated(buttonSelected: sender)
        self.stackViewChequeNo.isHidden = false
        self.stackViewUploadReiept.isHidden = true
        self.requestPara.mode_of_payment = Mode_of_payment.cheque.rawValue
        self.isChequeSelected = true
    }
    @IBAction func btnActionOnline(_ sender: UIButton) {
        radioController3.buttonArrayUpdated(buttonSelected: sender)
        self.stackViewChequeNo.isHidden = true
        self.stackViewPayingAmount.isHidden = false
        self.stackViewUploadReiept.isHidden = false
        self.requestPara.mode_of_payment = Mode_of_payment.online.rawValue
        self.isChequeSelected = false
    }
    @IBAction func btnActionUploadReceipt(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func btnActionSave(_ sender: UIButton) {
        if !isSelectedBuilding {
            self.ShowAlert(title: Alert, message: MessagesEnum.SelectBuilding.rawValue)
        } else if !isSelectedFlatNo {
            self.ShowAlert(title: Alert, message: MessagesEnum.SelectFlatNumber.rawValue)
        } else if !isSelectedHead {
            self.ShowAlert(title: Alert, message: MessagesEnum.SelectHead.rawValue)
        } else if txtFieldAmount.text!.isEmpty {
            self.ShowAlert(title: Alert, message: MessagesEnum.EnterAmount.rawValue)
        } else if txtFieldConfirmedAmount.text!.isEmpty {
            self.ShowAlert(title: Alert, message: MessagesEnum.CNFAmount.rawValue)
        } else if !self.isAmountSame(amount: txtFieldAmount.text!, confirmAmount:txtFieldConfirmedAmount.text!){
            self.ShowAlert(title: Alert, message: MessagesEnum.SameAmount.rawValue)
        } else if isAlreadyPaidSelected {
            if self.isChequeSelected {//for cheque
                if txtFieldCheckNo.text!.isEmpty {
                    self.ShowAlert(title: Alert, message: MessagesEnum.ChequeNo.rawValue)
                } else if txtFieldPayingAmount.text!.isEmpty {
                    self.ShowAlert(title: Alert, message: MessagesEnum.PayingAmount.rawValue)
                } else {
                    self.openPopupVCForOneTime()
                }
            } else if txtFieldPayingAmount.text!.isEmpty {
                self.ShowAlert(title: Alert, message: MessagesEnum.PayingAmount.rawValue)
            } else {
                self.openPopupVCForOneTime()
            }
        } else {
            self.openPopupVCForMonthLy()
        }
    }
}
//MARK:- ImagePicker Controller Delegates-
extension ResidentCollectionVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            self.requestPara.image = image
        }
    }
}
//MARK:- Custom functions of the Controller-
extension ResidentCollectionVC {
    
    func initialConfig() {
        self.requestPara.society_id = Constant.Soiaty_Id
        self.requestPara.mode_of_payment = Mode_of_payment.cash.rawValue
        self.requestPara.collection_for = "F"
        self.requestPara.mode = ExpensePartyType.One_Time.rawValue
        self.requestPara.isAutoAppliedOn = "N"
        self.requestPara.already_paid = "N"
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.applyShadowOnView(viewForBtns)
        self.applyShadowOnView(viewParent)
        self.setButtonState()
        self.setImposeBtnsState()
        self.setAlreadyBtns()
    }
    func dropDownSeting()  {
        self.setUpDropDown2()
        self.setUpDropDown()
        self.setUpDropDown1()
    }
    func hideStuf()  {
        self.hideAndShow(true)
        self.hideAndShow1(true)
        self.stackViewPayingAmount.isHidden = true
        self.stackViewChequeNo.isHidden = true
        self.stackViewUploadReiept.isHidden = true
        self.stackViewSelectFlat.isHidden = true
    }
    
    func openPopupVCForOneTime(){
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TransferFundVC") as! TransferFundVC
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.isFrom = true
        if  self.isForOneTimeOrMonthly{
            popOverVC.isImposeOrPaid = nil
        } else {
            if  isAlreadyPaidSelected{
                popOverVC.isImposeOrPaid = false
            } else {
                popOverVC.isImposeOrPaid = true
            }
        }
        popOverVC.complitionHandlerPops = { (pust,msg) in
            self.toSaveResidentCollection()
        }
        self.navigationController?.present(popOverVC, animated: true, completion: nil)
    }
   
    func openPopupVCForMonthLy(){
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TransferFundVC") as! TransferFundVC
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.isFrom = true
        popOverVC.isForMonthly = self.isForOneTimeOrMonthly
        if  self.isForOneTimeOrMonthly{
            popOverVC.isImposeOrPaid = nil
        } else {
            if  isAlreadyPaidSelected{
                popOverVC.isImposeOrPaid = false
            } else {
                popOverVC.isImposeOrPaid = true
            }
        }
        popOverVC.complitionHandlerPops = { (pust , msg) in
            self.resident_pending_transaction_details_all_Monthly()
        }
        self.navigationController?.present(popOverVC, animated: true, completion: nil)
    }
   
  
    func setButtonState(){
        radioController1.buttonsArray = [btnOneTime,btnMonthly]
        radioController1.defaultButton = btnOneTime
    }
    func setImposeBtnsState(){
        radioController2.buttonsArray = [btnImpose,btnAlreadyPaired]
        radioController2.defaultButton = btnImpose
    }
    func setAlreadyBtns(){
        radioController3.buttonsArray = [btnCash,btnCheque,btnOnline]
        radioController3.defaultButton = btnCash
    }
    func hideAndShow(_ isShow:Bool) {
        stackViewImposeBtns.isHidden = !isShow
        stackViewAutoAppliedOn.isHidden = isShow
        stackViewAppliedFrom.isHidden = isShow
        stackViewAppliedTill.isHidden = isShow
    }
    func hideAndShow1(_ isShow:Bool) {
        stackViewPaymentMode.isHidden = isShow
        stackViewPayingAmount.isHidden = isShow
    }
}
//MARK:- On Save Collection Calling API -
extension ResidentCollectionVC{
    
    func toSaveResidentCollection()  {
        AuthenticationInterface.shared.onetimeResidentCollectionSave(society_id: self.requestPara.society_id ?? "", building_id: self.requestPara.building_id ?? "", flat_no: self.requestPara.flat_no ?? "", resident_id: self.requestPara.resident_id ?? "", amount: txtFieldAmount.text!, head_id:self.requestPara.head_id ?? "", applied_date: Date.getCurrentDate(), collection_for: requestPara.collection_for ?? "", mode: self.requestPara.mode ?? "", already_paid:   self.requestPara.already_paid ?? "", paid_amount: txtFieldPayingAmount.text!, mode_of_payment: self.requestPara.mode_of_payment ?? "", cheque_no: txtFieldCheckNo.text ?? "abc", image: self.requestPara.image ?? UIImage(), imageName: "transaction_receipt") { (response, success, message) in
            if success {
                self.navigationController?.popViewController(animated: true)
                self.ShowAlert(title: Alert, message: message ?? "" )
            } else {
                self.ShowAlert(title: Alert, message: message ?? "Something went wrong.")
            }
        }
    }
    
    func resident_pending_transaction_details_all_Monthly(){
        AuthenticationInterface.shared.resident_pending_transaction_details_all_Monthly(society_id: self.requestPara.society_id ?? "", building_id: self.requestPara.building_id ?? "", flat_no: self.requestPara.flat_no ?? "", resident_id: self.requestPara.resident_id ?? "", amount: txtFieldAmount.text!, head_id: self.requestPara.head_id ?? "", applied_date:self.txtFieldAutoAppliedOn.text!, collection_for: self.requestPara.collection_for ?? "", mode: self.requestPara.mode ?? "", from_month: self.requestPara.appliedFromDate ?? "", till_month:self.requestPara.appliedTilDate ?? "", auto_applied: self.requestPara.isAutoAppliedOn ?? "") { (response, success, message) in
            if success {
                self.navigationController?.popViewController(animated: true)
                self.ShowAlert(title: Alert, message: message ?? "" )
            } else {
                self.ShowAlert(title: Alert, message: message ?? "Something went wrong.")
            }
        }
    }
}




//MARK:- Set for the DropDown
extension ResidentCollectionVC{
    func setUpDropDown()  {
        var arr1 = Array<DropDownDataModel>()
        objViewModel.json_for_society_details(society_id: self.requestPara.society_id ?? "", building_id: "") { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfBuildings.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.building_name ?? ""
                        arr1.append(dataModel) //appending Value in dropDown
                    }
                    self.setupDropDown(dropDown: self.dropDownSelectBuilding)
                    self.dropDownSelectBuilding.dataSource = arr1
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = btnSelectBuilding
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectBuilding.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Buildings
            self.requestPara.building_id = dict.building_id ?? ""
            self.lblSelectBuilding.text = item.item ?? "" //Value assigned Place.
            self.lblSelectBuilding.textColor = .black
            self.stackViewSelectFlat.isHidden = false
            self.lblflatNo.text = "Select Flat"
            self.setUpDropDown1()
            self.isSelectedBuilding = true
        }
    }
    func setUpDropDown1()  {
        var arr2 = Array<DropDownDataModel>()
        objViewModel.json_for_society_details1(society_id: self.requestPara.society_id ?? "", building_id: self.requestPara.building_id ?? "") { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfFlatNo.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.resident_flat_no ?? ""
                        arr2.append(dataModel)
                    }
                    self.dropDownSelectflat.dataSource = arr2
                    self.setupDropDown1(dropDown: self.dropDownSelectflat)
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setupDropDown1( dropDown:DropDown){
        dropDown.anchorView = btnSelectFlat
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectFlat.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Resident_data
            self.requestPara.resident_id = dict.resident_id ?? ""
            self.lblflatNo.text = item.item ?? ""
            self.requestPara.flat_no = item.item ?? ""//Value assigned Place.
            self.lblflatNo.textColor = .black
            self.isSelectedFlatNo = true
        }
    }
    func setUpDropDown2()  {
         var arr3 = Array<DropDownDataModel>()
        self.objViewModel.Fetch_all_head(society_id: self.requestPara.society_id ?? "") { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfRevenue_head.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.head_name ?? ""
                       arr3.append(dataModel) //appending Value in dropDown
                    }
                    self.setupDropDown2(dropDown: self.dropDownSelectHead)
                    self.dropDownSelectHead.dataSource = arr3
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setupDropDown2( dropDown:DropDown){
        dropDown.anchorView = btnSelectHead
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectHead.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Revenue_head
            self.requestPara.head_id = dict.head_id ?? ""
            self.lblHeadName.text = item.item ?? "" //Value assigned Place.
            self.lblHeadName.textColor = .black
            self.isSelectedHead = true
        }
    }
}
//
//else if textField == txtFieldAppliedForm{
//    vc.onComplition = { date in
//        if !self.txtFieldAutoAppliedOn.text!.isEmpty{
//            self.appliedFromDate = date
//            self.txtFieldAppliedForm.text = SharedData.getStringFromDate(date: date, dateFormatterString: Constant.dateFormate2)
//        }else{
//            self.ShowAlert(title: "", message: "Select autoapplied date")
//        }
//    }
//    self.present(vc, animated: true, completion: nil)
//}else if textField == txtFieldAppliedTill{
//    vc.onComplition = { date in
//        if !self.txtFieldAppliedForm.text!.isEmpty{
//            if let fromdateSelected = self.appliedFromDate{
//                if  (date.compare(.isLater(than:fromdateSelected))) && !date.compare(.isSameDay(as: fromdateSelected)){
//                    self.txtFieldAppliedTill.text = SharedData.getStringFromDate(date: date, dateFormatterString: Constant.dateFormate2)
//                }
//                else{
//                self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
//                }
//            }
//        }else{
//            self.ShowAlert(title: "", message: "Select from date")
//        }
//    }
//    self.present(vc, animated: true, completion: nil)
//}
