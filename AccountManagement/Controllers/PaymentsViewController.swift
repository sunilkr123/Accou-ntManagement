//
//  PaymentsViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 06/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
import Razorpay

class PaymentsViewController: UIViewController {
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var btnEnterprise: UIButton!
    @IBOutlet weak var lblSelectPartyName: UILabel!
    @IBOutlet weak var lblSelectHead: UILabel!
    @IBOutlet weak var txtEnterAmount: UITextField!
    @IBOutlet weak var txtFieldEnterConfirmAmount: UITextField!
    @IBOutlet weak var btnGSTSlab: UIButton!
    @IBOutlet weak var txtFieldGSTNo: UITextField!
    @IBOutlet weak var tblViewViewTransaction: UITableView!
    @IBOutlet weak var btnViewTransaction: UIButton!
    @IBOutlet weak var btnHead: UIButton!
    @IBOutlet weak var txtAccountNUmber: UITextField!
    @IBOutlet weak var txtfConfirmAccountNumber: UITextField!
    @IBOutlet weak var txtfIFSCCode: UITextField!
   // @IBOutlet weak var btnGSTSlab: UIButton!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var objViewModel: PaymentViewModel!
    @IBOutlet weak var objHeadViewModel: Fetch_all_head_ViewModel!
    @IBOutlet weak var btnExcludeGSt: UIButton!
    
    //MARK:- StackViews outlets's of the Controller-
    @IBOutlet weak var viewForBtns: UIView!
    @IBOutlet weak var viewForTransactionHistory: UIView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lblAvailableAmount: UILabel!
    @IBOutlet weak var stackAvailableAmount: UIStackView!
    @IBOutlet weak var stackViewPayOnline: UIStackView!
    @IBOutlet weak var viewChild: UIView!
    @IBOutlet weak var viewTransactionHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var btnPercentage: UIButton!
    @IBOutlet weak var btnSelectParty: UIButton!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblSumTotal: UILabel!
    
    //MARK:- Class Variables of the Controller-
    let radioController1: RadioButtonController = RadioButtonController()
    //for party list
    var arrSelectPartyDropDown = Array<DropDownDataModel>()
    let dropDownSelectParty = DropDown()
    
    //for option menu
     let dropDownToSelectOption = DropDown()
    
    //for gst slab
    var arrSelectGSTSlapDropDown = Array<DropDownDataModel>()
    let dropDownGstSlab = DropDown()
    
    //for head list
    var arrSelectHeadsDropDown = Array<DropDownDataModel>()
    let dropDownHead = DropDown()
    
    var dropDownType = 0// 0 - party, 1 - head, 2 - Percentage
    var party_id = ""
    var head_id = ""
    var payOnline = false // for payment mode like online or not
    
    var isExcludeGst = false //To check gst is excluded or not
    
    var paymentType = ExpensePartyType.Individual.rawValue // to check it is individual or enterprises
    
    var razorpayObj : RazorpayCheckout? = nil //for razor pay
    
    var thirdPartyObj:Party_head?//to set the data on razor pay
    
    //MARK:- Views Life Cycle of the Controller-
    override func viewDidLoad(){
        super.viewDidLoad()
        intialSetUp()
        dropDownType = 2
        setUpDropDown()
    }
    
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionIndividual(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        paymentType = ExpensePartyType.Individual.rawValue
        resetPartyLabel()
    }
    
    @IBAction func btnEnterPrise(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        paymentType = ExpensePartyType.Enterprise.rawValue
        resetPartyLabel()
    }
    
    @IBAction func btnActionSelectParty(_ sender: UIButton) {
        self.dropDownType = 0
        fetch_party_head()
        dropDownSelectParty.show()
    }
    
    @IBAction func btnActionViewTransaction(_ sender: UIButton) {
         self.fetch_all_transaction()
    }

    func showTransactionList(message:String)  {
        if self.objViewModel.arrOfTransaction.count > 0{
            btnViewTransaction.isSelected = !btnViewTransaction.isSelected
//            viewForTransactionHistory.isHidden = !btnViewTransaction.isSelected
             viewForTransactionHistory.isHidden = false
           // viewTransactionHeightConstrains.constant = btnViewTransaction.isSelected == true ? 220 : 0
            viewTransactionHeightConstrains.constant =  220
        }else{
             viewTransactionHeightConstrains.constant =  0
             viewForTransactionHistory.isHidden = true
            self.ShowAlert(title: Alert, message: message)
        }
    }
    
    @IBAction func btnActionSelectHead(_ sender: UIButton) {
        dropDownType = 1
        fetch_all_expenseHead()
        dropDownHead.show()
        
    }
    
    @IBAction func btnActionGSTSlab(_ sender: UIButton) {
        dropDownType = 2
        setUpDropDown()
        dropDownGstSlab.show()
    }
    
    @IBAction func btnActionGSTExcluding(_ sender: UIButton) {
        if lblPercentage.text! == "0%" || lblPercentage.text! == "Select GST"{
            self.ShowAlert(title: Alert, message: MessagesEnum.GStSlabEmptyMessage.rawValue)
        }else if txtFieldGSTNo.text!.isEmpty{
            self.ShowAlert(title: Alert, message: MessagesEnum.gstEmptyMessage.rawValue)
        }
        else if ((txtFieldGSTNo.text!.trimmingCharacters(in: .whitespaces)).isValidGSTIN()){
            self.ShowAlert(title: Alert, message: MessagesEnum.GstValidateMessage.rawValue)
        }
        else{
            self.btnExcludeGSt.isSelected = !sender.isSelected
            debugPrint( self.btnExcludeGSt.isSelected)//isExcludeGst
            if !sender.isSelected{
                lblPercentage.text! = "0%"
                txtFieldGSTNo.text = ""
            }
        }
    }
    
    @IBAction func btnActionPayOnline(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        payOnline = sender.isSelected == true ? true : false
        self.stackViewPayOnline.isHidden = !sender.isSelected
    }
    
    @IBAction func btnActionPay(_ sender: UIButton) {
        if validate(){
            if self.payOnline{
                 self.openRazorpayCheckout()
            }else{
              self.payPayment()
            }
        }
    }
    
    @IBAction func btnActionMenu(_ sender: UIBarButtonItem) {
        dropDownType = 3
        openDropDownFromMenu()
        dropDownToSelectOption.show()
    }
    
}
//MARK:- Custom functions of the Controller-
extension PaymentsViewController {
    
    
    func resetPartyLabel()  {
          self.party_id = ""
        self.lblSelectPartyName.text = "Select Party"
        self.lblSelectPartyName.textColor = .darkGray
    }
    
    func intialSetUp(){
        self.applyShadowOnView(viewForBtns)
        self.applyShadowOnView(viewForTransactionHistory)
        self.applyShadowOnView(viewParent)
        self.tblViewViewTransaction.tableFooterView = UIView()
        self.viewForTransactionHistory.isHidden = true
        self.viewTransactionHeightConstrains.constant = 0
        self.setButtonState()
        self.btnViewTransaction.isSelected = false
        self.btnViewTransaction.isHidden = true
        self.fetch_party_head()
        self.fetch_all_expenseHead()
        viewForTransactionHistory.isHidden = true
        viewParent.isHidden = true
    }
    
    func setButtonState(){
        radioController1.buttonsArray = [btnIndividual,btnEnterprise]
        radioController1.defaultButton = btnIndividual
    }
}
//MARK:- UITableViewDataSource,UITableViewDelegate-
extension PaymentsViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objViewModel.arrOfTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTransactionTblCell", for: indexPath) as! ViewTransactionTblCell
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        cell.obj = self.objViewModel.arrOfTransaction[indexPath.row]
        cell.lblSlNo.text = "\(indexPath.row+1)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Index Path \(indexPath.row)")
    }
}

//MARK:- For drop down
extension PaymentsViewController{
    
    //for optin view
    func openDropDownFromMenu()  {
        let arr:[String] = ["Add/Edit Party"]
        var arrToOptionView = Array<DropDownDataModel>()
        for obj in arr{
            let dataModel = DropDownDataModel()
            dataModel.item = obj
            arrToOptionView.append(dataModel)//appending Value in dropDown
        }
        self.setupDropDown(dropDown:dropDownToSelectOption)
        dropDownToSelectOption.dataSource = arrToOptionView
    }
    
    //for gst slab
    func setUpDropDown(){
        let arr = ["0%","5%","15%","18%","28%"]
        if btnExcludeGSt.isSelected == false{
            lblPercentage.text = arr.first ?? ""
        }
        arrSelectGSTSlapDropDown.removeAll()
        for obj in arr{
            let dataModel = DropDownDataModel()
            dataModel.item = obj
            arrSelectGSTSlapDropDown.append(dataModel)//appending Value in dropDown
        }
        self.setupDropDown(dropDown:dropDownGstSlab)
        dropDownGstSlab.dataSource = self.arrSelectGSTSlapDropDown
    }
    
    //for head list
    func SetHeadDropDown()  {
        arrSelectHeadsDropDown.removeAll()
        for obj in self.objHeadViewModel.arrOfExpense_head{
            let dataModel = DropDownDataModel()
            dataModel.dataObject = obj as AnyObject
            dataModel.item = obj.head_name ?? ""
            arrSelectHeadsDropDown.append(dataModel)//appending Value in dropDown
        }
        self.setupDropDown(dropDown: dropDownHead)
        dropDownHead.dataSource = self.arrSelectHeadsDropDown
    }
    
    //to set the party list in drop down
    func setDropDownForPartyHead(){
        arrSelectPartyDropDown.removeAll()
        var arrOfPartyHeadList :[Party_head] = []
        if paymentType == ExpensePartyType.Individual.rawValue{
            arrOfPartyHeadList  = self.objViewModel.arrOfParty.filter { (partyObj) -> Bool in
                return partyObj.party_type == ExpensePartyType.Individual.rawValue
            }
        }else{
            arrOfPartyHeadList  = self.objViewModel.arrOfParty.filter { (partyObj) -> Bool in
                return partyObj.party_type == ExpensePartyType.Enterprise.rawValue
            }
        }
        for obj in arrOfPartyHeadList{
            let dataModel = DropDownDataModel()
            dataModel.dataObject = obj as AnyObject
            dataModel.item = obj.party_name ?? ""
            arrSelectPartyDropDown.append(dataModel) //appending Value in dropDown
        }
        self.setupDropDown(dropDown: dropDownSelectParty)
        dropDownSelectParty.dataSource = self.arrSelectPartyDropDown
    }
    
    //common for all
    func setupDropDown( dropDown:DropDown){
        if dropDownType == 0{//for party
            dropDown.anchorView = btnSelectParty
        }else if dropDownType == 1{//head
            dropDown.anchorView = btnHead
        }else if dropDownType == 2{//for percentage
            dropDown.anchorView = btnGSTSlab
        } else {
            dropDown.anchorView = btnMenu
        }
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectParty.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            if self.dropDownType == 0{//for party
                self.lblSelectPartyName.text = item.item ?? ""
                self.lblSelectPartyName.textColor = .black
                self.thirdPartyObj = item.dataObject as? Party_head
                self.party_id =  self.thirdPartyObj?.party_id ?? ""
                self.txtfIFSCCode.text =  self.thirdPartyObj?.iFSC_code ?? ""
                self.txtfConfirmAccountNumber.text =  self.thirdPartyObj?.bank_account_no ?? ""
                self.txtAccountNUmber.text =  self.thirdPartyObj?.bank_account_no ?? ""
                self.btnViewTransaction.isHidden = false
                self.viewParent.isHidden = false
               self.fetch_all_transaction()
            }else if self.dropDownType == 1{//Expense head
                self.lblSelectHead.text = item.item ?? ""
                self.stackAvailableAmount.isHidden = false
                let obj = item.dataObject as! Expense_head
                self.lblAvailableAmount.text = obj.available_amount ?? ""
                self.lblAvailableAmount.textColor = .black
                self.head_id = obj.head_id ?? ""
                }else if self.dropDownType == 2{//for GST Slab
                if self.btnExcludeGSt.isSelected{
                    if (item.item!) != "0%"{
                        self.lblPercentage.text = item.item ?? ""
                    }else{
                        self.ShowAlert(title:Alert, message: "Please select different gst slab.")
                    }
                }else{
                  self.lblPercentage.text = item.item ?? ""
                }
                self.lblPercentage.textColor = .black
            } else {
                //here redirecting to the screen where ou can add expense party
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ExpensePartyVC") as! ExpensePartyVC
                vc.isComingFromParty = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


// RazorpayPaymentCompletionProtocol - This will execute two methods 1.Error and 2. Success case. On payment failure you will get a code and description. In payment success you will get the payment id.
extension PaymentsViewController : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        self.ShowAlert(title: Alert, message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
         //self.razorpayObj?.close()
        //self.navigationController?.popViewController(animated: true)
       // self.ShowAlert(title: Alert, message: "Payment Succeeded")
         self.payPayment()
    }
}

// RazorpayPaymentCompletionProtocolWithData - This will returns you the data in both error and success case. On payment failure you will get a code and description. In payment success you will get the payment id.
extension PaymentsViewController: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        self.ShowAlert(title: Alert, message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        //self.callApiBillingForCOD(paymentType: "online")
       self.payPayment()
       
    }
}



//MARK:- API Calling here
extension PaymentsViewController{
    
    private func openRazorpayCheckout() {
        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
        razorpayObj = RazorpayCheckout.initWithKey(Constant.rzp_test_Key, andDelegate: self)
        let options: [AnyHashable:Any] = [
            "prefill": [
                "contact":  self.thirdPartyObj?.mobile_no ?? "",//place mobile number
                "email":  self.thirdPartyObj?.email ?? ""//place here the email
            ],
            "image": "",
            "amount" : (Int(txtFieldEnterConfirmAmount.text!) ?? 0)*100,//Amount will multiply by 100 so will show actual amount.
            "name": "\(self.lblSelectPartyName.text!)",
            "theme": [
                "color": "F6F6F6"
            ]
        ]
        if let rzp = self.razorpayObj {
            rzp.open(options)
        } else {
            print("Unable to initialize")
        }
    }
    
    func fetch_party_head(){
        self.objViewModel.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.setDropDownForPartyHead()
            }else{
                self.ShowAlert(title: Alert, message: msg)
            }
        }
    }
    
    func fetch_all_expenseHead()  {
        self.objHeadViewModel.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.SetHeadDropDown()
            }else{
                self.ShowAlert(title: Alert, message: msg)
            }
        }
    }
    
    //to get all transaction
    func fetch_all_transaction(){
        self.objViewModel.fetch_all_transaction(society_id: Constant.Soiaty_Id, party_id:self.thirdPartyObj?.party_id ?? "") { (success, msg) in
            if success{
                self.showTransactionList(message: msg)
                DispatchQueue.main.async {
                    self.tblViewViewTransaction.reloadData()
                }
            }else{
                self.showTransactionList(message: msg)
                DispatchQueue.main.async {
                    self.tblViewViewTransaction.reloadData()
                }
            }
        }
    }
    
    func payPayment(){
        self.objViewModel.addPayment(society_id: Constant.Soiaty_Id, party_id:self.thirdPartyObj?.party_id ?? "", transaction_done_by: payOnline == true ? "Online":"Manually", head_id: self.head_id, head_name: self.lblSelectHead.text!, gst: self.lblPercentage.text!, gst_no: txtFieldGSTNo.text!, amount:txtEnterAmount.text!) { (success, msg) in
            if success{
                //self.ShowAlert(title: "Success", message: msg)
                //debugPrint(msg  ," at line umber 415")
              //  self.ShowAlert(title: "Success", message: msg) { (action) in
                    if self.payOnline{
                        self.razorpayObj?.close()
                    }
                    self.navigationController?.popViewController(animated: true)
               // }
                
            }else{
                self.ShowAlert(title: Alert, message: msg)
            }
        }
    }
    
    //to validate
    func validate()->Bool  {
        guard self.party_id != "" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.partySelectMessage.rawValue)
            return false
        }
        
        guard self.head_id != "" else {
            self.ShowAlert(title: Alert, message: MessagesEnum.headEmptyMessage.rawValue)
            return false
        }
        
        guard !self.txtEnterAmount.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.expensePartyAmount.rawValue)
            return false
        }
        
        guard !self.txtFieldEnterConfirmAmount.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.confirmAmountMessage.rawValue)//
            return false
        }
        guard self.txtEnterAmount.text! == txtFieldEnterConfirmAmount.text! else {
            self.ShowAlert(title: Alert, message: MessagesEnum.amountNotMatchMessage.rawValue)
            return false
        }
    
//        guard lblPercentage.text! != "0%"else{
//            self.ShowAlert(title: Alert, message: MessagesEnum.GStSlabEmptyMessage.rawValue)
//            return false
//        }
//
//        guard lblPercentage.text! != "Select GST"else{
//            self.ShowAlert(title: Alert, message: MessagesEnum.GStSlabEmptyMessage.rawValue)
//            return false
//        }
        
//        guard !self.txtFieldGSTNo.text!.isEmpty else {
//            self.ShowAlert(title: Alert, message: MessagesEnum.gstEmptyMessage.rawValue)
//            return false
//        }
//
//        guard (self.txtFieldGSTNo.text!.trimmingCharacters(in: .whitespaces)).isValidGSTIN() else {
//            self.ShowAlert(title: Alert, message: MessagesEnum.GstValidateMessage.rawValue)
//            return false
//        }
        
        guard (Double(self.lblAvailableAmount.text ?? "0.0") ?? 0) > (Double(txtEnterAmount.text ?? "0.0") ?? 0) else {
            self.ShowAlert(title: Alert, message: MessagesEnum.PaymentValidation.rawValue)
            return false
        }
        if self.payOnline{
            guard !txtfConfirmAccountNumber.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.accountNumberEmptyMessage.rawValue)
                return false
            }
            guard !txtfConfirmAccountNumber.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.confirmAccountNumberMessage.rawValue)
                return false
            }
            guard txtfConfirmAccountNumber.text! == txtAccountNUmber.text! else {
                self.ShowAlert(title: Alert, message: MessagesEnum.accountDoesNotMatch.rawValue)
                return false
            }
            guard !txtfIFSCCode.text!.isEmpty else {
                self.ShowAlert(title: Alert, message: MessagesEnum.ifscCodeMEssage.rawValue)
                return false
            }
        }
        //validate successfully
        return true
    }
}

//MARK:- delegate of textFiled
extension PaymentsViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.txtEnterAmount.text! == self.txtFieldEnterConfirmAmount.text!{
            if self.txtEnterAmount.text!.count == self.txtFieldEnterConfirmAmount.text!.count{
                lblSumTotal.text = self.txtEnterAmount.text!
            }
        }
    }
    
}
