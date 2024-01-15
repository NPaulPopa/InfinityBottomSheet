//
//  InfinityBottomSheetDelegate.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//


import UIKit

///Sheet delegate
public protocol InfinityBottomSheetCoordinatorDelegate: AnyObject {
    func bottomSheet(_ container: UIView?, finishTranslationWith animation: @escaping ((_ percent: CGFloat) -> Void) -> Void)
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState)
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState)
    
    func bottomSheet(hasBeganWithVelocity velocity: CGPoint)
    func bottomSheet(didChangePanWithVelocity velocity: CGPoint)

}

///Default empty implementations
extension InfinityBottomSheetCoordinatorDelegate {
    public func bottomSheet(_ container: UIView?, finishTranslationWith extraAnimation: @escaping ((_ percent: CGFloat) -> Void) -> Void) { }
    public func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) { }
    public func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) { }
    
    public func bottomSheet(didChangePanWithVelocity velocity: CGPoint) {}
    
    public func bottomSheet(hasBeganWithVelocity velocity: CGPoint) {}
}

public protocol BottomSheetDelegate: InfinityBottomSheetCoordinatorDelegate {
    
}
