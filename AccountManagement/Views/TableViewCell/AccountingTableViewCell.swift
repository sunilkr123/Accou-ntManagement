//
//  AccountingTableViewCell.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 04/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class AccountingTableViewCell: UITableViewCell {

    //MARK:- IBOutlet's of the Controller
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var typeModel:AccountTypeModel! {
        didSet {
            lblAccountType.text = typeModel.name ?? ""
        }
    }
}
