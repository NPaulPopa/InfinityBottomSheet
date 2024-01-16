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


public typealias DraggableItem = Draggable & UIViewController

///UIViewControllers must conform this to make use of InfinityBottomSheet gesture handling
public protocol Draggable {
    var bottomSheetController: BottomSheetProtocol? { get set }
    var bottomSheetManager: BottomSheetManagerProtocol?  { get set }
    func draggableView() -> UIScrollView?
}

///draggableView sets to nil by default. Set any scroll view to track.
public extension Draggable {
    func draggableView() -> UIScrollView? {
        return nil
    }
}
