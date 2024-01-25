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

public class InfinityBottomSheetCoordinator: NSObject, BottomSheetProtocol {
    public weak var parent: UIViewController!
    private var container: UIView?
    
    public weak var dataSource: InfinityBottomSheetCoordinatorDataSource! {
        didSet {
            minSheetPosition = dataSource.sheetPositions(availableHeight).min()
            maxSheetPosition = dataSource.sheetPositions(availableHeight).max()
        }
    }
    
    public weak var delegate: BottomSheetDelegate?
    private var minSheetPosition: CGFloat?
    private var maxSheetPosition: CGFloat?
    
    ///View controllers which conform to Draggable protocol
    public var draggables: [DraggableItem] = []
    
    ///Drop shadow view behind container.
    private var dropShadowView: PassThroughView?

    private var tolerance: CGFloat = 0.0000001
    
    ///set true if sheet view controller is embedded in a UINavigationController
    public var usesNavigationController: Bool = false

    public var availableHeight: CGFloat {
        guard let parent = parent else { return 0 }
        return parent.view.frame.height
    }
    
    private var cornerRadius: CGFloat = 0 {
        didSet {
            applyDefaultShadowParams()
            clearShadowBackground()
        }
    }

    /**
     Creates InfinityBottomSheetCoordinator object.
     
     Calling this in `viewWillLayoutSubviews` is recommended. So the parent frame will be ready to calculate sheet params. Otherwise sheet may show up with a wrong position and frame.
     
     ```
     override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         // put your other stuff here
     
         guard sheetCoordinator == nil else {return}
         sheetCoordinator = InfinityBottomSheetCoordinator(parent: self)
     }
     ```
     - parameter parent: UIViewController
     - parameter delegate: InfinityBottomSheetCoordinatorDelegate
     */
    public init(parent: UIViewController,dataSource: InfinityBottomSheetCoordinatorDataSource, delegate: BottomSheetDelegate? = nil) {
        super.init()
        self.parent = parent
        self.dataSource = dataSource
        self.delegate = delegate
        
        minSheetPosition = dataSource.sheetPositions(availableHeight).min()
        maxSheetPosition = dataSource.sheetPositions(availableHeight).max()
    }
  
    
    /**
     Creates a container view, sets contraints, set initial position, add background view if needed.
     
     You must handle add child on your own. This lets you apply your custom presenting animation.
     # Example #
     Call below code in parent view controller swift file.
     
     - parameter config: Called after container created. So you can customize the view, like shadow, corner radius, border, etc.
     */
    public func createContainer(with config: @escaping (UIView) -> Void) {
        let view = PassThroughView()
        self.container = view
        config(view)
        container?.pinToEdges(to: parent.view)
        container?.constraint(parent, for: .top)?.constant = dataSource.sheetPositions(availableHeight)[0]
        setPosition(dataSource.initialPosition(availableHeight), animated: false)
    }
    
    /**
     Creates a container view, adds it as a child to the parent, sets contraints, set initial position, add background view if needed.
     
     - parameter item: view controller which conforms to the Draggable or navigation controller which contains draggable view controllers.
     - parameter parent: parent view controller
     - parameter animated: if true, the sheet is being added to the view controller using an animation (default is true).
     - parameter didContainerCreate: triggered when container view created so you can modify the container if needed.
     - parameter completion: called upon the completion of adding item
     */
    public func addBottomSheet(_ item: UIViewController,
                               to parent: UIViewController,
                               animated: Bool = true,
                               didCreateContainerView: ((UIView) -> Void)? = nil,
                               completion: (() -> Void)? = nil) {
        
        self.usesNavigationController = item is UINavigationController
        let container = PassThroughView()
        self.container = container
        parent.view.addSubview(container)
        let position = dataSource.initialPosition(availableHeight)
       
        parent.ub_add(item, in: container, animated: animated, topInset: position) { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.bottomSheet(container,
                                        didPresent: .finished(position, self.calculatePercent(at: position)))
            completion?()
        }
        
        didCreateContainerView?(container)
        setPosition(dataSource.initialPosition(availableHeight), animated: false)
    }
    
    /**
     Adds a new view child controller to the current container view
     
     - parameter item: view controller which conforms to the Draggable protocol
     - parameter completion: called upon completion of animation
     */
    public func addSheetChild(_ item: DraggableItem, completion:  ((Bool) -> Void)? = nil) {
        parent.addChild(item)
        container!.addSubview(item.view)
        item.didMove(toParent: parent)
        item.view.frame = container!.bounds.offsetBy(dx: 0, dy: availableHeight)

        UIView.animate(withDuration: 0.3) {
            item.view.frame = self.container!.bounds
        } completion: { finished in
            completion?(finished)
        }
    }
    
    /**
     Frame of the sheet when added.
     */
    private func getInitialFrame() -> CGRect {
        let minY = parent.view.bounds.minY + dataSource.initialPosition(availableHeight)
        return CGRect(x: parent.view.bounds.minX,
                      y: minY,
                      width: parent.view.bounds.width,
                      height: parent.view.bounds.maxY - minY)
    }
    
    /**
     Adds a drop shadow to the sheet.
     
     Use  ```removeDropShadow()``` to remove drop shadow.
     */
    public func addShadow(customShadow config: ((UIView) -> Void)? = nil) {
        guard dropShadowView == nil else {
            return
        }
        
        dropShadowView = PassThroughView()
        parent.view.insertSubview(dropShadowView!, belowSubview: container!)
        dropShadowView?.pinToEdges(to: container!,
                                   insets: UIEdgeInsets(top: -getInitialFrame().minY,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0))
    }
