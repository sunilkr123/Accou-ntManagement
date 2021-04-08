//
//  AmountPendingListCell.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import UIKit

class AmountPendingListCell: UITableViewCell {

    @IBOutlet weak var btnCheck:UIButton!
    @IBOutlet weak var lblHeadName:UILabel!
    @IBOutlet weak var leadingOfTitle: NSLayoutConstraint!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    var isPayment = false
    var tapToSelect:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var objAccount:AccountList?{
        didSet{
            if objAccount?.applied_date != "" && objAccount?.applied_date != nil{
                lblDate.text = objAccount?.applied_date ?? ""
            }
            if objAccount?.date_time != "" && objAccount?.date_time != nil{
                lblDate.text =  objAccount?.date_time ?? ""
            }
            lblAmount.text = objAccount?.amount ?? ""
            if isPayment{
                if  objAccount?.transaction_type != nil && objAccount?.transaction_type  != ""{
                    lblHeadName.text = objAccount?.transaction_type
                }else{
                    lblHeadName.text =  objAccount?.head_name ?? ""
                }
                
            }else{
               lblHeadName.text = objAccount?.head_name ?? ""
            }
            
        }
    }
    
    func tapToSelect(tapToSelect:@escaping ()->Void)  {
        self.tapToSelect = tapToSelect
    }
    
    @IBAction func btnTapToSelect(_ sender :UIButton){
        self.tapToSelect?()
    }
}
