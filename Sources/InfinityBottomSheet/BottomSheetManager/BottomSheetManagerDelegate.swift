//
//  BottomSheetManagerDelegate.swift
//  FeedPageVersionTwo
//
//  Created by Paul Pop on 04/02/2023.
//

import UIKit

public protocol BottomSheetManagerDelegate: AnyObject {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState)
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState)
    func bottomSheet(_ container: UIView?, didDismiss state: SheetTranslationState)
}

public extension BottomSheetManagerDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {}
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {}
    func bottomSheet(_ container: UIView?, didDismiss state: SheetTranslationState) {}
}
