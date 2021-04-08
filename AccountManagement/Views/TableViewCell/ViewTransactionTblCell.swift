//
//  ViewTransactionTblCell.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 06/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class ViewTransactionTblCell: UITableViewCell {

    //MARK:- IBOutlet's of the Controller-
    @IBOutlet weak var lblSlNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeadDetails: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblData2Mode: UILabel!
    @IBOutlet weak var lblGSt: UILabel!
    
    var obj:TransactionModel?{
        didSet{
            lblGSt.text = obj?.gst ?? ""
            lblDate.text = obj?.transfer_date_time ?? ""
            lblAmount.text = obj?.amount ?? ""
            lblHeadDetails.text = obj?.head_name ?? ""
            lblData2Mode.text = obj?.transaction_done_by ?? ""
        }
    }
    
    var objForParty:TransactionModel?{
        didSet{
            lblDate.text = objForParty?.transfer_date_time ?? ""
            lblAmount.text = objForParty?.amount ?? ""
            lblHeadDetails.text = objForParty?.head_name ?? ""

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
