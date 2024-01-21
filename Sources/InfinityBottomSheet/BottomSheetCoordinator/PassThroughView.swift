//
//  PassThroughView.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//

import UIKit

class PassThroughView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        
        return view == self ? nil : view
    }
}
