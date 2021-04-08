//
//  FundTransferCommonTblViewCell.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import UIKit

class FundTransferCommonTblViewCell: UITableViewCell {

    //MARK:- IBOutlet's of the Controlller-
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnCheckMark: UIButton!
    
    var didTaponCheckBox: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataOnExpense_headCell(expense_Head:Expense_head){
        lblName.text = expense_Head.head_name ?? ""
        lblAmount.text = "₹ \(expense_Head.available_amount ?? "")"
//        if expense_Head.isSelected{
//            btnCheckMark.setImage(UIImage(named:"checked_box"), for: .normal)
//        }else{
//            btnCheckMark.setImage(UIImage(named:"check_box"), for: .normal )
//        }
    }
    func setDataOnRevenue_headCell(revenue_Head:Revenue_head){
        lblName.text = revenue_Head.head_name ?? ""
        lblAmount.text = "₹ \(revenue_Head.available_amount ?? "")"
//        if revenue_Head.isSelected{
//             btnCheckMark.setImage(UIImage(named:"checked_box"), for: .normal)
//        }else{
//            btnCheckMark.setImage(UIImage(named:"check_box"), for: .normal )
//        }
    }
    
    func onTappingCheckMark(didTaponCheckBox: @escaping () -> Void) {
        self.didTaponCheckBox = didTaponCheckBox
    }
    
    @IBAction func btnActionCheckMark(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        didTaponCheckBox?()
    }
}



