//
//  Vec2MinusNodeData.swift
//  Book_Sources
//
//  Created by Justin Fincher on 19/3/2019.
//

import UIKit

class Vec2MinusNodeData: NodeData
{
    override class var defaultTitle: String { return "Vec2 Minus (vec2 c = a - b)" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "A"),
            Vec2NodePortData(title: "B")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "C")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = \(inPorts[0].getPortVariableName()) - \(inPorts[1].getPortVariableName());
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()).x,\(outPorts[0].getPortVariableName()).y,0.0,1.0);")
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Calculator
    }
}

