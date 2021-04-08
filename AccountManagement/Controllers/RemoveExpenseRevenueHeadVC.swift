//
//  RemoveExpenseRevenueHeadVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class RemoveExpenseRevenueHeadVC: UIViewController {
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var lblHeadName: UILabel!
    @IBOutlet weak var btnSelectHead: UIButton!
    
    //MARK:- Class Variable here -
    var objViewModel: Fetch_all_head_ViewModel!
    static let identifier = "RemoveExpenseRevenueHeadVC"
    var complitionHandlerPops:((Bool)->())?
    var arrSelectHeadDropDown = Array<DropDownDataModel>()
    let dropDownSelectHead = DropDown()
    var headType = 0
    var oldHeadId = ""
    var newheadID = ""
    
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch_all_head()
    }
    //MARK:- IBAction of The Controller-
    @IBAction func btnActionRemove(_ sender: UIButton) {
        if lblHeadName.text! != "Select Head"{
        if headType == 1{
            self.removeHeads(type: "expense")
        }else{
            self.removeHeads(type: "revenue")
        }
        self.dismiss(animated: false)
        }else{
            self.ShowAlert(title: Alert, message: "Please select head")
        }
    }
    @IBAction func btnOpenDropDown(_ sender: Any) {
        dropDownSelectHead.show()
    }
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
//MARK:- For drop down
extension RemoveExpenseRevenueHeadVC{
    func setUpDropDown(expenseHead:[Expense_head]?,revenue:[Revenue_head]?){
        arrSelectHeadDropDown.removeAll()
        if headType == 1{
            if let expenseHead = expenseHead{
                for obj in expenseHead{
                    let dataModel = DropDownDataModel()
                    var dict = [String:Any]()
                    dict["name"] = obj.head_name
                    dict["id"] = obj.head_id
                    dataModel.dataObject = dict as AnyObject
                    dataModel.item = obj.head_name ?? ""
                    arrSelectHeadDropDown.append(dataModel) //appending Value in dropDown
                }
            }
            
        }else{
            if let revenueHead = revenue{
                for obj in revenueHead{
                    let dataModel = DropDownDataModel()
                    var dict = [String:Any]()
                    dict["name"] = obj.head_name ?? ""
                    dict["id"] = obj.head_id ?? ""
                    dataModel.dataObject = dict as AnyObject
                    dataModel.item = obj.head_name ?? ""
                    arrSelectHeadDropDown.append(dataModel) //appending Value in dropDown
                }
            }
        }
        self.setupDropDown(dropDown: dropDownSelectHead)
        dropDownSelectHead.dataSource = self.arrSelectHeadDropDown
    }
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = btnSelectHead
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectHead.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            if let headId = item.dataObject?["id"] as? String{
                self.newheadID = headId
            }
            self.lblHeadName.text = item.item ?? ""
            debugPrint(self.newheadID)
        }
    }
    //tog get all heads list
    func fetch_all_head(){
        headFetch().Fetch_all_head(society_id: Constant.Soiaty_Id) { (success,message,datas) in
            if success {
                self.runOnMainThread {
                    self.setUpDropDown(expenseHead: datas.0, revenue: datas.1)
                }
            }else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    //to call api to remove heads
    func removeHeads(type:String) {
        AuthenticationInterface.shared.remove_head(society_id: Constant.Soiaty_Id, old_head_id: self.oldHeadId, new_head_id: newheadID, type: type) { (response, success, msg) in
            if success{
                self.dismiss(animated: true) {
                    self.complitionHandlerPops!(true)
                    
                }
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
}
