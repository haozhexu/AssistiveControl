//
//  AssistiveControl.swift
//  AssistiveControl
//
//  Created by Haozhe XU on 15/2/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

public class AssistiveControl: UIControl {
    
    public enum ParkingBehavior {
        case stickyEdge
        case freestyle
    }
    
    public enum AssistiveControlState {
        case collapsed
        case expanded
    }
    
    public var parkingBehavior: ParkingBehavior {
        didSet {
            self.adjustLocation(animated: false)
        }
    }
    
    public private(set) var assistiveControlState: AssistiveControlState = .collapsed
    
    public var collapsedView: UIView! {
        willSet {
            collapsedView.removeFromSuperview()
            newValue.isUserInteractionEnabled = false
            collapsedViewPreviousLocation = newValue.frame.origin
        }
        didSet {
            if assistiveControlState == .collapsed {
                showCollapsedView()
            }
        }
    }
    
    public var expandedView: UIView! {
        willSet {
            expandedView.removeFromSuperview()
        }
        didSet {
            if assistiveControlState == .expanded {
                showExpandedView()
            }
        }
    }
    
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
    
    // MARK: - Essential control action events
    
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
        }
        
        previousTouchLocation = touchLocation
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if assistiveControlState == .collapsed {
            if draggedAfterInitialTouch {
                adjustLocation(animated: true)
            } else {
                showExpandedView()
            }
        } else if let touchLocation = touch?.location(in: self) {
            if expandedView.frame.contains(touchLocation) {
                showCollapsedView()
            }
        }
    }
    
    // MARK: - Private
    
    private var previousTouchLocation: CGPoint = .zero
    private var collapsedViewPreviousLocation: CGPoint = .zero
    private var draggedAfterInitialTouch = false
    
    private func showCollapsedView() {
        expandedView.removeFromSuperview()
        
        var endFrame = collapsedView.frame
        endFrame.origin = collapsedViewPreviousLocation
        
        self.frame = endFrame
        collapsedView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        self.addSubview(collapsedView)
        adjustLocation(animated: true)
        
        assistiveControlState = .collapsed
    }
    
    private func showExpandedView() {
        guard let container = self.superview else {
            return
        }
        
        collapsedView.removeFromSuperview()
        
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
        static let animationDuration = 0.3
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
    
    public static func create(in containerView: UIView, collapsedView: UIView!, expandedView: UIView!) -> AssistiveControl {
        let control = AssistiveControl(frame: collapsedView.frame)
        
        control.collapsedView = collapsedView
        control.expandedView = expandedView
        
        containerView.addSubview(control)
        
        return control
    }
    
    public static func createInMainWindow(collapsedView: UIView!, expandedView: UIView!) -> AssistiveControl? {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window ?? nil {
            return create(in: window, collapsedView: collapsedView, expandedView: expandedView)
        }
        return nil
    }
    
}
