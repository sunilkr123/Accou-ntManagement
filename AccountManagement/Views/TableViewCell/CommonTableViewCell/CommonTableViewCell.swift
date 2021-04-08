//
//  CommonTableViewCell.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 05/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
    
    //MARK:-
    @IBOutlet weak var lblNameOfHead: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataOnExpense_headCell(expense_Head:Expense_head){
        lblNameOfHead.text = expense_Head.head_name ?? ""
        lblType.text = expense_Head.type_head ?? ""
        lblAmount.text = expense_Head.available_amount ?? ""
    }
    func setDataOnRevenue_headCell(revenue_Head:Revenue_head){
        lblNameOfHead.text = revenue_Head.head_name ?? ""
        lblType.text = revenue_Head.type_head ?? ""
        lblAmount.text = revenue_Head.available_amount ?? ""
    }
    
}
