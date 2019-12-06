//
//  DnpPop.swift
//  DnpPop
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

import UIKit

/// Enum that specifies the direction of the DnpPop
@objc public enum DnpPopDirection: Int {
    /// Up, the DnpPop will appear above the element, arrow pointing down
    case up = 0
    /// Down, the DnpPop will appear below the element, arrow pointing up
    case down
    /// Left, the DnpPop will appear on the left of the element, arrow pointing right
    case left
    /// Right, the DnpPop will appear on the right of the element, arrow pointing left
    case right
    /// None, the DnpPop will appear above the element with no arrow
    case none
}

/** Enum that specifies the type of entrance animation. Entrance animations are performed while showing the DnpPop.
 
 - `scale`: The DnpPop scales from 0% to 100%
 - `transitions`: The DnpPop moves in position from the edge of the screen
 - `fadeIn`: The DnpPop fade in
 - `custom`: The Animation is provided by the user
 - `none`: No Animation
 */
@objc public enum DnpPopEntranceAnimation: Int {
    /// The DnpPop scales from 0% to 100%
    case scale
    /// The DnpPop moves in position from the edge of the screen
    case transition
    /// The DnpPop fades in
    case fadeIn
    /// The Animation is provided by the user
    case custom
    /// No Animation
    case none
}

/** Enum that specifies the type of entrance animation. Entrance animations are performed while showing the DnpPop.
 
 - `scale`: The DnpPop scales from 100% to 0%
 - `fadeOut`: The DnpPop fade out
 - `custom`: The Animation is provided by the user
 - `none`: No Animation
 */
@objc public enum DnpPopExitAnimation: Int {
    /// The DnpPop scales from 100% to 0%
    case scale
    /// The DnpPop fades out
    case fadeOut
    /// The Animation is provided by the user
    case custom
    /// No Animation
    case none
}

/** Enum that specifies the type of action animation. Action animations are performed after the DnpPop is visible and the entrance animation completed.
 
 - `bounce(offset: CGFloat?)`: The DnpPop bounces following its direction. The bounce offset can be provided optionally
 - `float(offset: CGFloat?)`: The DnpPop floats in place. The float offset can be provided optionally
 - `pulse(offset: CGFloat?)`: The DnpPop pulsates by changing its size. The maximum amount of pulse increase can be provided optionally
 - `none`: No animation
 */
public enum DnpPopActionAnimation {
    /// The DnpPop bounces following its direction. The bounce offset can be provided optionally
    case bounce(CGFloat?)
    /// The DnpPop floats in place. The float offset can be provided optionally. Defaults to 8 points
    case float(offsetX: CGFloat?, offsetY: CGFloat?)
    /// The DnpPop pulsates by changing its size. The maximum amount of pulse increase can be provided optionally. Defaults to 1.1 (110% of the original size)
    case pulse(CGFloat?)
    /// No animation
    case none
}

private let DefaultBounceOffset = CGFloat(8)
private let DefaultFloatOffset = CGFloat(8)
private let DefaultPulseOffset = CGFloat(1.1)

@objcMembers open class DnpPop: UIView {
    /// The text displayed by the DnpPop. Can be updated once the DnpPop is visible
    open var text: String? {
        didSet {
            accessibilityLabel = text
            setNeedsLayout()
        }
    }
    /// The `UIFont` used in the DnpPop's text
    open var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    /// The `UIColor` of the text
    @objc open dynamic var textColor = UIColor.white
    /// The `NSTextAlignment` of the text
    @objc open dynamic var textAlignment = NSTextAlignment.center
    /// The `UIColor` for the DnpPop's background
    @objc open dynamic var bubbleColor = UIColor.red
    /// The `UIColor` for the DnpPop's bordedr
    @objc open dynamic var borderColor = UIColor.clear
    /// The width for the DnpPop's border
    @objc open dynamic var borderWidth = CGFloat(0.0)
    /// The `Double` with the DnpPop's border radius
    @objc open dynamic var cornerRadius = CGFloat(4.0)
    /// The `BOOL` that determines wether the DnpPop is rounded. If set to `true` the radius will equal `frame.height / 2`
    @objc open dynamic var isRounded = false
    /// The `UIColor` with the DnpPop's shadow color
    @objc open dynamic var shadowColor: UIColor = .clear
    /// The `CGSize` with the DnpPop's shadow offset
    @objc open dynamic var shadowOffset: CGSize = .zero
    /// The `Float` with the DnpPop's shadow radius
    @objc open dynamic var shadowRadius: Float = 0
    /// The `Float` with the DnpPop's shadow opacity
    @objc open dynamic var shadowOpacity: Float = 0
    /// Holds the offset between the DnpPop and origin
    @objc open dynamic var offset = CGFloat(0.0)
    /// Holds the CGFloat with the padding used for the inner text
    @objc open dynamic var padding = CGFloat(6.0)
    /// Holds the insets setting for padding different direction
    @objc open dynamic var edgeInsets = UIEdgeInsets.zero
    /// Holds the CGSize with the width and height of the arrow
    @objc open dynamic var arrowSize = CGSize(width: 8, height: 8)
    /// CGfloat value that determines the radius of the vertex for the pointing arrow
    @objc open dynamic var arrowRadius = CGFloat(0.0)
    /// Holds the NSTimeInterval with the duration of the revealing animation
    @objc open dynamic var animationIn: TimeInterval = 0.4
    /// Holds the NSTimeInterval with the duration of the disappearing animation
    @objc open dynamic var animationOut: TimeInterval = 0.2
    /// Holds the NSTimeInterval with the delay of the revealing animation
    @objc open dynamic var delayIn: TimeInterval = 0
    /// Holds the NSTimeInterval with the delay of the disappearing animation
    @objc open dynamic var delayOut: TimeInterval = 0
    /// Holds the enum with the type of entrance animation (triggered once the DnpPop is shown)
    open var entranceAnimation = DnpPopEntranceAnimation.scale
    /// Holds the enum with the type of exit animation (triggered once the DnpPop is dismissed)
    open var exitAnimation = DnpPopExitAnimation.scale
    /// Holds the enum with the type of action animation (triggered once the DnpPop is shown)
    open var actionAnimation = DnpPopActionAnimation.none
    /// Holds the NSTimeInterval with the duration of the action animation
    @objc open dynamic var actionAnimationIn: TimeInterval = 1.2
    /// Holds the NSTimeInterval with the duration of the action stop animation
    @objc open dynamic var actionAnimationOut: TimeInterval = 1.0
    /// Holds the NSTimeInterval with the delay of the action animation
    @objc open dynamic var actionDelayIn: TimeInterval = 0
    /// Holds the NSTimeInterval with the delay of the action animation stop
    @objc open dynamic var actionDelayOut: TimeInterval = 0
    /// CGfloat value that determines the leftmost margin from the screen
    @objc open dynamic var edgeMargin = CGFloat(0.0)
    /// Holds the offset between the bubble and origin
    @objc open dynamic var bubbleOffset = CGFloat(0.0)
    /// Holds the offset between the center of the bubble and the arrow
    @objc open dynamic var arrowOffset = CGFloat(0.0)
    /// Color of the mask that is going to dim the background when the pop up is visible
    @objc open dynamic var maskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    /// Flag to enable or disable background mask
    @objc open dynamic var shouldShowMask = false
    /// Flag to enable or disable the checks that make sure that the tip does not extend over the container
    @objc open dynamic var constrainInContainerView = true
    /// Holds the CGrect with the rect the tip is pointing to
    open var from = CGRect.zero {
        didSet {
            setup()
        }
    }
    /// Holds the readonly BOOL with the DnpPop visiblity. The DnpPop is considered visible as soon as
    /// the animation is complete, and invisible when the subview is removed from its parent.
    open var isVisible: Bool { get { return self.superview != nil } }
    /// A boolean value that determines whether the DnpPop is dismissed on tap.
    @objc open dynamic var shouldDismissOnTap = true
    /// A boolean value that determines whether to dismiss when tapping outside the DnpPop.
    @objc open dynamic var shouldDismissOnTapOutside = true
    /// A boolean value that determines whether to consider the originating frame as part of the DnpPop,
    /// i.e wether to call the `tapHandler` or the `tapOutsideHandler` when the tap occurs in the `from` frame.
    @objc open dynamic var shouldConsiderOriginatingFrameAsDnpPop = false
    /// A boolean value that determines whether to dismiss when swiping outside the DnpPop.
    @objc open dynamic var shouldDismissOnSwipeOutside = false
    /// A boolean value that determines if the action animation should start automatically when the DnpPop is shown
    @objc open dynamic var startActionAnimationOnShow = true
    /// A direction that determines what swipe direction to dismiss when swiping outside the DnpPop.
    /// The default direction is `right`
    open var swipeRemoveGestureDirection = UISwipeGestureRecognizer.Direction.right {
        didSet {
            swipeGestureRecognizer?.direction = swipeRemoveGestureDirection
        }
    }
    /// A block that will be fired when the user taps the DnpPop.
    open var tapHandler: ((DnpPop) -> Void)?
    /// A block that will be fired when the user taps outside the DnpPop.
    open var tapOutsideHandler: ((DnpPop) -> Void)?
    /// A block that will be fired when the user swipes outside the DnpPop.
    open var swipeOutsideHandler: ((DnpPop) -> Void)?
    /// A block that will be fired when the DnpPop appears.
    open var appearHandler: ((DnpPop) -> Void)?
    /// A block that will be fired when the DnpPop is dismissed.
    open var dismissHandler: ((DnpPop) -> Void)?
    /// A block that handles the entrance animation of the DnpPop. Should be provided
    /// when using a `DnpPopActionAnimationCustom` entrance animation type.
    /// Please note that the DnpPop will be automatically added as a subview before firing the block
    /// Remember to call the completion block provided
    open var entranceAnimationHandler: ((@escaping () -> Void) -> Void)?
    /// A block block that handles the exit animation of the DnpPop. Should be provided
    /// when using a `AMDnpPopActionAnimationCustom` exit animation type.
    /// Remember to call the completion block provided
    open var exitAnimationHandler: ((@escaping () -> Void) -> Void)?
    /// The CGPoint originating the arrow. Read only.
    open private(set) var arrowPosition = CGPoint.zero
    /// A read only reference to the view containing the DnpPop
    open private(set) weak var containerView: UIView?
    /// The direction from which the DnpPop is shown. Read only.
    open private(set) var direction = DnpPopDirection.none
    /// Holds the readonly BOOL with the DnpPop animation state.
    open private(set) var isAnimating: Bool = false
    /// The view that dims the background (including the button that triggered DnpPop.
    /// The mask by appears with fade in effect only.
    open private(set) var backgroundMask: UIView?
    /// The tap gesture recognizer. Read-only.
    open private(set) var tapGestureRecognizer: UITapGestureRecognizer?
    fileprivate var attributedText: NSAttributedString?
    fileprivate var paragraphStyle = NSMutableParagraphStyle()
    fileprivate var tapRemoveGestureRecognizer: UITapGestureRecognizer?
    fileprivate var swipeGestureRecognizer: UISwipeGestureRecognizer?
    fileprivate var dismissTimer: Timer?
    fileprivate var textBounds = CGRect.zero
    fileprivate var maxWidth = CGFloat(0)
    fileprivate var customView: UIView?
    fileprivate var blurView : PopBlurView?
    fileprivate var isApplicationInBackground: Bool?
    fileprivate var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private var shouldBounce = false
    
    /// Setup a DnpPop oriented vertically (direction .up or .down). Returns the bubble frame and the arrow position
    ///
    /// - Returns: a tuple with the bubble frame and the arrow position
    internal func setupVertically() -> (CGRect, CGPoint) {
        guard let containerView = containerView else { return (CGRect.zero, CGPoint.zero) }
        
        var frame = CGRect.zero
        let offset = self.offset * (direction == .up ? -1 : 1)
        
        frame.size = CGSize(width: textBounds.width + padding * 2 + edgeInsets.horizontal, height: textBounds.height + padding * 2 + edgeInsets.vertical + arrowSize.height)
        var x = from.origin.x + from.width / 2 - frame.width / 2
        if x < 0 { x = edgeMargin }
        if constrainInContainerView && (x + frame.width > containerView.bounds.width) {
            x = containerView.bounds.width - frame.width - edgeMargin
        }
        
        if direction == .down {
            frame.origin = CGPoint(x: x, y: from.origin.y + from.height + offset)
        } else {
            frame.origin = CGPoint(x: x, y: from.origin.y - frame.height + offset)
        }
        
        // Constraint the offset in the boundaries of the bubble, maintaining the sign (hence the arrowOffset / arrowOffset)
        let constrainedArrowOffset = abs(arrowOffset) > (frame.size.width / 2) ? ((arrowOffset / arrowOffset) * (frame.size.width / 2 - cornerRadius * 2)) : arrowOffset
        // Make sure that the bubble doesn't leave the boundaries of the view
        var arrowPosition = CGPoint(
            x: from.origin.x + from.width / 2 - frame.origin.x - constrainedArrowOffset,
            y: (direction == .up) ? frame.height : from.origin.y + from.height - frame.origin.y + offset
        )
        
        /*if bubbleOffset > 0 && arrowPosition.x < bubbleOffset {
            bubbleOffset = arrowPosition.x - arrowSize.width
        } else if bubbleOffset < 0 && frame.width < abs(bubbleOffset) {
            bubbleOffset = -(arrowPosition.x - arrowSize.width)
        } else if bubbleOffset < 0 && (frame.origin.x - arrowPosition.x) < abs(bubbleOffset) {
            bubbleOffset = -(arrowSize.width + edgeMargin)
        }*/
        
        if constrainInContainerView {
            // Make sure that the bubble doesn't leave the boundaries of the view
            let leftSpace = frame.origin.x - containerView.frame.origin.x
            let rightSpace = containerView.frame.width - leftSpace - frame.width
            
            if bubbleOffset < 0 && leftSpace < abs(bubbleOffset) {
                bubbleOffset = -leftSpace + edgeMargin
            } else if bubbleOffset > 0 && rightSpace < bubbleOffset {
                bubbleOffset = rightSpace - edgeMargin
            }
        }
        frame.origin.x += bubbleOffset
        frame.size = CGSize(width: frame.width + borderWidth * 2, height: frame.height + borderWidth * 2)
        
        // Only when the tip is not constrained, make sure to center the frame if the containerView is smaller than the tip
        if containerView.frame.width < frame.width, !constrainInContainerView {
            frame.origin.x = -frame.width / 2 + containerView.frame.width / 2
            arrowPosition.x += frame.width / 2 - containerView.frame.width / 2
        }
        
        return (frame, arrowPosition)
    }
    
    /// Setup a DnpPop oriented horizontally (direction .left or .right). Returns the bubble frame and the arrow position
    ///
    /// - Returns: a tuple with the bubble frame and the arrow position
    internal func setupHorizontally() -> (CGRect, CGPoint) {
        guard let containerView = containerView else { return (CGRect.zero, CGPoint.zero) }
        
        var frame = CGRect.zero
        let offset = self.offset * (direction == .left ? -1 : 1)
        frame.size = CGSize(width: textBounds.width + padding * 2 + edgeInsets.horizontal + arrowSize.height, height: textBounds.height + padding * 2 + edgeInsets.vertical)
        
        let x = direction == .left ? from.origin.x - frame.width + offset : from.origin.x + from.width + offset
        var y = from.origin.y + from.height / 2 - frame.height / 2
        
        if y < 0 { y = edgeMargin }
        // Make sure we stay in the view limits except if it has scroll then it must be inside contentview limits not the view
        if let containerScrollView = containerView as? UIScrollView {
            if y + frame.height > containerScrollView.contentSize.height {
                y = containerScrollView.contentSize.height - frame.height - edgeMargin
            }
        } else {
            if y + frame.height > containerView.bounds.height && constrainInContainerView {
                y = containerView.bounds.height - frame.height - edgeMargin
            }
        }
        frame.origin = CGPoint(x: x, y: y)
        
        // Constraint the offset in the boundaries of the bubble, maintaining the sign (hence the arrowOffset / arrowOffset)
        let constrainedArrowOffset = abs(arrowOffset) > (frame.size.height / 2) ? ((arrowOffset / arrowOffset) * (frame.size.height / 2  - cornerRadius * 2)) : arrowOffset
        // Make sure that the bubble doesn't leave the boundaries of the view
        let arrowPosition = CGPoint(
            x: direction == .left ? from.origin.x - frame.origin.x + offset : from.origin.x + from.width - frame.origin.x + offset,
            y: from.origin.y + from.height / 2 - frame.origin.y - constrainedArrowOffset
        )
        
        /*if bubbleOffset > 0 && arrowPosition.y < bubbleOffset {
            bubbleOffset = arrowPosition.y - arrowSize.width
        } else if bubbleOffset < 0 && frame.height < abs(bubbleOffset) {
            bubbleOffset = -(arrowPosition.y - arrowSize.height)
        }*/
        
        if constrainInContainerView {
            let topSpace = frame.origin.y - containerView.frame.origin.y
            let bottomSpace = containerView.frame.height - topSpace - frame.height
            
            if bubbleOffset < 0 && topSpace < abs(bubbleOffset) {
                bubbleOffset = -topSpace + edgeMargin
            } else if bubbleOffset > 0 && bottomSpace < bubbleOffset {
                bubbleOffset = bottomSpace - edgeMargin
            }
        }
        
        frame.origin.y += bubbleOffset
        frame.size = CGSize(width: frame.width + borderWidth * 2, height: frame.height + borderWidth * 2)
        
        return (frame, arrowPosition)
    }
    
    /// Checks if the rect with positioning `.none` is inside the container
    internal func rectContained(rect: CGRect) -> CGRect {
        guard let containerView = containerView, constrainInContainerView else { return rect }
        
        var finalRect = rect
        
        // The `.none` positioning implies a rect with the origin in the middle of the DnpPop
        if (rect.origin.x) < containerView.frame.origin.x {
            finalRect.origin.x = edgeMargin
        }
        if (rect.origin.y) < containerView.frame.origin.y {
            finalRect.origin.y = edgeMargin
        }
        if (rect.origin.x + rect.width) > (containerView.frame.origin.x + containerView.frame.width) {
            finalRect.origin.x = containerView.frame.origin.x + containerView.frame.width - rect.width - edgeMargin
        }
        if (rect.origin.y + rect.height) > (containerView.frame.origin.y + containerView.frame.height) {
            finalRect.origin.y = containerView.frame.origin.y + containerView.frame.height - rect.height - edgeMargin
        }
        
        return finalRect
    }
    
    fileprivate func textBounds(for text: String?, attributedText: NSAttributedString?, view: UIView?, with font: UIFont, padding: CGFloat, edges: UIEdgeInsets, in maxWidth: CGFloat) -> CGRect {
        var bounds = CGRect.zero
        if let text = text {
            bounds = NSString(string: text).boundingRect(with: CGSize(width: maxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        }
        if let attributedText = attributedText {
            bounds = attributedText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
        }
        if let view = view {
            bounds = view.frame
        }
        bounds.origin = CGPoint(x: padding + edges.left, y: padding + edges.top)
        return bounds.integral
    }
    
    fileprivate func setup() {
        guard let containerView = containerView else { return }
        
        var rect = CGRect.zero
        backgroundColor = .clear
        
        if direction == .left {
            maxWidth = CGFloat.minimum(maxWidth, from.origin.x - padding * 2 - edgeInsets.horizontal - arrowSize.width)
        }
        if direction == .right {
            maxWidth = CGFloat.minimum(maxWidth, containerView.bounds.width - from.origin.x - from.width - padding * 2 - edgeInsets.horizontal - arrowSize.width)
        }
        
        textBounds = textBounds(for: text, attributedText: attributedText, view: customView, with: font, padding: padding, edges: edgeInsets, in: maxWidth)
        
        switch direction {
        case .up:
            let dimensions = setupVertically()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.x / rect.size.width
            layer.anchorPoint = CGPoint(x: anchor, y: 1)
            layer.position = CGPoint(x: layer.position.x + rect.width * anchor, y: layer.position.y + rect.height / 2)
        case .down:
            let dimensions = setupVertically()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.x / rect.size.width
            textBounds.origin = CGPoint(x: textBounds.origin.x, y: textBounds.origin.y + arrowSize.height)
            layer.anchorPoint = CGPoint(x: anchor, y: 0)
            layer.position = CGPoint(x: layer.position.x + rect.width * anchor, y: layer.position.y - rect.height / 2)
        case .left:
            let dimensions = setupHorizontally()
            rect = dimensions.0
            arrowPosition = dimensions.1
            let anchor = arrowPosition.y / rect.height
            layer.anchorPoint = CGPoint(x: 1, y: anchor)
            layer.position = CGPoint(x: layer.position.x - rect.width / 2, y: layer.position.y + rect.height * anchor)
        case .right:
            let dimensions = setupHorizontally()
            rect = dimensions.0
            arrowPosition = dimensions.1
            textBounds.origin = CGPoint(x: textBounds.origin.x + arrowSize.height, y: textBounds.origin.y)
            let anchor = arrowPosition.y / rect.height
            layer.anchorPoint = CGPoint(x: 0, y: anchor)
            layer.position = CGPoint(x: layer.position.x + rect.width / 2, y: layer.position.y + rect.height * anchor)
        case .none:
            rect.size = CGSize(width: textBounds.width + padding * 2.0 + edgeInsets.horizontal + borderWidth * 2, height: textBounds.height + padding * 2.0 + edgeInsets.vertical + borderWidth * 2)
            rect.origin = CGPoint(x: from.midX - rect.size.width / 2, y: from.midY - rect.height / 2)
            rect = rectContained(rect: rect)
            arrowPosition = CGPoint.zero
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            layer.position = CGPoint(x: from.midX, y: from.midY)
        }
        
        label.frame = textBounds
        if label.superview == nil {
            addSubview(label)
        }
        
        frame = rect
        
        if let m_blurView = blurView {
            m_blurView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            m_blurView.backgroundColor = .clear
        }
        
        if let customView = customView {
            customView.frame = textBounds
        }
        
        if !shouldShowMask {
            backgroundMask?.removeFromSuperview()
        } else {
            if backgroundMask == nil {
                backgroundMask = UIView()
                backgroundMask?.backgroundColor = maskColor
            }
            backgroundMask?.frame = containerView.bounds
        }
        
        setNeedsDisplay()
        
        if tapGestureRecognizer == nil {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DnpPop.handleTap(_:)))
            tapGestureRecognizer?.cancelsTouchesInView = false
            self.addGestureRecognizer(tapGestureRecognizer!)
        }
        if shouldDismissOnTapOutside && tapRemoveGestureRecognizer == nil {
            tapRemoveGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DnpPop.handleTapOutside(_:)))
        }
        if shouldDismissOnSwipeOutside && swipeGestureRecognizer == nil {
            swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DnpPop.handleSwipeOutside(_:)))
            swipeGestureRecognizer?.direction = swipeRemoveGestureDirection
        }
        
        if isApplicationInBackground == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(DnpPop.handleApplicationActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DnpPop.handleApplicationResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    /// Custom draw override
    ///
    /// - Parameter rect: the rect occupied by the view
    open override func draw(_ rect: CGRect) {
        if isRounded {
            let showHorizontally = direction == .left || direction == .right
            cornerRadius = (frame.size.height - (showHorizontally ? 0 : arrowSize.height)) / 2
        }
        
        let path = DnpPop.pathWith(rect: rect, frame: frame, direction: direction, arrowSize: arrowSize, arrowPosition: arrowPosition, arrowRadius: arrowRadius, borderWidth: borderWidth, radius: cornerRadius)
        
        layer.shadowPath = path.cgPath
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        
        bubbleColor.setFill()
        path.fill()
        
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        
        self.blurView?.direction = direction
        self.blurView?.arrowSize = arrowSize
        self.blurView?.arrowPosition = arrowPosition
        self.blurView?.arrowRadius = arrowRadius
        self.blurView?.cornerRadius = cornerRadius
        self.blurView?.borderWidth = borderWidth
        self.blurView?.shadowOpacity = shadowOpacity
        self.blurView?.shadowRadius = shadowRadius
        self.blurView?.shadowOffset = shadowOffset
        self.blurView?.shadowColor = shadowColor
        self.blurView?.bubbleColor = bubbleColor
        self.blurView?.borderColor = borderColor
        self.blurView?.setNeedsDisplay()
        
        paragraphStyle.alignment = textAlignment
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        if let text = text {
            label.attributedText = NSAttributedString(string: text, attributes: titleAttributes)
        } else if let text = attributedText {
            label.attributedText = text
        } else {
            label.attributedText = nil
        }
    }
    
    /// Shows an animated DnpPop in a given view, from a given rectangle. The property `isVisible` will be `true` as soon as the DnpPop is added to the given view.
    ///
    /// - Parameters:
    ///   - text: The text to display
    ///   - direction: The direction of the DnpPop in relation to the element that generates it
    ///   - maxWidth: The maximum width of the DnpPop. If the DnpPop won't fit in the given space, this will be overridden.
    ///   - view: The view that will hold the DnpPop as a subview.
    ///   - frame: The originating frame. The DnpPop's arrow will point to the center of this frame.
    ///   - duration: Optional time interval that determines when the DnpPop will self-dismiss.
    open func show(text: String, direction: DnpPopDirection, maxWidth: CGFloat, in view: UIView, from frame: CGRect, duration: TimeInterval? = nil) {
        resetView()
        
        attributedText = nil
        self.text = text
        accessibilityLabel = text
        self.direction = direction
        containerView = view
        self.maxWidth = maxWidth
        customView?.removeFromSuperview()
        customView = nil
        from = frame
        
        show(duration: duration)
    }
    
    /// Shows an animated DnpPop in a given view, from a given rectangle. The property `isVisible` will be `true` as soon as the DnpPop is added to the given view.
    ///
    /// - Parameters:
    ///   - attributedText: The attributed string to display
    ///   - direction: The direction of the DnpPop in relation to the element that generates it
    ///   - maxWidth: The maximum width of the DnpPop. If the DnpPop won't fit in the given space, this will be overridden.
    ///   - view: The view that will hold the DnpPop as a subview.
    ///   - frame: The originating frame. The DnpPop's arrow will point to the center of this frame.
    ///   - duration: Optional time interval that determines when the DnpPop will self-dismiss.
    open func show(attributedText: NSAttributedString, direction: DnpPopDirection, maxWidth: CGFloat, in view: UIView, from frame: CGRect, duration: TimeInterval? = nil) {
        resetView()
        
        text = nil
        self.attributedText = attributedText
        accessibilityLabel = attributedText.string
        self.direction = direction
        containerView = view
        self.maxWidth = maxWidth
        customView?.removeFromSuperview()
        customView = nil
        from = frame
        
        show(duration: duration)
    }
    
    
    /// Shows an animated DnpPop in a given view, from a given rectangle. The property `isVisible` will be `true` as soon as the DnpPop is added to the given view.
    ///
    /// - Parameters:
    ///   - customView: A custom view
    ///   - direction: The direction of the DnpPop in relation to the element that generates it
    ///   - view: The view that will hold the DnpPop as a subview.
    ///   - frame: The originating frame. The DnpPop's arrow will point to the center of this frame.
    ///   - duration: Optional time interval that determines when the DnpPop will self-dismiss.
    open func show(customView: UIView, direction: DnpPopDirection, in view: UIView, from frame: CGRect, duration: TimeInterval? = nil) {
        resetView()
        
        text = nil
        attributedText = nil
        self.direction = direction
        containerView = view
        maxWidth = customView.frame.size.width
        self.customView?.removeFromSuperview()
        self.customView = customView
        addSubview(customView)
        customView.layoutIfNeeded()
        from = frame
        
        show(duration: duration)
    }
    
    /// Update the current text
    ///
    /// - Parameter text: the new text
    open func update(text: String) {
        self.text = text
        updateBubble()
    }
    
    /// Update the current text
    ///
    /// - Parameter attributedText: the new attributs string
    open func update(attributedText: NSAttributedString) {
        self.attributedText = attributedText
        updateBubble()
    }
    
    /// Update the current text
    ///
    /// - Parameter customView: the new custom view
    open func update(customView: UIView) {
        self.customView = customView
        updateBubble()
    }
    
    /// Hides the DnpPop and removes it from the view. The property `isVisible` will be set to `false` when the animation is complete and the DnpPop is removed from the parent view.
    ///
    /// - Parameter forced: Force the removal, ignoring running animations
    @objc open func hide(forced: Bool = false) {
        if !forced && isAnimating {
            return
        }
        
        resetView()
        isAnimating = true
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        if let gestureRecognizer = tapRemoveGestureRecognizer {
            containerView?.removeGestureRecognizer(gestureRecognizer)
        }
        if let gestureRecognizer = swipeGestureRecognizer {
            containerView?.removeGestureRecognizer(gestureRecognizer)
        }
        
        let completion = {
            self.blurView?.removeFromSuperview()
            self.blurView = nil
            self.customView?.removeFromSuperview()
            self.customView = nil
            self.dismissActionAnimation()
            self.backgroundMask?.removeFromSuperview()
            self.removeFromSuperview()
            self.layer.removeAllAnimations()
            self.transform = .identity
            self.isAnimating = false
            self.dismissHandler?(self)
        }
        
        if isApplicationInBackground ?? false {
            completion()
        } else {
            performExitAnimation(completion: completion)
        }
    }
    
    /// Makes the DnpPop perform the action indefinitely. The action animation calls for the user's attention after the DnpPop is shown
    open func startActionAnimation() {
        performActionAnimation()
    }
    
    /// Stops the DnpPop action animation. Does nothing if the DnpPop wasn't animating in the first place.
    ///
    /// - Parameter completion: Optional completion block clled once the animation is completed
    open func stopActionAnimation(_ completion: (() -> Void)? = nil) {
        dismissActionAnimation(completion)
    }
    
    fileprivate func resetView() {
        CATransaction.begin()
        layer.removeAllAnimations()
        CATransaction.commit()
        transform = .identity
        shouldBounce = false
    }
    
    fileprivate func updateBubble() {
        stopActionAnimation {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
                self.setup()
            }) { (_) in
                self.startActionAnimation()
            }
        }
    }
    
    fileprivate func show(duration: TimeInterval? = nil) {
        isAnimating = true
        dismissTimer?.invalidate()
        
        setNeedsLayout()
        performEntranceAnimation {
            if let tapRemoveGesture = self.tapRemoveGestureRecognizer {
                self.containerView?.addGestureRecognizer(tapRemoveGesture)
            }
            if let swipeGesture = self.swipeGestureRecognizer {
                self.containerView?.addGestureRecognizer(swipeGesture)
            }
            
            self.appearHandler?(self)
            if self.startActionAnimationOnShow {
                self.performActionAnimation()
            }
            self.isAnimating = false
            if let duration = duration {
                self.dismissTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(DnpPop.hide), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer) {
        if shouldDismissOnTap {
            hide()
        }
        tapHandler?(self)
    }
    
    @objc fileprivate func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        if shouldDismissOnTapOutside {
            hide()
        }
        
        if shouldConsiderOriginatingFrameAsDnpPop && from.contains(gesture.location(in: containerView)) {
            tapHandler?(self)
        } else {
            tapOutsideHandler?(self)
        }
    }
    
    @objc fileprivate func handleSwipeOutside(_ gesture: UITapGestureRecognizer) {
        if shouldDismissOnSwipeOutside {
            hide()
        }
        swipeOutsideHandler?(self)
    }
    
    @objc fileprivate func handleApplicationActive() {
        isApplicationInBackground = false
    }
    
    @objc fileprivate func handleApplicationResignActive() {
        isApplicationInBackground = true
    }
    
    fileprivate func performActionAnimation() {
        switch actionAnimation {
        case .bounce(let offset):
            shouldBounce = true
            bounceAnimation(offset: offset ?? DefaultBounceOffset)
        case .float(let offsetX, let offsetY):
            floatAnimation(offsetX: offsetX ?? DefaultFloatOffset, offsetY: offsetY ?? DefaultFloatOffset)
        case .pulse(let offset):
            pulseAnimation(offset: offset ?? DefaultPulseOffset)
        case .none:
            return
        }
    }
    
    fileprivate func dismissActionAnimation(_ completion: (() -> Void)? = nil) {
        shouldBounce = false
        UIView.animate(withDuration: actionAnimationOut / 2, delay: actionDelayOut, options: .beginFromCurrentState, animations: {
            self.transform = .identity
        }) { (_) in
            self.layer.removeAllAnimations()
            completion?()
        }
    }
    
    fileprivate func bounceAnimation(offset: CGFloat) {
        var offsetX = CGFloat(0)
        var offsetY = CGFloat(0)
        switch direction {
        case .up, .none:
            offsetY = -offset
        case .left:
            offsetX = -offset
        case .right:
            offsetX = offset
        case .down:
            offsetY = offset
        }
        
        UIView.animate(withDuration: actionAnimationIn / 10, delay: actionDelayIn, options: [.curveEaseIn, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        }) { (completed) in
            if completed {
                UIView.animate(withDuration: self.actionAnimationIn - self.actionAnimationIn / 10, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.transform = .identity
                }, completion: { (done) in
                    if self.shouldBounce && done {
                        self.bounceAnimation(offset: offset)
                    }
                })
            }
        }
    }
    
    fileprivate func floatAnimation(offsetX: CGFloat, offsetY: CGFloat) {
        var offsetX = offsetX
        var offsetY = offsetY
        switch direction {
        case .up, .none:
            offsetY = -offsetY
        case .left:
            offsetX = -offsetX
        default: break
        }
        
        UIView.animate(withDuration: actionAnimationIn / 2, delay: actionDelayIn, options: [.curveEaseInOut, .repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        }, completion: nil)
    }
    
    fileprivate func pulseAnimation(offset: CGFloat) {
        UIView.animate(withDuration: actionAnimationIn / 2, delay: actionDelayIn, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState, .autoreverse, .repeat], animations: {
            self.transform = CGAffineTransform(scaleX: offset, y: offset)
        }, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func show(customView: UIView,blurView: PopBlurView, direction: DnpPopDirection, in view: UIView, from frame: CGRect, duration: TimeInterval? = nil) {
        resetView()
        
        text = nil
        attributedText = nil
        self.direction = direction
        containerView = view
        maxWidth = customView.frame.size.width
        self.blurView?.removeFromSuperview()
        self.blurView = blurView
        self.insertSubview(blurView, at: 0)
        self.customView?.removeFromSuperview()
        self.customView = customView
        addSubview(customView)
        customView.layoutIfNeeded()
        blurView.layoutIfNeeded()
        from = frame
        
        show(duration: duration)
    }
    
    // MARK: New add method bridge object-C
    open func show(text: String, direction: DnpPopDirection, maxWidth: CGFloat, in view: UIView, from frame: CGRect) {
        show(text: text, direction: direction, maxWidth: maxWidth, in: view, from: frame, duration: nil)
    }
    
    open func show(attributedText: NSAttributedString, direction: DnpPopDirection, maxWidth: CGFloat, in view: UIView, from frame: CGRect) {
        show(attributedText: attributedText, direction: direction, maxWidth: maxWidth, in: view, from: frame, duration: nil)
    }
    
    open func show(customView: UIView, direction: DnpPopDirection, in view: UIView, from frame: CGRect) {
        show(customView: customView, direction: direction, in: view, from: frame, duration: nil)
    }
    
    open func show(customView: UIView, blurView: PopBlurView, direction: DnpPopDirection, in view: UIView, from frame: CGRect) {
        show(customView: customView, blurView: blurView, direction: direction, in: view, from: frame,duration: nil)
    }
}

fileprivate extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}
