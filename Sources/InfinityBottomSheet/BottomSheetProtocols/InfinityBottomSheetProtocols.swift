//
//  InfinityBottomSheetProtocols.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//

import UIKit

/**
 Conform this protocol to creat ecustom finish animation on pan gesture ended.
 */
public protocol Animatable {
    func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}
