//
//  EditHeadVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 13/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class EditHeadVC: UIViewController {
    //MARK:- IBOutlet's of the controller-
    @IBOutlet weak var txtfHeadName: UITextField!
    @IBOutlet weak var lblSelectType: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
      //MARK:- Class Variable here -
    var heads:HeadData?
    var headType = 0
    static let identifier = "EditHeadVC"
    var complitionHandlerPops:((Bool)->())?
    var arrDropDownType = Array<DropDownDataModel>()
    let dropDownType = DropDown()
    var headId = ""
    
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDown()
        setData()
    }
    
    //MARK:- IBAction's of the Controller-
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true) {
           // self.complitionHandlerPops?(true)
        }
    }
    @IBAction func saveHead(_ sender: Any) {
        if validate(){
            self.updateHead()
        }
    }
    @IBAction func openDropDown(_ sender: Any) {
        self.dropDownType.show()
    }
}

//MARK:- Custom Function here-
extension EditHeadVC{
    func setData() {
        if heads?.revenue != nil{//for Revenue_Head
            self.txtfHeadName.text = (heads?.revenue)?.head_name ?? ""
            self.lblSelectType.text = (heads?.revenue)?.type_head ?? ""
        }else{//for Expense_Head
            self.txtfHeadName.text = (heads?.expense)?.head_name ?? ""
            self.lblSelectType.text = (heads?.expense)?.type_head ?? ""
        }
    }
}
//MARK:- Api Calling here-
extension EditHeadVC{
    //Validation here
    func validate()->Bool  {
        guard txtfHeadName.text! != "" else {
            self.ShowAlert(title:Alert, message: "Please enter head name")
            return false
        }
        guard  lblSelectType.text! != "Select Type" else {
            self.ShowAlert(title: Alert, message: "Please type")
            return false
        }
        return true
    }
    //api calling to update head either expense or revenue
    func updateHead(){
        let parameters:[String:Any] = ["society_id":Constant.Soiaty_Id,
                                       "head_id":(heads?.revenue)?.head_id ?? (heads?.expense)?.head_id ?? "",
                                       "head_name":self.txtfHeadName.text!,
                                       "type":headType == 1 ? "expense":"revenue",
                                       "head_type":lblSelectType.text!]
        AuthenticationInterface.shared.postApiCalling(para: parameters, endPoint:APIEndPoints.edit_revenue_expense) { (response, success, msg) in
            if success {
                self.dismiss(animated: true) {
                    self.complitionHandlerPops?(true)
                }
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
}

//MARK:- Set for the DropDown
extension EditHeadVC{
    func setUpDropDown()  {
        let arrs:[String] = ["Monthly","Yearly","Any Time"]
        arrDropDownType.removeAll()
        for obj in arrs{
            let dataModel = DropDownDataModel()
            var dict = [String:Any]()
            dict["name"] = obj
            dataModel.dataObject = dict as AnyObject
            dataModel.item = obj
            arrDropDownType.append(dataModel) //appending Value in dropDown
        }
        self.setupDropDown(dropDown: dropDownType)
        dropDownType.dataSource = arrDropDownType
    }
    
    func setupDropDown( dropDown:DropDown){
        dropDown.anchorView = btnDropDown
        dropDown.animationduration = 0.1
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnDropDown.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
          self.lblSelectType.text = item.item ?? ""
         
        }
    }
}
