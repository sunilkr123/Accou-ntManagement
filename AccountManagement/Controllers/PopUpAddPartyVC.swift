//
//  PopUpAddPartyVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 10/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class PopUpAddPartyVC: UIViewController {
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelectParty: UIButton!
    @IBOutlet weak var lblSelectParty: UILabel!
    @IBOutlet var objViewModel: PaymentViewModel!
    @IBOutlet var objthirdPartyViewModel: ThirdPartyCollectionViewModel!
    //MARK:- Class Variable here -
    var complitionHandlerPops:((AnyObject)->())?
    var complitionHandlerForRemovingParty:((Bool)->())?
    var arrSelectPartyDropDown = Array<DropDownDataModel>()
    let dropDownSelectType = DropDown()
    var expensePartyObj:AnyObject?
    var partyObj:Party_head?
    var isComingFromParty = false//for false  - from third party, true - from expense party screen
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingFromParty{
            getAllPartyList()
        }else{
            fetch_All_Third_Party()
        }
    }
    //MARK:- IBAction of The Controller-
    @IBAction func btnActionRemove(_ sender: UIButton) {
        if self.lblSelectParty.text! == "Select party"{
            self.ShowAlert(title: Alert, message: "Please select party name")
        }else{
            if isComingFromParty{
                self.removeParty()
            }else{
                self.removeThirdPArty()
            }
        }
    }
    @IBAction func btnActionNew(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnActionEdit(_ sender: UIButton) {
        if self.expensePartyObj != nil{
            self.dismiss(animated: true){
                if let partyObj = self.expensePartyObj{
                    self.complitionHandlerPops!(partyObj)
                }
            }
        }else{
            self.ShowAlert(title: Alert, message: "Please select party name")
        }
    }
    @IBAction func btnOpenDropDown(_ sender: Any) {
        if self.isComingFromParty{
            getAllPartyList()
        }else{
            fetch_All_Third_Party()
        }
        dropDownSelectType.show()
    }
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
//MARK:- For drop down
extension PopUpAddPartyVC{
    func setUpDropDown(){
        arrSelectPartyDropDown.removeAll()
        if isComingFromParty{//from expense party
            for obj in self.objViewModel.arrOfParty{
                let dataModel = DropDownDataModel()
                dataModel.dataObject = obj as AnyObject
                dataModel.item = obj.party_name ?? ""
                arrSelectPartyDropDown.append(dataModel) //appending Value in dropDown
            }
        }else{
            for obj in self.objthirdPartyViewModel.arrOfParty{
                let dataModel = DropDownDataModel()
                dataModel.dataObject = obj as AnyObject
                dataModel.item = obj.party_name ?? ""
                arrSelectPartyDropDown.append(dataModel) //appending Value in dropDown
            }
        }
        self.setupDropDown(dropDown: dropDownSelectType)
        dropDownSelectType.dataSource = self.arrSelectPartyDropDown
    }
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = btnSelectParty
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
            let dict = item.dataObject as!  AnyObject
            self.expensePartyObj = dict
            self.lblSelectParty.text = item.item ?? ""
        }
    }
}
//Api Calling
extension PopUpAddPartyVC{
    func getAllPartyList(){
        self.objViewModel.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.setUpDropDown()
            }else{
                
            }
        }
    }
    func removeParty()  {
        AuthenticationInterface.shared.removeExpenseParty(society_id:Constant.Soiaty_Id, party_id:(self.expensePartyObj as! Party_head).party_id ?? "") { (response, success, msg) in
            if success{
                //do the code here
                self.dismiss(animated: false) {
                    self.complitionHandlerForRemovingParty?(true)
                }
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
    func removeThirdPArty()  {
        AuthenticationInterface.shared.removeThirdParty(society_id:Constant.Soiaty_Id, party_id:(self.expensePartyObj as! Party_head).recv_party_id ?? "") { (response, success, msg) in
            if success{
                //do the code here
                self.dismiss(animated: false) {
                    self.complitionHandlerForRemovingParty?(true)
                }
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
    //recv_party_id.
    func fetch_All_Third_Party() {
        self.objthirdPartyViewModel.Fetch_allthird_party_head(society_id: Constant.Soiaty_Id) { (success, msg) in
            if success{
                self.setUpDropDown()
            }else{
                
            }
        }
    }
}
