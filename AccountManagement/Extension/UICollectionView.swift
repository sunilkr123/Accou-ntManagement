//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import Foundation
import UIKit
extension UICollectionView {
    
    func numberOfItemsFromArray(dataArray:[Any],withMessage:String,imageName:String,xibName:String,subTitle:String,bgColor:UIColor)-> NSInteger {
        
        let tempArray = NSMutableArray.init(array: dataArray)
        if tempArray.count <= 0 {
            self.backgroundView = self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
            self.backgroundView?.backgroundColor = bgColor
            return 0;
        }else{
            self.backgroundView=nil
        }
        return tempArray.count
    }
    
    func setupBackgroudViewWithNibName(name:String,imageName:String,xibName:String,subTitle:String)-> UIView{
        
        let customView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?[0] as! UIView
        if imageName.trim().count > 0 {
            (customView.viewWithTag(1001) as! UIImageView).image = UIImage.init(named: imageName)
        }
        if name.trim().count > 0 {
            (customView.viewWithTag(1002) as! UILabel).text = name
        }
        if subTitle.trim().count > 0 {
            (customView.viewWithTag(1003) as! UILabel).text = subTitle
        }else{
            (customView.viewWithTag(1003) as! UILabel).text = ""
        }
        return customView
    }

    func numberOfRowsFromArrayWithFrameSize(dataArray:[Any],withMessage:String,imageName:String,xibName:String,subTitle:String,frameY:CGFloat)-> NSInteger {

    let tempArray = NSMutableArray.init(array: dataArray)
    if tempArray.count <= 0 {

    let status = Reach().connectionStatus()
    var isConnected = true
    switch status {
    case .unknown, .offline:
    print("Not connected")
    isConnected = false
    break
    default:
    isConnected = true
    break
    }

    if  isConnected == true {
    //show empty message
    self.backgroundView = UIView()//self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
    self.backgroundView?.addSubview(self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle,frameY: frameY))

    self.backgroundView?.backgroundColor  = UIColor.black
    } else{
    //show offlie messsage when no network
    self.backgroundView = UIView()//self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
    self.backgroundView?.addSubview(self.setupBackgroudViewWithNibName(name: "Network is not connected", imageName: "Norecordfound", xibName: "EmptyNewsFeed",subTitle:"Please check your network and try again!",frameY: frameY))
    self.backgroundView?.backgroundColor  = UIColor.black
    }
    // self.separatorStyle = .none
    return 0;
    }else{
    self.backgroundView=nil

    // self.backgroundColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    }
    return tempArray.count
    }

    func setupBackgroudViewWithNibName(name:String,imageName:String,xibName:String,subTitle:String,frameY:CGFloat)-> UIView{

    let customView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?[0] as! UIView
    if imageName.trim().count > 0 {
    (customView.viewWithTag(1001) as! UIImageView).image = UIImage.init(named: imageName)
    }
    if name.trim().count > 0 {
    (customView.viewWithTag(1002) as! UILabel).text = name
    }
    if subTitle.trim().count > 0 {
    (customView.viewWithTag(1003) as! UILabel).text = subTitle
    }
    if frameY > 0.0 {
    customView.frame = CGRect.init(x: (UIScreen.main.bounds.size.width/2) -  (248/2), y: frameY, width: 248, height: 217)

    }else{
    customView.frame = CGRect.init(x: 0, y: 0, width: 248, height: 217)
    customView.center = self.center
    }
    return customView
    }


}

