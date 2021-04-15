//
//  Extension.swift
//  MaterialSound
//
//  Created by 董静 on 4/7/21.
//  Copyright © 2021 Doyoung Gwak. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var width : CGFloat {
        return frame.size.width
    }
    var height : CGFloat {
        return frame.size.height
    }
    var left : CGFloat {
    return frame.origin.x
    }
    
    var right : CGFloat {
        return frame.size.width + frame.origin.x
    }
    
    var top : CGFloat {
        return frame.origin.y
    }
    
    var bottom : CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    
}

