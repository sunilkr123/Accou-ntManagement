//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation

extension TimeZone {
    
    static var currentLocalizedName: String {
        let current = TimeZone.current
        return current.localizedName(for: .standard, locale: .current) ?? "India Standard Time"
        //"Eastern Standard Time"
    }
    
}
