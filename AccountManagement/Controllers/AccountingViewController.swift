//
//  AccountingViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 06/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

struct PendingListModel {
    var society_id:String?
    var building_id:String?
    var mode:String = PaymentMode.Pending.rawValue
    var flat_no:String?
    var type:String = Type.All.rawValue
    var from_month_and_year:String?
    var to_month_and_year:String?
    var transactionType:String = Mode_of_payment.cash.rawValue
    var pending_dues :[String] = []
    init() {
    }
}

enum PaymentMode:String{
    case Pending = "pending"
    case Paid   = "paid"
    case Payment = "payment"
}

enum Type:String {
    case All = "B"
    case Flat = "F"
    case Resident = "R"
}

enum Mode_of_payment:String {
    case cash = "cash"
    case cheque = "cheque"
    case online = "online"
}

class AccountingViewController: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var btnSelectBuilding: UIButton!
    @IBOutlet weak var btnSelectFlat: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnFlat: UIButton!
    @IBOutlet weak var btnResident: UIButton!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnPayments: UIButton!
    @IBOutlet weak var txtFieldFromMonthYear: UITextField!
    @IBOutlet weak var txtFieldTilMonthYear: UITextField!
    @IBOutlet weak var stackFlateNo: UIStackView!
    @IBOutlet weak var objViewModel: AmountPendingListViewModel!
    @IBOutlet weak var viewShowData: UIView!
    @IBOutlet weak var tlvHeadData: UITableView!
    @IBOutlet weak var viewPayable: UIView!
    @IBOutlet weak var txtTotalAmount: UITextField!
    @IBOutlet weak var stackChequeNo: UIStackView!
    @IBOutlet weak var viewUploadImage: UIView!
    @IBOutlet weak var txtChequeNumber: UITextField!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnCheque: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var lblHeadTitle: UILabel!
    
    //for the due payment
    @IBOutlet weak var viewPendingDataList: UIView!
    @IBOutlet weak var viewTransationType: UIView!
    @IBOutlet weak var viewNetPayable: UIView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Class Variables of the Controller-
    let radioController1: RadioButtonController = RadioButtonController()
    let radioController2: RadioButtonController = RadioButtonController()
    let radioController3: RadioButtonController = RadioButtonController()
    
    let dropDownSelectBuilding = DropDown()
    let dropDownFlatNo = DropDown()
    var requestPara = PendingListModel()
    var image:UIImage?
    var imagePicker: ImagePicker!
    var resident_id = "AKSH_0ef3"
    var selectedFromMonthYear:Date?
    var selectedFromTillYear:Date?
    var isFirstime:Bool = false
    var isPayments = false
    
    //MARK:- view's life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        stackFlateNo.isHidden = true
        self.setAllState()
        self.setPendingState()
        self.setUpDropDown()
        self.applyShadowOnView(viewShowData)
        self.setFlatNoDropDown()
        stackChequeNo.isHidden = true
        viewUploadImage.isHidden = true
        forPaymentMode()
        hideForDuesPayingController(flag: true)
    }
    
    //MARK:- IBOutlet's of the Controller-
    @IBAction func btnActionSelectBuildingDropDown(_ sender: UIButton) {
        self.setUpDropDown()
        self.dropDownSelectBuilding.show()
    }
    
    @IBAction func btnActionSelectFlatDropDown(_ sender: UIButton) {
        self.setFlatNoDropDown()
        self.dropDownFlatNo.show()
    }
    
    @IBAction func btnActionAll(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.type = Type.All.rawValue
    }
    @IBAction func btnActionFlat(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.type = Type.Flat.rawValue
    }
    @IBAction func btnActionResident(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.type = Type.Resident.rawValue
    }
    @IBAction func btnActionPending(_ sender: UIButton) {
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.mode = PaymentMode.Pending.rawValue
        self.isPayments = false
       // hideAndShowPayingStuf(flag:false)
    }
    @IBAction func btnActionPaid(_ sender: UIButton) {
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.mode = PaymentMode.Paid.rawValue
        self.isPayments = true
        hideAndShowPayingStuf(flag: true)
    }
    @IBAction func btnActionPayments(_ sender: UIButton) {
        radioController2.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.mode = PaymentMode.Payment.rawValue
        self.isPayments = true
        hideAndShowPayingStuf(flag:true)
    }
    
    @IBAction func btnActionFromMonth(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = { date in
            self.selectedFromMonthYear = date
            if let selectedFromDate = self.selectedFromTillYear{
                if (date.compare(.isEarlier(than:self.selectedFromTillYear!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                    self.txtFieldFromMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                    self.requestPara.to_month_and_year = date.toString(format: .custom(Constant.dateFormate2))
                }else{
                    self.txtFieldFromMonthYear.text = ""
                    self.selectedFromMonthYear = nil
                    self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                }
            } else {
                self.txtFieldFromMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                self.requestPara.to_month_and_year = date.toString(format: .custom(Constant.dateFormate2))
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnActionTillMonth(_ sender: UIButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = { date in
            self.selectedFromTillYear = date
            if let selectedFromDate = self.selectedFromMonthYear{
                if (date.compare(.isLater(than:self.selectedFromMonthYear!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                    self.txtFieldTilMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                    self.requestPara.to_month_and_year = date.toString(format: .custom(Constant.dateFormate2))
                }else{
                    self.txtFieldTilMonthYear.text = ""
                    self.selectedFromTillYear = nil
                    self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                }
            } else {
                self.txtFieldTilMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                self.requestPara.to_month_and_year = date.toString(format: .custom(Constant.dateFormate2))
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnCash(_ sender: UIButton) {
        stackChequeNo.isHidden = true
        viewUploadImage.isHidden = true
        requestPara.transactionType = Mode_of_payment.cash.rawValue
        radioController3.buttonArrayUpdated(buttonSelected: sender)
    }
    @IBAction func btnCheque(_ sender: UIButton) {
        stackChequeNo.isHidden = false
        viewUploadImage.isHidden = true
        requestPara.transactionType = Mode_of_payment.cheque.rawValue
        radioController3.buttonArrayUpdated(buttonSelected: sender)
    }
    @IBAction func btnOnline(_ sender: UIButton) {
        stackChequeNo.isHidden = true
        viewUploadImage.isHidden = false
        requestPara.transactionType = Mode_of_payment.online.rawValue
        radioController3.buttonArrayUpdated(buttonSelected: sender)
    }
    @IBAction func btnActionUploadReceipt(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    @IBAction func btnActionShow(_ sender: UIButton) {
        if self.isPayments{
            self.lblHeadTitle.text = "Paymenr Mode"
        }else{
            self.lblHeadTitle.text = "Head Name"
        }
        if validateShowData(){
            self.fetch_all_pendingList()
        }
    }
    @IBAction func btnPay(_ sender: Any) {
        if validate(){
            self.payDues()
        }
    }
}
//MARK:- ImagePicker Controller Delegates-
extension AccountingViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            self.image = image
        }
    }
}
//MARK:- Custom functions of the Controller-
extension AccountingViewController {
    
    func hideAndShowPayingStuf(flag:Bool)  {
        viewTransationType.isHidden = flag
        viewNetPayable.isHidden = flag
        btnPay.isHidden = flag
    }
    func hideForDuesPayingController(flag:Bool)  {
        self.viewPendingDataList.isHidden = flag
        hideAndShowPayingStuf(flag: flag)
    }
    func setAllState(){
        radioController1.buttonsArray = [btnAll,btnFlat,btnResident]
        radioController1.defaultButton = btnAll
    }
    func setPendingState(){
        radioController2.buttonsArray = [btnPending,btnPaid,btnPayments]
        radioController2.defaultButton = btnPending
    }
    func forPaymentMode()  {
        radioController3.buttonsArray = [btnCash,btnCheque,btnOnline]
        radioController3.defaultButton = btnCash
    }
}
//MARK:- Set for the DropDown
extension AccountingViewController{
    func didTapOnFromMonth() {
        //        self.objViewModel.openDatePickerFrom(strTimeAndDate: "date") { (date) in
        //            self.txtFieldFromMonthYear.text = date
        //            self.requestPara.from_month_and_year = date
        //        }
    }
    func didTapOnTillMonth() {
        //        self.objViewModel.openDatePickertill(fromDate: Date()) { (date) in
        //            self.txtFieldTilMonthYear.text = date
        //            self.requestPara.to_month_and_year = date
        //        }
    }
    func setUpDropDown()  {
        var arrSelectBuildingDropDown = Array<DropDownDataModel>()
        self.objViewModel.json_for_society_details(society_id: Constant.Soiaty_Id, building_id: "") { (success, message) in
            if success {
                self.objViewModel.arrOfBuildings.forEach { (obj) in
                    let dataModel = DropDownDataModel()
                    dataModel.dataObject = obj as AnyObject
                    dataModel.item = obj.building_name ?? ""
                    arrSelectBuildingDropDown.append(dataModel) //appending Value in dropDown
                }
                self.dropDownSelectBuilding.dataSource = arrSelectBuildingDropDown
                self.setupDropDown(dropDown: self.dropDownSelectBuilding)
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
            let data = item.dataObject as! Buildings
            self.requestPara.building_id = data.building_id ?? ""
            self.btnSelectBuilding.setTitle(item.item ?? "", for: .normal)
            self.stackFlateNo.isHidden = false
            self.btnSelectFlat.setTitle("Select Flat", for: .normal)
            self.setFlatNoDropDown()
        }
    }
    func setFlatNoDropDown(){
        var arrOfSelectFlatNoDropDown = Array<DropDownDataModel>()
        self.objViewModel.json_for_society_details1(society_id: Constant.Soiaty_Id, building_id: self.requestPara.building_id ?? "") { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfFlatNo.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.resident_flat_no ?? ""
                        arrOfSelectFlatNoDropDown.append(dataModel) //appending Value in dropDown
                    }
                    self.dropDownFlatNo.dataSource = arrOfSelectFlatNoDropDown
                    self.dropDownFlatNo(dropDown: self.dropDownFlatNo)
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func dropDownFlatNo( dropDown:DropDown){
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
            self.requestPara.flat_no = (item.dataObject as? Resident_data)?.resident_flat_no ?? ""
            self.btnSelectFlat.setTitle(item.item ?? "", for: .normal) //Value assigned Place
        }
    }
}

//MARK:- UITableViewDelegate,UITableViewDataSource -
extension AccountingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objViewModel.arrOfAmount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tlvHeadData.dequeueReusableCell(withIdentifier: "AmountPendingListCell", for: indexPath) as! AmountPendingListCell
        cell.isPayment = self.isPayments
        cell.objAccount = self.objViewModel.arrOfAmount[indexPath.row]
        if self.isPayments{
          cell.btnCheck.isHidden = true
        }else{
            cell.btnCheck.isHidden = false
        }
        if self.objViewModel.arrOfAmount[indexPath.row].isSelected{
            cell.btnCheck.setImage(UIImage(named: "checked_box"), for: .normal)
        }else{
            cell.btnCheck.setImage(UIImage(named: "check_box"), for: .normal)
        }
        cell.tapToSelect {
            self.checkBox(indexPath: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func checkBox(indexPath:IndexPath)  {
        self.objViewModel.arrOfAmount[indexPath.row].isSelected.toggle()
        DispatchQueue.main.async {
            self.tlvHeadData.reloadData()
        }
        var totalAMount = 0.0
        for obj in self.objViewModel.arrOfAmount{
            if obj.isSelected{
                if let amount = Double(obj.amount ?? "0"){
                    totalAMount += amount
                    let selectDues = "\(obj.head_id ?? "")=\(obj.applied_date ?? "")@\(obj.amount ?? "")#\(obj.balance_amount ?? "")~\(obj.type ?? "")"
                    self.requestPara.pending_dues.append(selectDues)
                }
            }
        }
        txtTotalAmount.text = "\(totalAMount)"
    }
}

//MARK:- API Calling
extension AccountingViewController{
    func fetch_all_pendingList()  {
        self.objViewModel.fetch_all_account_pendingList(society_id: Constant.Soiaty_Id, building_id: self.requestPara.building_id ?? "", mode: self.requestPara.mode , from_month_and_year:   self.txtFieldFromMonthYear.text!, to_month_and_year:  self.txtFieldTilMonthYear.text!, flat_no: self.requestPara.flat_no ?? "", type: self.requestPara.type ) { (success, msg) in
            if success{
                if self.objViewModel.arrOfAmount.count > 0{
                    self.runOnMainThread {
                        if self.objViewModel.arrOfAmount.count <= 5 {
                            self.tblViewHeightConstraint.constant =  CGFloat(300)
                        } else {
                            self.tblViewHeightConstraint.constant =  CGFloat(self.objViewModel.arrOfAmount.count * 67)
                        }
                    }
                    self.hideForDuesPayingController(flag:false)
                }else{
                    self.objViewModel.arrOfAmount.removeAll()
                    // self.ShowAlert(title: "", message: "Data not found")
                }
            }else{
                self.runOnMainThread {
                    self.tblViewHeightConstraint.constant =  CGFloat(0)
                }
                self.hideForDuesPayingController(flag:true)
                self.objViewModel.arrOfAmount.removeAll()
                self.ShowAlert(title: "", message: msg)
            }
            if  self.requestPara.mode == PaymentMode.Pending.rawValue{
                self.hideAndShowPayingStuf(flag: false)
            }else{
                self.hideAndShowPayingStuf(flag: true)
            }
            self.runOnMainThread {
                self.tlvHeadData.reloadData()
            }
        }
    }
    func payDues()  {
        let param:[String : Any] = ["mode":"due_payment",
                                    "society_id":Constant.Soiaty_Id,
                                    "building_id":self.requestPara.building_id ?? "",
                                    "flat_no":self.requestPara.flat_no ?? "",
                                    "resident_id":self.resident_id,
                                    "transaction_type":self.requestPara.transactionType,
                                    "paid_by":"S",
                                    "amount":txtTotalAmount.text!,
                                    "cheque_no":self.txtChequeNumber.text!,
                                    "pending_dues":self.requestPara.pending_dues.joined(separator: ",")]
        AuthenticationInterface.shared.payPendingDues(para: param, image: self.image ?? UIImage(), imageName: "transaction_receipt") { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.ShowAlert(title: "", message: msg ?? "")
            }
        }
    }
    
    func validateShowData() ->Bool {
        guard self.requestPara.building_id != nil && self.requestPara.building_id != "" else {
            self.ShowAlert(title: Alert, message: "Please select building")
            return false
        }
        guard self.requestPara.flat_no != nil && self.requestPara.flat_no != "" else {
            self.ShowAlert(title: Alert, message: "Please select flat")
            return false
        }
        guard !self.txtFieldFromMonthYear.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: "Please enter from date")
            return false
        }
        guard !self.txtFieldTilMonthYear.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: "Please enter to date")
            return false
        }
        return true
    }
    
    func validate() ->Bool {
        guard self.requestPara.building_id != nil && self.requestPara.building_id != "" else {
            self.ShowAlert(title: Alert, message: "Please select building")
            return false
        }
        guard self.requestPara.flat_no != nil && self.requestPara.flat_no != "" else {
            self.ShowAlert(title: Alert, message: "Please select flat")
            return false
        }
        guard !self.txtFieldFromMonthYear.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: "Please enter from date")
            return false
        }
        guard !self.txtFieldTilMonthYear.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: "Please enter to date")
            return false
        }
        
        guard self.requestPara.pending_dues.count != 0 else {
            self.ShowAlert(title: Alert, message: "Please select pending dues")
            return false
        }
        if requestPara.transactionType == Mode_of_payment.cash.rawValue{
            guard  !self.txtTotalAmount.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: "Please select amount from pending")
                return false
            }
        }
        if requestPara.transactionType == Mode_of_payment.cheque.rawValue{
            guard !self.txtChequeNumber.text!.isEmpty else{
                self.ShowAlert(title: Alert, message: "Please enter cheque number")
                return false
            }
            guard  !self.txtTotalAmount.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: "Please select amount from pending")
                return false
            }
        }
        if requestPara.transactionType == Mode_of_payment.online.rawValue{
            guard  !self.txtTotalAmount.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: "Please select amount from pending")
                return false
            }
        }
        return true
    }
}
