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
    
    //MARK: Configure BottomSheet
    
    private func configureBottomSheet() {
        
        guard bottomSheetController == nil else { return }
                
        self.bottomSheetController = BottomSheetController(
            parent: parentViewController, dataSource: bottomSheetDataSource)
        
        self.bottomSheetController.setCornerRadius(cornerRadius)
        
        self.contentViewController.bottomSheetController = bottomSheetController
        
        self.bottomSheetController.delegate = self
    }
    
    //MARK: Add BottomSheet
    
    private func addBottomSheet() {
        
        contentViewController.bottomSheetController = bottomSheetController
        
        contentViewController.bottomSheetManager = self
        
        bottomSheetController.addBottomSheet(contentViewController,
            to: parentViewController, animated: true, didCreateContainerView: {
                    
                container in

                self.addBackgroundDimmingView(under: container)
                
            }, completion: nil)
    }
    
    private func addBottomSheetInNavigation() {
        
        guard let navigationController = navigationController else { return }
        
        bottomSheetController.usesNavigationController = true
        
        contentViewController.bottomSheetController = bottomSheetController
        
        contentViewController.bottomSheetManager = self
        
        bottomSheetController.addBottomSheet(navigationController, to: parentViewController, animated: true, didCreateContainerView: { container in
            
            self.addBackgroundDimmingView(under: container)

        }, completion: nil)
    }
  
    
    //MARK: Remove BottomSheet

    private func removeBottomSheet() {
        
        self.bottomSheetController.removeBottomSheet(nil, completion: nil)

        self.removeBackgroundDimmingView()
    }
}

//MARK: BottomSheet BackgroundView

extension BottomSheetManager {
    
    private func addBackgroundDimmingView(under container: UIView) {
        
        guard bgView == nil else { return }
        
        bgView = UIView()
        
        guard let bgView = bgView else { return }
        
        bgView.backgroundColor = .label.withAlphaComponent(0.3)
        parentViewController.view.insertSubview(bgView, belowSubview: container)

        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        pin(subview: bgView, toParent: parentViewController.view)
        
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
            
            self.tabBarIsHidden(true)
        }
        propertyAnimator.startAnimation()
    }
   
    
    private func removeBackgroundDimmingView() {
        
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            
            self.tabBarIsHidden(false)
            self.bgView?.alpha = 0
        }
        propertyAnimator.addCompletion { _ in

            self.bgView?.removeFromSuperview()
            self.bgView = nil
        }
        propertyAnimator.startAnimation()
    }
 
