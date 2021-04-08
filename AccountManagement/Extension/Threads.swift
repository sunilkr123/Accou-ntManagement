//
//  Threads.swift
//  Vybe
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import Foundation
protocol Threads {
    func runOnMainThread(_ closure: @escaping () -> Void)
    func delay(_ delay: Double, closure: @escaping () -> Void)
}

extension Threads {
    func runOnMainThread(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
