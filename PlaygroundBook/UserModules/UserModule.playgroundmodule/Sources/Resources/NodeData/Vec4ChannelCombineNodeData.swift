//
//  Vec4ColorNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec4ChannelCombineNodeData: NodeData
{
    override class var defaultTitle: String { return "Vec4 Combine (vec4 c = vec4(r,g,b,a))" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "R"),
            FloatNodePortData(title: "G"),
            FloatNodePortData(title: "B"),
            FloatNodePortData(title: "A")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec4NodePortData(title: "Color")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = vec4(\(inPorts[0].getPortVariableName()),\(inPorts[1].getPortVariableName()),\(inPorts[2].getPortVariableName()),\(inPorts[3].getPortVariableName()));
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = \(outPorts[0].getPortVariableName());")
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Packer
    }
}
