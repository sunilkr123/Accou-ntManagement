//
//  ViewController.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 04/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class FundTransferViewController: UIViewController {
    
    //MARK:- IBoutlets's of the Controller-
    @IBOutlet weak var tblViewList: UITableView!
    @IBOutlet weak var objViewModel: AccountingViewModel!
    
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objViewModel.setStaticData()
        self.setNavigationTitleFont(con: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
//MARK:- UITableViewDataSource,UITableViewDelegate -
extension FundTransferViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objViewModel.arrayOfAccType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingTableViewCell", for: indexPath)  as! AccountingTableViewCell
        self.applyShadowOnView(cell.cellView)
        cell.typeModel = objViewModel.arrayOfAccType[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {//HeadManagementViewController
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: HeadManagementViewController.identifier) as! HeadManagementViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {//FundTransferVC
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: FundTransferVC.idientifier) as! FundTransferVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {//PaymentsViewController
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3 {//ResidentCollectionVC
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ResidentCollectionVC") as! ResidentCollectionVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4 {//ThirdPartyCollectionVC
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ThirdPartyCollectionVC") as! ThirdPartyCollectionVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5 {//CollectionsStatusVC
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CollectionsStatusVC") as! CollectionsStatusVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {//AccountingViewController
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AccountingViewController") as! AccountingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
