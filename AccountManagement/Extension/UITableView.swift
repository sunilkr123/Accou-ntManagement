//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation
import UIKit
class ClosureSleeve {
    let closure: ()->()
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    @objc func invoke () {
        closure()
    }
}
extension UICollectionView {
    func enableRefreshControl(_ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        let refreshControl = UIRefreshControl()
        refreshControl.tag = 5555
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }

        // Configure Refresh Control
        refreshControl.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .valueChanged)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    func stopRefreshControl() {
        // Add to Table View
        if #available(iOS 10.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl?.endRefreshing()
            }//  self.refreshControl?.endRefreshing()
        } else {
            let objref = self.viewWithTag(5555) as! UIRefreshControl
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                objref.endRefreshing()
            }
            //  objref.endRefreshing()
        }
    }
}
extension UITableView {
    func enableRefreshControl(_ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor =   UIColor.init(red: 172.0/255.0, green: 96.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        refreshControl.tag = 5555
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .valueChanged)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func numberOfRowsFromArray(dataArray:[Any],withMessage:String,imageName:String,xibName:String,subTitle:String,bgColor:UIColor)-> NSInteger {
        
        let tempArray = NSMutableArray.init(array: dataArray)
        if tempArray.count <= 0 {
            self.backgroundView = self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
            self.backgroundView?.backgroundColor = .clear
            self.separatorStyle = .none
            return 0;
        } else{
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

            if isConnected == true {
                //show empty message
                self.backgroundView = UIView()//self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
                self.backgroundView?.addSubview(self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle,frameY: frameY))

                self.backgroundView?.backgroundColor  = UIColor.black
            } else {
                //show offlie messsage when no network
                self.backgroundView = UIView()//self.setupBackgroudViewWithNibName(name: withMessage, imageName: imageName, xibName: xibName,subTitle:subTitle)
                self.backgroundView?.addSubview(self.setupBackgroudViewWithNibName(name: "Network is not connected", imageName: "Norecordfound", xibName: "EmptyData",subTitle:"Please check your network and try again!",frameY: frameY))
                self.backgroundView?.backgroundColor  = UIColor.black
            }
            self.separatorStyle = .none
            return 0
        } else {
            self.backgroundView = nil
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

    func stopRefreshControl() {
        if #available(iOS 10.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl?.endRefreshing()
            }
        } else {
            let objref = self.viewWithTag(5555) as? UIRefreshControl
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                objref?.endRefreshing()
            }
        }
    }
}
