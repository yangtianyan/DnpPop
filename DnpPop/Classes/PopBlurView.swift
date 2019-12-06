//
//  PopBlurView.swift
//  DnpPop
//
//  Created by Zomfice on 2019/12/6.
//

import UIKit

@objcMembers open class PopBlurView: UIView {
    var direction = DnpPopDirection.none
    var arrowSize = CGSize(width: 8, height: 8)
    var arrowPosition = CGPoint.zero
    var arrowRadius = CGFloat(0.0)
    var borderWidth = CGFloat(0.0)
    var cornerRadius = CGFloat(4.0)
    var shadowOpacity: Float = 0
    var shadowRadius: Float = 0
    var shadowOffset: CGSize = .zero
    var shadowColor: UIColor = .clear
    var bubbleColor = UIColor.clear
    var borderColor = UIColor.clear
    
    override public func draw(_ rect: CGRect) {
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
    }
}
