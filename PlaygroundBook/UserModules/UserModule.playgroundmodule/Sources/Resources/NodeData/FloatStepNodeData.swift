//
//  FloatStepNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 19/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class FloatStepNodeData: NodeData {
    override class var defaultTitle: String { return "Float Step" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "Edge"),
            FloatNodePortData(title: "X")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "Result")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = step(\(inPorts[0].getPortVariableName()),\(inPorts[1].getPortVariableName()));
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),1.0);")
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Modifier
    }
    
}
