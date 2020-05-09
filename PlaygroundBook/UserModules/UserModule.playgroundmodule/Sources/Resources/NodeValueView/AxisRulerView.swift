//
//  AxisRulerView.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class AxisRulerView: UIView
{
    var value : CGPoint = CGPoint.zero
    {
        didSet
        {
            point = CGPoint.init(x: self.frame.size.width * (value.x + 1) / 2, y: self.frame.size.height * (value.y + 1) / 2)
        }
    }
    var point : CGPoint = CGPoint.zero
//    var pan : UIPanGestureRecognizer?
    var valueChangedHandler: ((CGPoint) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    
    func postInit() -> Void
    {
        isUserInteractionEnabled = true
        isOpaque = false
        backgroundColor = UIColor.clear
//        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
//        if let pan = pan {
//            addGestureRecognizer(pan)
//        }
        point = CGPoint.init(x: self.frame.size.width/2, y:  self.frame.size.height/2)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        value = CGPoint.init(x: point.x / (self.frame.size.width / 2) - 1, y: point.y / (self.frame.size.height / 2) - 1)
        if let valueChangedHandler = valueChangedHandler
        {
            valueChangedHandler(value)
        }
        setNeedsDisplay()
        
        return super.hitTest(point, with: event)
    }
    
//    @objc func handlePan(recognizer : UIPanGestureRecognizer) -> Void
//    {
//        point = recognizer.location(in: self)
//        value = CGPoint.init(x: point.x / (self.frame.size.width / 2) - 1, y: point.y / (self.frame.size.height / 2) - 1)
//        if let valueChangedHandler = valueChangedHandler
//        {
//            valueChangedHandler(value)
//        }
//        setNeedsDisplay()
//    }
    
    override func draw(_ rect: CGRect)
    {
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setLineWidth(2.0)
            
            for i in 1..<10
            {
                if i == 5
                {
                    context.setStrokeColor(UIColor.black.withAlphaComponent(0.7).cgColor)
                }else
                {
                    context.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
                }
                context.addLines(between: [
                    CGPoint.init(x: self.frame.size.width / 10 * CGFloat(i), y: 0),
                    CGPoint.init(x: self.frame.size.width / 10 * CGFloat(i), y: self.frame.size.height)
                    ])
                context.strokePath()
            }
            
            for i in 1..<10
            {
                if i == 5
                {
                    context.setStrokeColor(UIColor.black.withAlphaComponent(0.7).cgColor)
                }else
                {
                    context.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
                }
                context.addLines(between: [
                    CGPoint.init(x: 0, y: self.frame.size.height / 10 * CGFloat(i)),
                    CGPoint.init(x: self.frame.size.width, y: self.frame.size.height / 10 * CGFloat(i))
                    ])
                context.strokePath()
            }
            
            
            let path : UIBezierPath = UIBezierPath(ovalIn: CGRect.init(origin: CGPoint.init(x: point.x - 5, y: point.y - 5), size: CGSize.init(width: 10, height: 10)))
            UIColor.black.setFill()
            path.stroke()
            path.fill()
            
        }
    }

}
