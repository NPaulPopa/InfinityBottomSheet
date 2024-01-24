//
//  BottomSheetManagerProtocol.swift
//  FeedPageVersionTwo
//
//  Created by Paul on 25/01/2023.
//

import UIKit

public protocol BottomSheetManagerProtocol: AnyObject {
    
    var dragToDismiss: Bool { get set}
    var cornerRadius: CGFloat { get set}
