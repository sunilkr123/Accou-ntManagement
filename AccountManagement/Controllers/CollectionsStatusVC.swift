//
//  CollectionsStatusVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 06/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

class CollectionsStatusVC: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewForBtns: UIView!
    @IBOutlet weak var btnFlatWise: UIButton!
    @IBOutlet weak var btnRevenueHeadWise: UIButton!
    @IBOutlet weak var txtFieldFromMonthYear: UITextField!
    @IBOutlet weak var txtFieldTilMonthYear: UITextField!
    @IBOutlet weak var lblSelectBuilding: UILabel!
    @IBOutlet weak var lblflatNo: UILabel!
    @IBOutlet weak var stackViewSelectflat: UIStackView!
    @IBOutlet weak var btnSelectBuilding: UIButton!
    @IBOutlet weak var btnSelectHead: UIButton!
    @IBOutlet weak var lblSelectHead: UILabel!
    @IBOutlet weak var btnSelectFlat: UIButton!
    @IBOutlet weak var objViewModel: CollectionStatusViewModel!
    @IBOutlet weak var tblViewcollectionStatusList: UITableView!
    @IBOutlet weak var collViewPaymentModeList: UICollectionView!
    @IBOutlet weak var viewPaymentHistory: UIView!
    

    //setting the number of cell at the top for the history of payments like Pending, Paid, and Payments
    let coloumnFlowLayout = ColumnFlowLayout(cellsPerRow: 3,
                                             heightforItem: 40,
                                             minimumInteritemSpacing: 5,
                                             minimumLineSpacing: 5,
                                             sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    
    //MARK:- Class Variables of the Controller-
    let dropDownSelectBuilding = DropDown()
    let dropDownHead = DropDown()
    let dropDownFlatNo = DropDown()
    let radioController: RadioButtonController = RadioButtonController()
    var requestPara = CollectionStatusModel()
    var tillDate = Date()
    var isBuilduingSelected = false
    var isflatNoSelected = false // to check all flatnumber selected or not false - not, ture- selected all
    var isHeadSelected = false
    var selectedIndex = 0
    var selectedFromMonthYear:Date?
    var selectedTillMonthYear:Date?
    
    //MARK:- view's life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collViewPaymentModeList?.collectionViewLayout = coloumnFlowLayout
        self.coloumnFlowLayout.scrollDirection = .horizontal
        self.applyShadowOnView(viewForBtns)
        self.setButtonState()
        self.setUpDropDown()
        self.setFlatNoDropDown()
        self.stackViewSelectflat.isHidden = true
        self.setUpHeadDropDown()
        self.hideAndShowPaymentHostory(flag: true)
    }
    
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionFlatWise(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.mode = "flat"
    }
    
    @IBAction func btnRevenueHeadWise(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        self.requestPara.mode = "head"
    }
    
    @IBAction func btnActionSelectBuildingAll(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            self.isBuilduingSelected = true
//            objViewModel.json_for_society_details(society_id:Constant.Soiaty_Id, building_id: "") { (success, message) in
//                if success {
//                    self.runOnMainThread {
//                        let builduing_ids = self.objViewModel.arrOfBuildings.map { $0.building_id ?? "" }
//                        self.requestPara.building_id = builduing_ids.joined(separator: ",")
//                    }
//                }else {
//                    self.ShowAlert(title: Alert, message: message)
//                }
//            }
//        }else {
//            self.isBuilduingSelected = false
//        }
    }
    
    @IBAction func btnActionSelectFlatAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.isflatNoSelected = true
            self.lblflatNo.text = "All flats"//Select Flat
            objViewModel.json_for_society_details1(society_id: Constant.Soiaty_Id, building_id: self.requestPara.building_id ?? "") { (success, message) in
                if success {
                    self.runOnMainThread {
                        let arrflatNo = self.objViewModel.arrOfFlatNo.map { $0.resident_flat_no ?? "" }
                        self.requestPara.flat_no = arrflatNo.joined(separator: ",")
                        let resident_id = self.objViewModel.arrOfFlatNo.map { $0.resident_id ?? "" }
                        self.requestPara.resident_id = resident_id.joined(separator: ",")
                    }
                } else {
                    self.ShowAlert(title: Alert, message: message)
                }
            }
        }else {
            self.lblflatNo.text = "Select Flat"
            self.isflatNoSelected = false
        }
    }
    
    @IBAction func btnActionSelectBuildingDropDown(_ sender: UIButton) {
        self.setUpDropDown()
        self.dropDownSelectBuilding.show()
    }
    @IBAction func btnActionSelectFlatDropDown(_ sender: UIButton) {
        if !self.isflatNoSelected{
        self.lblflatNo.text = "Select Flat"
        self.setFlatNoDropDown()
        self.dropDownFlatNo.show()
        }
    }
    @IBAction func btnActionSelectHeadDropDown(_ sender: UIButton) {
        self.setUpHeadDropDown()
        self.dropDownHead.show()
    }
    @IBAction func btnActionFromMonth(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = {
            date in
            self.selectedFromMonthYear = date
            if let selectedFromDate = self.selectedTillMonthYear{
                if (date.compare(.isEarlier(than:self.selectedTillMonthYear!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                    self.txtFieldFromMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                } else {
                    self.txtFieldFromMonthYear.text = ""
                    self.selectedFromMonthYear = nil
                    self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                }
            } else {
                self.txtFieldFromMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnActionTillMonth(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MonthYearViewController") as! MonthYearViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.onComplition = {
            date in
            self.selectedTillMonthYear = date
            if let selectedFromDate = self.selectedFromMonthYear{
                if (date.compare(.isLater(than:self.selectedFromMonthYear!))) && !date.compare(.isSameDay(as: selectedFromDate)){
                    self.txtFieldTilMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
                } else {
                    self.txtFieldTilMonthYear.text = ""
                    self.selectedTillMonthYear = nil
                    self.ShowAlert(title: "", message: "Till date cannot be before or equal to from date")
                }
            } else {
                self.txtFieldTilMonthYear.text = date.toString(format: .custom(Constant.dateFormate2))
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnActionShow(_ sender: UIButton) {
        self.doValidation()
    }
}
//MARK:- Custom functions of the Controller-
extension CollectionsStatusVC {
    func hideAndShowPaymentHostory(flag:Bool) {
        collViewPaymentModeList.isHidden = flag
        viewPaymentHistory.isHidden = flag
    }
    func doValidation(){
        if self.requestPara.mode == "head"{
            if self.txtFieldFromMonthYear.text!.isEmpty {
                self.ShowAlert(title: Alert, message: MessagesEnum.FromMonthAndYear.rawValue)
            } else if self.txtFieldTilMonthYear.text!.isEmpty {
                self.ShowAlert(title: Alert, message: MessagesEnum.TillMonthAndYear.rawValue)
            }else if !isHeadSelected {
                self.ShowAlert(title: Alert, message: MessagesEnum.SelectRevenueHead.rawValue)
            }else {
                self.callAPI_json_for_collection_status()
            }
        } else {
            if !isBuilduingSelected {
                self.ShowAlert(title: Alert, message: MessagesEnum.SelectBuilding.rawValue)
            } else if !isflatNoSelected {
                self.ShowAlert(title: Alert, message: MessagesEnum.SelectFlatNumber.rawValue)
            }  else if self.txtFieldFromMonthYear.text!.isEmpty {
                self.ShowAlert(title: Alert, message: MessagesEnum.FromMonthAndYear.rawValue)
            } else if self.txtFieldTilMonthYear.text!.isEmpty {
                self.ShowAlert(title: Alert, message: MessagesEnum.TillMonthAndYear.rawValue)
            } else {
                //to get payment history Like:- Pending, Paid, Payment
                self.callAPI_json_for_collection_status()
            }
        }
    }
    
    //to get payment history Like:- Pending, Paid, Payment
    func callAPI_json_for_collection_status(){
        self.objViewModel.json_for_collection_status(society_id: Constant.Soiaty_Id, building_id: self.requestPara.building_id ?? "", flat_no: self.requestPara.flat_no ?? "", resident_id: self.requestPara.resident_id ?? "", head_id: self.requestPara.head_id ?? "", mode: self.requestPara.mode , from_month_and_year: self.txtFieldFromMonthYear.text!, to_month_and_year: self.txtFieldTilMonthYear.text!) { (success, message) in
            if success {
                self.requestPara.selectedTab = .Pending
                self.objViewModel.arrOfAmount = self.objViewModel.arrOfpending_dues
                if self.objViewModel.arrOfpending_dues.count > 0 || self.objViewModel.arrOfPaidDues.count > 0 || self.objViewModel.arrOfpayment_recievedDues.count > 0{
                    self.hideAndShowPaymentHostory(flag: false)
                }else{
                    self.hideAndShowPaymentHostory(flag:true)
                    self.ShowAlert(title: Alert, message: "Data not found")
                }
                self.runOnMainThread {
                    self.tblViewcollectionStatusList.reloadData()
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func setButtonState(){
        radioController.buttonsArray = [btnFlatWise,btnRevenueHeadWise]
        radioController.defaultButton = btnFlatWise
    }
}

//MARK:- Set for the DropDown and Calendar-
extension CollectionsStatusVC{
    
    func didTapOnFromMonth() {
        self.objViewModel.openDatePickerFrom(strTimeAndDate: "date") { (date) in
            self.txtFieldFromMonthYear.text = date
            self.requestPara.from_month_and_year = date
            let dateFormatter = DateFormatter()
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.tillDate = dateFormatter.date(from:date) ?? Date()
            
        }
    }
    func didTapOnTillMonth() {
        self.objViewModel.openDatePickertill(fromDate: self.tillDate) { (date) in
            self.txtFieldTilMonthYear.text = date
            self.requestPara.to_month_and_year = date
        }
    }
    func setUpDropDown()  {
        var arrSelectBuildingDropDown = Array<DropDownDataModel>()
        objViewModel.json_for_society_details(society_id:Constant.Soiaty_Id, building_id: "") { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfBuildings.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.building_name ?? ""
                        arrSelectBuildingDropDown.append(dataModel) //appending Value in dropDown
                    }
                    self.dropDownSelectBuilding.dataSource = arrSelectBuildingDropDown
                    self.setupDropDown(dropDown: self.dropDownSelectBuilding)
                }
            }else {
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
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectBuilding.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Buildings
            self.requestPara.building_id = dict.building_id ?? ""
            self.lblSelectBuilding.text = item.item ?? "" //Value assigned Place.
            self.lblSelectBuilding.textColor = .black
            self.stackViewSelectflat.isHidden = false
            self.isBuilduingSelected = true
            self.lblflatNo.text = "Select Flat"
            self.setFlatNoDropDown()
        }
    }
    func setFlatNoDropDown(){
        var arrOfSelectFlatNoDropDown = Array<DropDownDataModel>()
        objViewModel.json_for_society_details1(society_id:Constant.Soiaty_Id, building_id: self.requestPara.building_id ?? "") { (success, message) in
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
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: btnSelectFlat.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            let dict = item.dataObject as! Resident_data
            self.requestPara.resident_id = dict.resident_id ?? ""
            // self.resident_id = dict.resident_id ?? ""
            self.lblflatNo.text = item.item ?? "" //Value assigned Place.
            self.requestPara.flat_no = item.item ?? ""
            self.lblflatNo.textColor = .black
            self.isflatNoSelected = true
        }
    }
    
    func setUpHeadDropDown(){
        var arrOfTargetRevenueDropDown = Array<DropDownDataModel>()
        objViewModel.Fetch_all_head(society_id:Constant.Soiaty_Id) { (success, message) in
            if success {
                self.runOnMainThread {
                    self.objViewModel.arrOfRevenue_head.forEach { (obj) in
                        let dataModel = DropDownDataModel()
                        dataModel.dataObject = obj as AnyObject
                        dataModel.item = obj.head_name ?? ""
                        arrOfTargetRevenueDropDown.append(dataModel) //appending Value in dropDown
                    }
                    self.dropDownHead.dataSource = arrOfTargetRevenueDropDown
                    self.dropDown(dropDown: self.dropDownHead)
                }
            } else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
    func dropDown( dropDown:DropDown){
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
            let dict = item.dataObject as! Revenue_head
            self.requestPara.head_id = dict.head_id ?? ""
            self.lblSelectHead.text = item.item ?? "" //Value assigned Place.
            self.lblSelectBuilding.textColor = .black
            self.isHeadSelected = true
        }
    }
}

//MARK:- API Callig here
extension CollectionsStatusVC{
    func validate() ->Bool {
        return true
    }
}

//MARK:- UITableViewDelegate,UITableViewDataSource-
extension CollectionsStatusVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   self.objViewModel.arrOfAmount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmountPendingListCell", for: indexPath) as! AmountPendingListCell
        cell.objAccount = self.objViewModel.arrOfAmount[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func checkBox(indexPath:IndexPath)  {
        self.objViewModel.arrOfAmount[indexPath.row].isSelected.toggle()
        DispatchQueue.main.async {
            self.tblViewcollectionStatusList.reloadData()
        }
    }
}

//MARK:-UICollectionViewDelegate,UICollectionViewDataSource-
extension CollectionsStatusVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.requestPara.headingData()).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collViewPaymentModeList.dequeueReusableCell(withReuseIdentifier: "CollectionStausCollViewCell", for: indexPath) as! CollectionStausCollViewCell
        let obj = self.requestPara.headingData()
        cell.lblModeName.text = obj[indexPath.row]
        cell.lblUnder.isHidden = !(selectedIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let obj = self.requestPara.headingData()
        self.objViewModel.arrOfAmount.removeAll()
        
        if obj[indexPath.row] == CollectionStatusHistory.Payment.rawValue{
            self.objViewModel.arrOfAmount = self.objViewModel.arrOfpayment_recievedDues
        }else if  obj[indexPath.row] == CollectionStatusHistory.Paid.rawValue{
            self.objViewModel.arrOfAmount = self.objViewModel.arrOfPaidDues
        }else if  obj[indexPath.row] == CollectionStatusHistory.Pending.rawValue{
            self.objViewModel.arrOfAmount = self.objViewModel.arrOfpending_dues
        }
        
        DispatchQueue.main.async {
            self.tblViewcollectionStatusList.reloadData()
            self.collViewPaymentModeList.reloadData()
        }
    }
}
