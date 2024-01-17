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
    
    public func setToPosition(_ position: CGFloat, animated: Bool) {
        
        bottomSheetController.setToNearest(position, animated: animated)
    }
    
    private var dismissDetents: CGFloat? {
        dragToDismiss ? 1.1 : nil
    }
    
    ///Takes vlues between 0 and 1 and If not implemeted it returns the height set for smallDetents
    public lazy var initialHeight: CGFloat = mediumDetents
    
    /// Set a new object who will implement the custom detents. If you only need to set custom detents then utilise detents properties
    public lazy var bottomSheetDataSource: InfinityBottomSheetCoordinatorDataSource = self
    
    //MARK: - Public Methods

    public func showBottomSheet() {
        
        guard dismissInProgress == false else { return}
        configureBottomSheet()
        addBottomSheet()
    }
    
    public func addSheetChild(child: DraggableItem) {
        bottomSheetController.addSheetChild(child, completion: nil)
    }
    
    public func showBottomSheetInNavigation() {
        guard dismissInProgress == false else { return}
        configureBottomSheet()
        addBottomSheetInNavigation()
    }
    
    public func dismissBottomSheet() {
        removeBottomSheet()
    }
        
    //MARK: - Private Properties
    
    private let parentViewController:  UIViewController
    private var contentViewController: DraggableItem
    private var bottomSheetController: BottomSheetProtocol!
    private var navigationController: UINavigationController?

    
    private var bgView: UIView?
    private var dismissInProgress: Bool = false
    
    //MARK: - Lifecycle
    
    public init(parentViewController: UIViewController,contentViewController: DraggableItem,navigationController: UINavigationController? = nil){
        self.parentViewController = parentViewController
        self.contentViewController = contentViewController
        self.navigationController = navigationController
    }
   
