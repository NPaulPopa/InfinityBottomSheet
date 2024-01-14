//
//  InfinityBottomSheetDataSource.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//

import UIKit

///Data source
public protocol InfinityBottomSheetCoordinatorDataSource: AnyObject {
    ///Gesture end animation
    var animator: Animatable? { get }
    ///Sheet positions. For example top, middle, bottom y values.
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat]
    ///Initial sheet y position.
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat
    /**
     Top rubber band logic over top limit, min sheet height.
     - parameter total: total distance from the top limit
     - parameter limit: top limit or min sheet height
    */
    func rubberBandLogicTop(_ total: CGFloat, _ limit: CGFloat) -> CGFloat
    /**
     Bottom rubber band logic below bottom limit, max sheet height.
     
      - parameter total: total distance from the bottom limit
      - parameter limit: bottom limit or max sheet height
     */
    func rubberBandLogicBottom(_ total: CGFloat, _ limit: CGFloat) -> CGFloat
}
