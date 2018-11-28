//
//  CustomRenderer.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/27/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class CustomRenderer: UIPrintPageRenderer {

    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        
        let headerInsets = UIEdgeInsets(top: headerRect.minY, left: 100, bottom: paperRect.maxY - headerRect.maxY, right: 100)
        let headerRect = UIEdgeInsetsInsetRect(paperRect, headerInsets)
        let authorName = "محضر إجتماع مجلس الإدارة الثاني لعام ٢٠١٧"
        
        let rect = headerRect.offsetBy(dx: 120, dy: 20.0)
        
        
        let font = UIFont(name: "System", size: 22.0)
        
        // author name on left
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]

        authorName.draw(in: rect, withAttributes: underlineAttribute)
    }
}
