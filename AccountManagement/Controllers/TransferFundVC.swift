//
//  TransferFundVC.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 13/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class TransferFundVC: UIViewController {
    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK:- Class variable -
    static let identifier = "TransferFundVC"
    var complitionHandlerPops:((Bool,String)->())?
    var obj:TransferDataModel?
    var isFrom = false
    var isForMonthly = false
    var isImposeOrPaid :Bool? // false - impose, true - already paid, nil - monthly
    //MARK:- Views Life cytcle -
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFrom {
//            if self.isImposeOrPaid != nil{
//                if self.isImposeOrPaid!{
                    lblHead.text = "Impose"
//                } else {
//                    lblHead.text = "Already Paid"
//                }
//            }else{
//                lblHead.text = "Action"
//            }
            
            lblMessage.text = "Are you sure want to proceed with this Action ?"
        } else {
            lblHead.text = "Action"
            lblMessage.text = "Are you sure want to proceed with this transaction ?"
        }
    }
    //MARK:- IBAction's of the Controller-
    @IBAction func btnActionCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    @IBAction func btnActionNoo(_ sender: Any) {
        self.dismiss(animated: false)
    }
    @IBAction func btnActionYess(_ sender: UIButton) {
        if isFrom {
            if isForMonthly {
                self.dismiss(animated: true) {
                    self.complitionHandlerPops?(true,"")
                }
            } else {
                self.dismiss(animated: true) {
                    self.complitionHandlerPops?(true,"")
                }
            }
        }else {
            self.transferAmount()
        }
    }
}
//MARK:- APi calling
extension TransferFundVC{
    //api calling to update head either expense or revenue
    func transferAmount(){
        AuthenticationInterface.shared.postApiCalling(para:(obj?.toJosn())!, endPoint:APIEndPoints.transfer_amount) { (response, success, msg) in
            if success {
                self.dismiss(animated: true) {
                    self.complitionHandlerPops!(success,msg ?? "")//complitionHandlerPops
                }
            }else{
                self.ShowAlert(title: Alert, message: msg ?? "")
            }
        }
    }
}
