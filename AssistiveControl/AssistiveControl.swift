//
//  AssistiveControl.swift
//  AssistiveControl
//
//  Created by Haozhe XU on 15/2/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

/**
 Delegate of `AssistiveControl` that notifies the states change of the control.
 The control can be in either collapsed or expanded states, when in collapsed state, it can be moved (ie. dragged) within its super view; When in expanded state, the expanded view is center-aligned within its superview and a touch outside expanded view will transit it to collapsed state.
 **/
public protocol AssistiveControlDelegate: class {
    
    /// Notifies when the assistive control will collapse
    func assistiveControlWillCollapse(_ assistiveControl: AssistiveControl)
    
    /// Notifies when the assistive control did collapse
    func assistiveControlDidCollapse(_ assistiveControl: AssistiveControl)
    
    /// Notifies when the assistive control will expand
    func assistiveControlWillExpand(_ assistiveControl: AssistiveControl)
    
    /// Notifies when the assistive control did expand
    func assistiveControlDidExpand(_ assistiveControl: AssistiveControl)
    
    /// Notifies when user moves assistive control
    /// this can be only invoked for collapsed state
    func assistiveControlDidMove(_ assistiveControl: AssistiveControl)
}

public protocol AssistiveControlViewProvider: class {
    var assistiveView: UIView { get }
}

/**
 A UI control subclass that mimics iOS Assistive Touch.
 **/
public class AssistiveControl: UIControl {
    
    /// parking behavior of assistive control when in collapsed state
    public enum ParkingBehavior {
        
        /// sticks to nearest edge of superview
        case stickyEdge
        
        /// stays where it is
        case freestyle
    }
    
    /// states of assistive control
    public enum AssistiveControlState {
        case collapsed
        case expanded
    }
    
    /// parking behavior of assistive control
    public var parkingBehavior: ParkingBehavior {
        didSet {
            self.adjustLocation(animated: false)
        }
    }
    
    public private(set) var assistiveControlState: AssistiveControlState = .collapsed
    
    public var collapsedView: UIView? {
        set {
            collapsedViewProvider = {
                guard let newValue = newValue else {
                    return nil
                }
                return ViewProvider(newValue)
            }()
        }
        get {
            guard let collapsedViewProvider = collapsedViewProvider else {
                return nil
            }
            return collapsedViewProvider.assistiveView
        }
    }
    
    public var expandedView: UIView? {
        set {
            expandedViewProvider = {
                guard let newValue = newValue else {
                    return nil
                }
                return ViewProvider(newValue)
            }()
        }
        get {
            guard let expandedViewProvider = expandedViewProvider else {
                return nil
            }
            return expandedViewProvider.assistiveView
        }
    }
    
    public var collapsedViewProvider: AssistiveControlViewProvider? {
        willSet {
            if let newValue = newValue {
                collapsedViewProvider?.assistiveView.removeFromSuperview()
                newValue.assistiveView.isUserInteractionEnabled = false
                collapsedViewPreviousLocation = newValue.assistiveView.frame.origin
            }
        }
        didSet {
            if assistiveControlState == .collapsed {
                showCollapsedView()
            }
        }
    }
    
    public var expandedViewProvider: AssistiveControlViewProvider? {
        willSet {
            expandedViewProvider?.assistiveView.removeFromSuperview()
        }
        didSet {
            if assistiveControlState == .expanded {
                showExpandedView()
            }
        }
    }
    
    /// Optional delegate to receive state change events
    public var delegate: AssistiveControlDelegate?
    
    public required init?(coder aDecoder: NSCoder) {
        parkingBehavior = .stickyEdge
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        parkingBehavior = .stickyEdge
        super.init(frame: frame)
    }
    
    public override func didMoveToSuperview() {
        adjustLocation(animated: false)
    }
    
    // MARK: - Private
    
    private var previousTouchLocation: CGPoint = .zero
    private var collapsedViewPreviousLocation: CGPoint = .zero
    private var draggedAfterInitialTouch = false
    
    private func showCollapsedView() {
        guard let collapsedView = self.collapsedView else {
            return
        }
        
        expandedViewProvider?.assistiveView.removeFromSuperview()
        
        var endFrame = collapsedView.frame
        endFrame.origin = collapsedViewPreviousLocation
        
        self.frame = endFrame
        collapsedView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        
        self.addSubview(collapsedView)
        adjustLocation(animated: true)
        
        assistiveControlState = .collapsed
    }
    
    private func showExpandedView() {
        guard let container = self.superview, let expandedView = self.expandedViewProvider?.assistiveView else {
            return
        }
        
        collapsedView?.removeFromSuperview()
        
        collapsedViewPreviousLocation = self.frame.origin
        
        let containerSize = container.bounds.size
        var endFrame = expandedView.frame
        
        endFrame.origin = CGPoint(x: (containerSize.width - endFrame.size.width) / 2, y: (containerSize.height - endFrame.size.height) / 2)
        
        self.frame = container.bounds
        expandedView.frame = endFrame
        
        self.addSubview(expandedView)
        
        assistiveControlState = .expanded
    }
    
    private func adjustLocation(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let superview = self.superview else {
            completion?(false)
            return
        }
        
        let targetLocation = AssistiveControl.location(for: self.parkingBehavior, controlFrame: self.frame, within: superview.bounds.size)
        if targetLocation.equalTo(self.frame.origin) == false {
            let frameChanges: () -> Void = {
                self.frame = CGRect(x: targetLocation.x, y: targetLocation.y, width: self.frame.size.width, height: self.frame.size.height)
            }
            
            if animated {
                UIView.animate(withDuration: Constants.animationDuration, animations: frameChanges, completion: { (finished) in
                    completion?(true)
                })
            } else {
                frameChanges()
                completion?(true)
            }
        } else {
            completion?(false)
        }
    }
    
    private enum Constants {
        static let animationDuration = 0.2
    }
    
    private enum Edge {
        case top, left, bottom, right
        
        static func closestEdge(for frame: CGRect, within bounds: CGSize) -> Edge {
            let edgeDistances: [(Edge, CGFloat)] = [(.top, frame.origin.y), (.left, frame.origin.x), (.bottom, bounds.height - (frame.origin.y + frame.height)), (.right, bounds.width - (frame.origin.x + frame.width))]
            let (closestEdge, _) = edgeDistances.reduce((.top, frame.origin.y)) { edgeDistance1, edgeDistance2 in
                edgeDistance1.1 < edgeDistance2.1 ? edgeDistance1 : edgeDistance2
            }
            
            return closestEdge
        }
    }
    
    static private func location(for parkingBehavior: ParkingBehavior, controlFrame: CGRect, within bounds: CGSize) -> CGPoint {
        var targetLocation = controlFrame.origin
        
        if parkingBehavior == .stickyEdge {
            
            let closeToEdge = Edge.closestEdge(for: controlFrame, within: bounds)
            
            switch closeToEdge {
            case .top:
                targetLocation.y = 0
            case .left:
                targetLocation.x = 0
            case .bottom:
                targetLocation.y = bounds.height - controlFrame.size.height
            case .right:
                targetLocation.x = bounds.width - controlFrame.size.width
            }
        } else if parkingBehavior == .freestyle {
            // for freestyle parking behavior, make sure the control is within bounds
            targetLocation.x = max(0, targetLocation.x)
            targetLocation.x = min(bounds.width - controlFrame.size.width, targetLocation.x)
            targetLocation.y = max(0, targetLocation.y)
            targetLocation.y = min(bounds.height - controlFrame.size.height, targetLocation.y)
        }
        
        return targetLocation
    }
}

extension AssistiveControl {
    
    private class ViewProvider: AssistiveControlViewProvider {
        
        let assistiveView: UIView
        
        init(_ view: UIView) {
            self.assistiveView = view
        }
    }

}

// MARK: - Essential control action events

extension AssistiveControl {
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousTouchLocation = touch.location(in: self.superview)
        draggedAfterInitialTouch = false
        
        return true
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        draggedAfterInitialTouch = true
        
        let touchLocation = touch.location(in: self.superview)
        
        if assistiveControlState == .collapsed {
            let delta = CGPoint(x: touchLocation.x - previousTouchLocation.x, y: touchLocation.y - previousTouchLocation.y)
            self.center = self.center.applying(CGAffineTransform(translationX: delta.x, y: delta.y))
            self.delegate?.assistiveControlDidMove(self)
        }
        
        previousTouchLocation = touchLocation
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if assistiveControlState == .collapsed {
            if draggedAfterInitialTouch {
                adjustLocation(animated: true)
            } else {
                delegate?.assistiveControlWillExpand(self)
                showExpandedView()
                delegate?.assistiveControlDidExpand(self)
            }
        } else if let touchLocation = touch?.location(in: self) {
            if expandedViewProvider?.assistiveView.frame.contains(touchLocation) ?? false == false {
                delegate?.assistiveControlWillCollapse(self)
                showCollapsedView()
                delegate?.assistiveControlDidCollapse(self)
            }
        }
    }
}

/**
 Convenient way of creating assistive control
 **/
extension AssistiveControl {
    
    /// Create `AssistiveControl` with specified collapsed and expanded views, and add it to specified container view
    public static func create(in containerView: UIView, collapsedView: UIView!, expandedView: UIView!) -> AssistiveControl {
        let control = AssistiveControl(frame: collapsedView.frame)
        
        control.collapsedView = collapsedView
        control.expandedView = expandedView
        
        containerView.addSubview(control)
        
        return control
    }
    
    /// Create `AssistiveControl` in application's main window with specified collapsed and expanded views
    public static func createInMainWindow(collapsedView: UIView!, expandedView: UIView!) -> AssistiveControl? {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window ?? nil {
            return create(in: window, collapsedView: collapsedView, expandedView: expandedView)
        }
        return nil
    }
}
