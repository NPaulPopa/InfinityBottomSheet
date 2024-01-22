//
//  InfinityBottomSheetCoordinator.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//

import UIKit

public class BottomSheetController: InfinityBottomSheetCoordinator {
    
    override public init(parent: UIViewController, dataSource: InfinityBottomSheetCoordinatorDataSource, delegate: BottomSheetDelegate? = nil) {
        
        super.init(parent: parent, dataSource: dataSource, delegate: delegate)
    }
}

public enum SheetTranslationState {
    case progressing(_ minYPosition: CGFloat, _ percent: CGFloat) //currently updating
    case willFinish(_ minYPosition: CGFloat, _ percent: CGFloat) //animation start
    case finished(_ minYPosition: CGFloat, _ percent: CGFloat) //animation end
}

public protocol BottomSheetProtocol: AnyObject {
    var dataSource: InfinityBottomSheetCoordinatorDataSource! { get set }
    
    func addBottomSheet(_ item: UIViewController,
                        to parent: UIViewController,
                        animated: Bool ,
                        didCreateContainerView: ((UIView) -> Void)?,
                        completion: (() -> Void)?)

    
    func removeBottomSheet(_ block: ((_ container: UIView?) -> Void)?, completion: ((Bool) -> Void)?)
    
    func removeDropShadow()
    
    func setCornerRadius(_ radius: CGFloat)
    
    func addShadow(customShadow: ((UIView) -> Void)?)
    
    func setToNearest(_ position: CGFloat, animated: Bool)
        
    func startTracking<T: DraggableItem>(item: T)
    
    var usesNavigationController: Bool { get set }
    
    func addSheetChild(_ item: DraggableItem, completion:  ((Bool) -> Void)?)

    var delegate: BottomSheetDelegate? { get set }
}
