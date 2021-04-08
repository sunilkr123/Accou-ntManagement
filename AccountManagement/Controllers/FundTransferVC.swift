//
//  ViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 05/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
//

import UIKit

class FundTransferVC: UIViewController {
    //MARK:- IBOutlet's of the COntroller-
    @IBOutlet weak var lblAvailabelFund: UILabel!
    @IBOutlet weak var viewForBtn: UIView!
    @IBOutlet weak var viewForRevenueHead: UIView!
    @IBOutlet weak var tblViewReveueHead: UITableView!
    @IBOutlet weak var txtFieldEnterAmount: UITextField!
    @IBOutlet weak var viewForExpensesHead: UIView!
    @IBOutlet weak var tblViewExpensesHead: UITableView!
    @IBOutlet weak var btnExpesesHead: UIButton!
    @IBOutlet weak var btnrevenueHead: UIButton!
    @IBOutlet weak var objViewModel: FundTransferViewModel!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var lblBottomHeading: UILabel!
    
    //MARK:- Class Variable -
    let radioController: RadioButtonController = RadioButtonController()
    var isSelectedRevenueHead = true
    var isSelectedExpenseHead = true
    static let idientifier = "FundTransferVC"
    var revenueSelctedIndex:Int = 0
    var expenseSelectedIndex:Int = 0
    var selectedAmount = 0.0
    var sender_Id = ""
    var reciever_Id = ""
    
    //For the expense to expense transfer
    var arrOfBottomExpense:[Expense_head] = []
    var isForRevenueToExpense = true
    
    //MARK:- Views LifeCycle of the Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch_all_head()
    }
    
    
    //MARK:- IBAction's of the COntroller-
    @IBAction func btnActionRevenueToExpenses(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        isForRevenueToExpense = true
        self.lblAvailabelFund.text = "₹ \(self.objViewModel.totalAvailableFund)"
        self.sender_Id = self.objViewModel.arrOfRevenue_head.first?.head_id ?? ""
        //to keep the selected head's available amount here
        if let selectedAmount = Double(self.objViewModel.arrOfRevenue_head.first?.available_amount ?? "0"){
            self.selectedAmount = selectedAmount
        }
        self.reciever_Id = self.objViewModel.arrOfExpense_head.first?.head_id ?? ""
        lblTopHeading.text = HeadName.Revenue.rawValue
        lblBottomHeading.text = HeadName.Expense.rawValue
        self.revenueSelctedIndex = -1
        isSelectedRevenueHead = false
        self.sender_Id = ""
        reloadTableView()
    }
    
    @IBAction func btnActionExepenseToExpenses(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        self.arrOfBottomExpense =  self.objViewModel.arrOfExpense_head
        self.lblAvailabelFund.text = "₹ \(self.objViewModel.totalOfExpenseHead)"
        self.sender_Id = self.objViewModel.arrOfExpense_head.first?.head_id ?? ""
      //in case of expense keeping the sender's head's available amount to check entered amount 
        if let selectedAmount = Double(self.objViewModel.arrOfExpense_head.first?.available_amount ?? "0"){
            self.selectedAmount = selectedAmount
        }
        self.reciever_Id = self.arrOfBottomExpense.first?.head_id ?? ""
        lblTopHeading.text = HeadName.Expense.rawValue
        lblBottomHeading.text = HeadName.Expense.rawValue
        isForRevenueToExpense = false
        self.sender_Id = ""
        self.revenueSelctedIndex = -1
        self.removeObjFirstTime()
        reloadTableView()
    }
    
    @IBAction func btnActionTransfer(_ sender: UIButton) {
        if self.sender_Id == "" {
            self.isSelectedRevenueHead = false
            self.ShowAlert(title: Alert, message: MessagesEnum.SelectRevenueHead.rawValue)
        } else if self.reciever_Id == "" {
            self.isSelectedExpenseHead = false
            self.ShowAlert(title: Alert, message: MessagesEnum.SelectExpenseHead.rawValue)
        }else if txtFieldEnterAmount.text!.isEmpty {
            self.ShowAlert(title: Alert, message: MessagesEnum.EnterAmount.rawValue)
        } else {
            if let amount  = Double(self.txtFieldEnterAmount.text!){//checking the entered amount with available amount of the head
                if self.selectedAmount > amount{
                    self.transfer()
                }else {
                    self.ShowAlert(title: Alert, message: "Please enter amount less than available amount")
                }
            }
        }
    }
}


//MARK:- Custom functions of the Controller-
extension FundTransferVC {
    
    /*
     revenue to expense- rtoe
     expense to expense - etoe
     */
    func transfer(){
        let obj = TransferDataModel(society_id: Constant.Soiaty_Id, transfer_head_id: self.sender_Id, reciever_head_id: self.reciever_Id, type: isForRevenueToExpense == true ? "rtoe" :"etoe", amount: self.txtFieldEnterAmount.text!)
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: TransferFundVC.identifier) as! TransferFundVC
        popOverVC.obj = obj
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.complitionHandlerPops = { (pust, msg) in
            self.ShowAlert(title: "", message: msg)
        }
        self.navigationController?.present(popOverVC, animated: true, completion: nil)
    }
    
    func initialSetUp()  {
        tblViewReveueHead.registerCellNib(FundTransferCommonTblViewCell.self)
        tblViewExpensesHead.registerCellNib(FundTransferCommonTblViewCell.self)
        self.applyShadowOnView(viewForRevenueHead)
        self.applyShadowOnView(viewForExpensesHead)
        self.applyShadowOnView(viewForBtn)
        self.setButtonState()
    }
    
    func fetch_all_head(){ //Called API For Heads-
        self.objViewModel.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success,message) in
            if success {
                self.runOnMainThread {
                    self.lblAvailabelFund.text = "₹ \(self.objViewModel.totalAvailableFund)"
                    self.sender_Id = self.objViewModel.arrOfRevenue_head.first?.head_id ?? ""
                    //to keep the selected head's available amount here
                    if let selectedAmount = Double(self.objViewModel.arrOfRevenue_head.first?.available_amount ?? "0"){
                        self.selectedAmount = selectedAmount
                    }
                    self.reciever_Id = self.objViewModel.arrOfExpense_head.first?.head_id ?? ""
                    self.tblViewExpensesHead.reloadData()
                    self.tblViewReveueHead.reloadData()
                }
            }else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setButtonState(){
        radioController.buttonsArray = [btnExpesesHead,btnrevenueHead]
        radioController.defaultButton = btnrevenueHead
    }
    func reloadTableView()  {
        DispatchQueue.main.async {
            self.tblViewReveueHead.reloadData()
            self.tblViewExpensesHead.reloadData()
        }
    }
    //removing object when selct expense to expense first time when open this screen
    func removeObjFirstTime(){
        //to remove selcted obj from the bottom
        let selcetedObj = self.objViewModel.arrOfExpense_head[0]
        if let index = self.arrOfBottomExpense.firstIndex(where: { (expenseObj) -> Bool in
            return expenseObj.head_id == selcetedObj.head_id
        }){
            self.arrOfBottomExpense.remove(at: index)
        }
        self.reloadTableView()
    }
    
} //Class Ends Here
//MARK:- IUITableViewDelegate,UITableViewDataSource-
extension FundTransferVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isForRevenueToExpense{
            return tableView == tblViewReveueHead ? objViewModel.arrOfRevenue_head.count : objViewModel.arrOfExpense_head.count
        }else{
            return tableView == tblViewReveueHead ? self.objViewModel.arrOfExpense_head.count : self.arrOfBottomExpense.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblViewReveueHead {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FundTransferCommonTblViewCell", for: indexPath) as! FundTransferCommonTblViewCell
          
            cell.onTappingCheckMark(didTaponCheckBox: {//to check the button on cell
                self.onPressedCheckButton(indexPath, tableview: tableView)
            })
            
            if self.revenueSelctedIndex == indexPath.row{
                cell.btnCheckMark.setImage(UIImage(named:"checked_box"), for: .normal)
            }else{
                cell.btnCheckMark.setImage(UIImage(named:"check_box"), for: .normal )
            }
            
            if !self.isForRevenueToExpense{
                cell.setDataOnExpense_headCell(expense_Head: self.objViewModel.arrOfExpense_head[indexPath.row])
            }else{
                cell.setDataOnRevenue_headCell(revenue_Head: objViewModel.arrOfRevenue_head[indexPath.row])
            }
            
            tableView.separatorInset = .zero
            tableView.layoutMargins = .zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FundTransferCommonTblViewCell", for: indexPath) as! FundTransferCommonTblViewCell
            cell.onTappingCheckMark(didTaponCheckBox: {//to check the button on cell
                self.onPressedCheckButton(indexPath, tableview: tableView)
            })
            if self.expenseSelectedIndex == indexPath.row{
                cell.btnCheckMark.setImage(UIImage(named:"checked_box"), for: .normal)
            }else{
                cell.btnCheckMark.setImage(UIImage(named:"check_box"), for: .normal )
            }
            if !isForRevenueToExpense{
                cell.setDataOnExpense_headCell(expense_Head: self.arrOfBottomExpense[indexPath.row])
            }else{
                cell.setDataOnExpense_headCell(expense_Head: objViewModel.arrOfExpense_head[indexPath.row])
                tableView.separatorInset = .zero
                tableView.layoutMargins = .zero
            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tblViewReveueHead ? 50 : 50
    }
    func onPressedCheckButton(_ indexpath:IndexPath,tableview:UITableView){
        if tableview == self.tblViewReveueHead {
            if !isForRevenueToExpense{
                
                //reseting the bottom array before removing
                self.arrOfBottomExpense = self.objViewModel.arrOfExpense_head
                self.reloadTableView()
                self.sender_Id = objViewModel.arrOfExpense_head[indexpath.row].head_id ?? ""
              
                //to keep the available amount from the selected
                if let selectedAmount = Double(objViewModel.arrOfExpense_head[indexpath.row].available_amount ?? "0"){
                    self.selectedAmount = selectedAmount
                }
                
                //to remove selcted obj from the bottom
                let selcetedObj = self.objViewModel.arrOfExpense_head[indexpath.row]
                if let index = self.arrOfBottomExpense.firstIndex(where: { (expenseObj) -> Bool in
                    return expenseObj.head_id == selcetedObj.head_id
                }){
                    self.arrOfBottomExpense.remove(at: index)
                }
            }else{
                //to keep the available amount from the selected
                if let selectedAmount = Double(objViewModel.arrOfRevenue_head[indexpath.row].available_amount ?? "0"){
                    self.selectedAmount = selectedAmount
                }
                self.sender_Id = objViewModel.arrOfRevenue_head[indexpath.row].head_id ?? ""
            }
            self.revenueSelctedIndex = indexpath.row
            DispatchQueue.main.async {
                tableview.reloadData()
            }
        } else {
            self.expenseSelectedIndex = indexpath.row
            DispatchQueue.main.async {
                tableview.reloadData()
            }
            if !isForRevenueToExpense{
                self.reciever_Id = self.arrOfBottomExpense[indexpath.row].head_id ?? ""
            }else{
                self.reciever_Id = objViewModel.arrOfExpense_head[indexpath.row].head_id ?? ""
            }
        }
    }
}


