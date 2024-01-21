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
