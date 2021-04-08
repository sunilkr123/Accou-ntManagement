//
//  ActionPopUpVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

struct HeadData {
    var expense:Expense_head?
    var revenue:Revenue_head?
    init() {
    }
}

class ActionPopUpVC: UIViewController {
    
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Class Variable here -
    var complitionHandlerPops:((Bool)->())?
    var headType = 0 //1 - expense, 2 - revenue
    var headId = ""
    var heads:HeadData?
    
    //MARK:- Views Life cycle of the Controller-
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- IBAction of The Controller-
    @IBAction func btnActionCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    @IBAction func btnActionEdit(_ sender: Any) {
        self.edit()
    }
    @IBAction func btnActionRemove(_ sender: UIButton) {
        self.remove()
    }
}

//MARK:- Custom function here
extension ActionPopUpVC {
    func edit(){
        let popUpOver = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: EditHeadVC.identifier) as! EditHeadVC
        popUpOver.modalPresentationStyle = .overCurrentContext
        popUpOver.heads = self.heads
        popUpOver.headType = headType
        popUpOver.complitionHandlerPops = {
            success in
            self.complitionHandlerPops?(true)
            self.dismiss(animated: true, completion: nil)
        }
        self.present(popUpOver, animated: true, completion: nil)
    }
    
    func remove(){
        let popOverVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RemoveExpenseRevenueHeadVC.identifier) as! RemoveExpenseRevenueHeadVC
        popOverVC.headType = self.headType
        popOverVC.oldHeadId = self.headId
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.complitionHandlerPops = { pust in
            print("Cancel--==--=-=-=-=-=-=-=-=-=")
            self.complitionHandlerPops?(true)
            self.dismiss(animated: true, completion: nil)
        }
        self.present(popOverVC, animated: true, completion: nil)
    }
}
