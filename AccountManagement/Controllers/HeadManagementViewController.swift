//
//  HeadManagementViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 04/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class HeadManagementViewController: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var viewForExpensesHead: UIView!
    @IBOutlet weak var viewForRevenueHead: UIView!
    @IBOutlet weak var tblViewExpensesHead: UITableView!
    @IBOutlet weak var tblViewRevenueHead: UITableView!
    @IBOutlet weak var objViewModel: Fetch_all_head_ViewModel!
      //MARK:- Class Variable here -
    static let identifier = "HeadManagementViewController"
    
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyShadowOnView(viewForExpensesHead)
        self.applyShadowOnView(viewForRevenueHead)
        self.registerTableViewCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch_all_head()
    }
    
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionAdd(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "HeadCreationViewController") as! HeadCreationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Custom function's of the Controller-
extension HeadManagementViewController {
    func registerTableViewCell(){
        self.tblViewExpensesHead.register(UINib(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonTableViewCell")
        self.tblViewRevenueHead.register(UINib(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonTableViewCell")
    }
    func fetch_all_head(){
        self.objViewModel.Fetch_all_head(society_id: Constant.Soiaty_Id) { (success,message) in
          if success {
                self.runOnMainThread {
                    self.tblViewExpensesHead.reloadData()
                    self.tblViewRevenueHead.reloadData()
                }
            }else {
                self.ShowAlert(title: Alert, message: message)
            }
        }
    }
}
//MARK:- UITableViewDelegate,UITableViewDataSource-
extension HeadManagementViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblViewExpensesHead ? objViewModel.arrOfExpense_head.count : objViewModel.arrOfRevenue_head.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblViewExpensesHead {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! CommonTableViewCell
            tableView.separatorInset = .zero
            tableView.layoutMargins = .zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            cell.setDataOnExpense_headCell(expense_Head: objViewModel.arrOfExpense_head[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! CommonTableViewCell
            tableView.separatorInset = .zero
            tableView.layoutMargins = .zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            cell.setDataOnRevenue_headCell(revenue_Head: objViewModel.arrOfRevenue_head[indexPath.row])
            return cell
        }
    }
    //redirecting to the pop up to edit or remove the heads either for expense or revenue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var headType = 0
        var headId = ""
        var head:HeadData = HeadData()
        if tableView == self.tblViewRevenueHead{
            headType = 2
            headId = self.objViewModel.arrOfRevenue_head[indexPath.row].head_id ?? ""
            head.revenue = self.objViewModel.arrOfRevenue_head[indexPath.row]
        }else if tableView == self.tblViewExpensesHead{
            headType = 1
            head.expense = self.objViewModel.arrOfExpense_head[indexPath.row]
            headId = self.objViewModel.arrOfExpense_head[indexPath.row].head_id ?? ""
        }
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ActionPopUpVC") as! ActionPopUpVC
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.headType = headType
        popOverVC.headId = headId
        popOverVC.heads = head
        popOverVC.complitionHandlerPops = { pust in
            self.fetch_all_head()
        }
        self.navigationController?.present(popOverVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == self.tblViewExpensesHead ? 60.0 : 60.0
    }
}
