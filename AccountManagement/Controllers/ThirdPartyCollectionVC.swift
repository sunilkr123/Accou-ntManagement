//
//  ThirdPartyCollectionVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 01/01/20.
//  Copyright © 2020 Wiantech. All rights reserved.
//

import UIKit

class ThirdPartyCollectionVC: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var btnEnterprise: UIButton!
    @IBOutlet weak var lblSelectPartyName: UILabel!
    @IBOutlet weak var lblSelectHead: UILabel!
    @IBOutlet weak var txtEnterAmount: UITextField!
    @IBOutlet weak var txtFieldEnterConfirmAmount: UITextField!
    @IBOutlet weak var tblViewViewTransaction: UITableView!
    @IBOutlet weak var btnViewTransaction: UIButton!
    @IBOutlet weak var btnNameOfPartyDropDown: UIButton!
    @IBOutlet weak var btnNameHeadDropDown: UIButton!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    //MARK:- StackViews outlets's of the Controller-
    @IBOutlet weak var viewForBtns: UIView!
    @IBOutlet weak var viewForTransactionHistory: UIView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTransactionHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var objViewModel: ThirdPartyCollectionViewModel!
    @IBOutlet var objViewModelForRevenueHead: Fetch_all_head_ViewModel!
    
    //MARK:- Class Variables of the Controller-
    let radioController1: RadioButtonController = RadioButtonController()
    let dropDownSelectHead = DropDown()
    let DroDownSelectedParty = DropDown()
    var dropDownSelectOption = DropDown()
    
    var collectionType = 0//0 - for individual, 1 - enterpirses
    
    var dropDownType = 0//0 - for select party, 1 - for edit/add.remove
    
    var partyObj:Party_head?
    var headObj:Revenue_head?
    
    //MARK:- Views Life Cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        intialSetUp()
        fetch_All_Third_Party()
        fetch_all_Revenue_Head()
    }
    
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionIndividual(_ sender: UIButton) {
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        collectionType = 0
        resetText()
         setUpDropDownForPartyList()
    }
    
    @IBAction func btnEnterPrise(_ sender: UIButton) {
        collectionType = 1
        resetText()
        radioController1.buttonArrayUpdated(buttonSelected: sender)
        setUpDropDownForPartyList()
    }
    
    func resetText()  {
       // if   collectionType != 1{
            self.lblSelectPartyName.text = "Select Party"
            self.lblSelectPartyName.textColor = .darkGray
       // }
        
    }
    
    @IBAction func btnActionSelectParty(_ sender: UIButton) {
        dropDownType = 0
       fetch_All_Third_Party()
        self.DroDownSelectedParty.show()
    }
    
    
    @IBAction func btnActionViewTransaction(_ sender: UIButton) {
        if self.objViewModel.arrOfTransaction.count == 0{
            self.ShowAlert(title: Alert, message: "No transaction found")
        }else{
            sender.isSelected = !sender.isSelected
            viewForTransactionHistory.isHidden = !sender.isSelected
            viewTransactionHeightConstrains.constant = sender.isSelected == true ? 220 : 0
        }
    }
    
    @IBAction func btnActionSelectHead(_ sender: UIButton) {
        self.fetch_all_Revenue_Head()
        self.dropDownSelectHead.show()
    }
    
    @IBAction func btnActionMenu(_ sender: UIBarButtonItem) {
        dropDownType = 1
        setDropDownForOption()
        dropDownSelectOption.show()
    }
    
    @IBAction func btnActionPay(_ sender: UIButton) {
        if validate(){
            self.payThirdPartyCollection()
        }
    }
    
}
//MARK:- Custom functions of the Controller-
extension ThirdPartyCollectionVC {
    func setButtonState(){
        radioController1.buttonsArray = [btnIndividual,btnEnterprise]
        radioController1.defaultButton = btnIndividual
    }
    
    //to set intial stuf
    func intialSetUp()  {
        self.applyShadowOnView(viewForBtns)
        self.applyShadowOnView(viewForTransactionHistory)
        self.applyShadowOnView(viewParent)
        self.tblViewViewTransaction.tableFooterView = UIView()
        self.viewForTransactionHistory.isHidden = true
        self.viewTransactionHeightConstrains.constant = 0
        self.setButtonState()
        self.btnViewTransaction.isSelected = false
        self.viewParent.isHidden = true
    }
}
//MARK:- Set for the DropDown
extension ThirdPartyCollectionVC{
    
    
    func setDropDownForOption()  {
        var arrOdObject = Array<DropDownDataModel>()
        let arr = ["Add/Edit Party"]
        for obj in arr{
            let dataModel = DropDownDataModel()
            dataModel.item = obj
            arrOdObject.append(dataModel) //appending Value in dropDown
        }
        dropDownSelectOption.dataSource = arrOdObject
        self.setConstraintOFPartyNameDropDown(dropDown:dropDownSelectOption)
    }
    
    
    //to select the name of the party
    func setUpDropDownForPartyList(){
        var arrOdObject = Array<DropDownDataModel>()
        //Separating data for Induvidual and enterprise
        var arrOfPartyHeadList :[Party_head] = []
        if collectionType == 0{
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
            arrOdObject.append(dataModel) //appending Value in dropDown
        }
        
        //to show message when data is empty
        if arrOdObject.isEmpty{
            self.ShowAlert(title: Alert, message:   "Data not found")
        }else{
            
        }
        DroDownSelectedParty.dataSource = arrOdObject
        self.setConstraintOFPartyNameDropDown(dropDown: DroDownSelectedParty)
    }
    
    //settig layouting fromt the btnmenu
    func setConstraintOFPartyNameDropDown( dropDown:DropDown){
        if dropDownType == 1{
            dropDown.anchorView = btnMenu
        }else{
            dropDown.anchorView = btnNameOfPartyDropDown
        }
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnNameOfPartyDropDown.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            if self.dropDownType == 0{
                self.partyObj = (item.dataObject as! Party_head)
                self.fetchAllTransaction(partyId:self.partyObj?.recv_party_id ?? "")
                self.lblSelectPartyName.text = item.item ?? "" //Value assigned Place.
                self.viewParent.isHidden = false
                self.lblSelectPartyName.textColor = .black
            }else{
                //here redirecting to the viewCotroler by which can add Third Party
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ExpensePartyVC") as! ExpensePartyVC
                vc.isComingFromParty = false
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Drop Down For the list of revenue head
    func setUpHeadDropDown(){
        var arrOdObject = Array<DropDownDataModel>()
        for obj in self.objViewModelForRevenueHead.arrOfRevenue_head{
            let dataModel = DropDownDataModel()
            dataModel.dataObject = obj as AnyObject
            dataModel.item = obj.head_name ?? ""
            arrOdObject.append(dataModel) //appending Value in dropDown
        }
        self.toSetConstraintOfHeadListDropDown(dropDown: dropDownSelectHead)
        dropDownSelectHead.dataSource = arrOdObject
    }
    
    
    func toSetConstraintOfHeadListDropDown( dropDown:DropDown){
        dropDown.anchorView = btnNameHeadDropDown
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnNameHeadDropDown.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            self.headObj = item.dataObject as! Revenue_head
            self.lblSelectHead.text = item.item ?? "" //Value assigned Place.
            self.lblSelectHead.textColor = .black
        }
    }
    
}

//MARK:- UITableViewDataSource,UITableViewDelegate-
extension ThirdPartyCollectionVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objViewModel.arrOfTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTransactionTblCell", for: indexPath) as! ViewTransactionTblCell
        cell.objForParty = self.objViewModel.arrOfTransaction[indexPath.row]
        cell.lblSlNo.text = "\(indexPath.row+1)"
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40.0
    }
    
}
//MARK:- API Calling
extension ThirdPartyCollectionVC{
    
    func fetch_All_Third_Party() {
        self.objViewModel.Fetch_allthird_party_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.setUpDropDownForPartyList()
            }else{
                
            }
        }
    }
    
    func fetch_all_Revenue_Head(){
        self.objViewModelForRevenueHead.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.setUpHeadDropDown()
            }
        }
    }
    
    func fetchAllTransaction(partyId:String)  {
        self.objViewModel.fetch_all_transaction(society_id: Constant.Soiaty_Id, party_id: partyId) { (success, msg) in
            if success{
                DispatchQueue.main.async {
                    self.tblViewViewTransaction.reloadData()
                }
                if self.objViewModel.arrOfTransaction.count == 0{
                    self.resetTransactionView()
                }
            }else{
                self.resetTransactionView()
            }
        }
    }
    
    func resetTransactionView()  {
        viewForTransactionHistory.isHidden = true
        btnViewTransaction.isSelected = false
        self.viewTransactionHeightConstrains.constant = 0
    }
    
    func payThirdPartyCollection() {
        AuthenticationInterface.shared.payThirdPartyCollection(society_id: Constant.Soiaty_Id, amount: txtEnterAmount.text!, head_id: self.headObj?.head_id ?? "", head_name: self.headObj?.head_name ?? "", party_id: self.partyObj?.recv_party_id ?? "") { (response, success, msg) in
            if success{
                self.navigationController?.popViewController(animated: true)
                self.ShowAlert(title: "", message: msg ?? "")
            }
        }
    }
    func validate()  ->Bool{
        guard self.partyObj != nil else {
            self.ShowAlert(title: Alert, message: MessagesEnum.partySelectMessage.rawValue)
            return false
        }
        
        guard self.headObj != nil else {
            self.ShowAlert(title: Alert, message: MessagesEnum.headEmptyMessage.rawValue)
            return false
        }
        
        guard !self.txtEnterAmount.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.expensePartyAmount.rawValue)
            return false
        }
        guard !self.txtFieldEnterConfirmAmount.text!.isEmpty else {
            self.ShowAlert(title: Alert, message: MessagesEnum.confirmAmountMessage.rawValue)
            return false
        }
        guard self.txtFieldEnterConfirmAmount.text! == self.txtEnterAmount.text! else {
            self.ShowAlert(title: Alert, message: MessagesEnum.amountNotMatchMessage.rawValue)
            return false
        }
        return true
    }
}
