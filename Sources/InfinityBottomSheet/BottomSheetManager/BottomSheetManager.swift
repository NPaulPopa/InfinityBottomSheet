//
//  BottomSheetManager.swift
//  FeedPageVersionTwo
//
//  Created by Paul on 25/01/2023.
//

import UIKit

public class BottomSheetManager: BottomSheetManagerProtocol {
    
    //MARK: - Public Properties
    
    weak var delegate: BottomSheetManagerDelegate?

    public var cornerRadius: CGFloat = 20
    
    public var smallDetents: CGFloat = 0.6
    
    public var mediumDetents: CGFloat = 0.30//0.37
    
    public var largeDetents: CGFloat = 0
    
    public var dragToDismiss: Bool = true
    
  
