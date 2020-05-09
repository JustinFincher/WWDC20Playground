//
//  Vec2ChannelCombineNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 19/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec2ChannelCombineNodeData: NodeData
{
    override class var defaultTitle: String { return "Vec2 Combine (vec2 r = vec2(x,y))" }
    override class var defaultCanHavePreview: Bool { return false }
    override class var defaultPreviewOutportIndex: Int { return -1 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "X"),
            FloatNodePortData(title: "Y")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "Result")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = vec2(\(inPorts[0].getPortVariableName()),\(inPorts[1].getPortVariableName()));
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
        return NodeType.Packer
    }
}

