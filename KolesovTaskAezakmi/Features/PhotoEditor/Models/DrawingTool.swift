//
//  DrawingTool.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import PencilKit

struct DrawingTool: Hashable {
    let inkType: PKInkingTool.InkType
    let color: UIColor
    let width: CGFloat
    
    var pkTool: PKInkingTool {
        PKInkingTool(inkType, color: color, width: width)
    }
}
