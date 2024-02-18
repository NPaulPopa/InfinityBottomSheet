//
//  InfinityBottomSheetProtocols.swift
//  FeedPage
//
//  Created by Paul Pop on 06/01/2023.
//

import UIKit

/**
 Conform this protocol to creat ecustom finish animation on pan gesture ended.
 */
public protocol Animatable {
    func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}


public typealias DraggableItem = Draggable & UIViewController

///UIViewControllers must conform this to make use of InfinityBottomSheet gesture handling
public protocol Draggable {
    var bottomSheetController: BottomSheetProtocol? { get set }
    var bottomSheetManager: BottomSheetManagerProtocol?  { get set }
    func draggableView() -> UIScrollView?
}

///draggableView sets to nil by default. Set any scroll view to track.
public extension Draggable {
    func draggableView() -> UIScrollView? {
        return nil
    }
}


public class DefaultSheetAnimator: Animatable {
    public func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
//        UIView.animate(withDuration: 0.3, // original
//                       delay: 0,
//                       usingSpringWithDamping: 0.8,
//                       initialSpringVelocity: 0.8,
//                       options: [.curveEaseInOut, .allowUserInteraction],
//                       animations: animations,
//                       completion: completion)
        
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: animations,
                       completion: completion)
    }
}

//MARK: - EXTENSIONS

extension UIViewController {
    func ub_add(_ child: UIViewController,
                in container: UIView,
                animated: Bool,
                topInset: CGFloat,
                completion: (() -> Void)? = nil) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let frame = CGRect(x: view.frame.minX,
                           y: view.frame.minY,
                           width: view.frame.width,
                           height: view.frame.maxY - topInset)
        if animated {
            container.frame = frame.offsetBy(dx: 0, dy: frame.height)
            child.view.frame = container.bounds
            UIView.animate(withDuration: 0.3, animations: {
                container.frame = frame
            }) { _ in
                completion?()
            }
        } else {
            container.frame = frame
            child.view.frame = container.bounds
            completion?()
        }
        
    }

    func ub_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

}

public extension UIView {
    func pinToEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
    }
    
    func constraint(_ parent: UIViewController, for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return parent.view.constraints.first(where: { (constraint) -> Bool in
            constraint.firstItem as? UIView == self && constraint.firstAttribute == attribute
         })
    }
    
    public static func scaledConstant(fromPixels pixels: CGFloat, deviceScale: CGFloat) -> CGFloat {
        pixels / deviceScale
    }
}

extension Array where Element == CGFloat {
    func nearest(to x: CGFloat) -> CGFloat {
        return self.reduce(self.first!) { abs($1 - x) < abs($0 - x) ? $1 : $0 }
    }
}
