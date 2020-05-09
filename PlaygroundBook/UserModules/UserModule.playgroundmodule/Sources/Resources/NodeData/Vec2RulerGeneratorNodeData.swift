//
//  Vec2GeneratorNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec2RulerGeneratorNodeData: NodeData
{
    var value : Dynamic<CGPoint> = Dynamic<CGPoint>(CGPoint.zero)
    
    override class var defaultTitle: String { return "Vec2 Ruler Pad Generator (vec2(x,y))" }
    override class var customViewHeight: CGFloat { return 200 }
    override class var defaultCanHavePreview: Bool { return false }
    override class var defaultPreviewOutportIndex: Int { return -1 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return []
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "Vector")
        ]
    }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = vec2(\(value.value.x),\(value.value.y));
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()).x,\(outPorts[0].getPortVariableName()).y,0.0,1.0);")
    }
    
    override func setupCustomView(view: UIView)
    {
        value.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
        let axisView : AxisRulerView = AxisRulerView(frame: view.bounds)
        axisView.value = value.value
        view.addSubview(axisView)
        axisView.valueChangedHandler =  { (point) -> () in
            self.value.value = point
        }
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Generator
    }
}
