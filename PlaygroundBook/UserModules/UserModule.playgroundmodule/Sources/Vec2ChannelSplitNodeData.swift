//
//  Vec2ChannelSplitNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec2ChannelSplitNodeData: NodeData
{
    override class var defaultTitle: String { return "Vec2 Split (float x = v.x, y = v.y)" }
    override class var defaultCanHavePreview: Bool { return false }
    override class var defaultPreviewOutportIndex: Int { return -1 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "Vector")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "X"),
            FloatNodePortData(title: "Y")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = \(inPorts[0].getPortVariableName()).x;
        \(outPorts[1].requiredType.defaultCGType) \(outPorts[1].getPortVariableName()) = \(inPorts[0].getPortVariableName()).y;
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return super.shaderFinalColorExperssion()
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Packer
    }
}
