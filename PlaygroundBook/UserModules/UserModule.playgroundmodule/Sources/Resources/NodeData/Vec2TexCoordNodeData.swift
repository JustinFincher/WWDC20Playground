//
//  Vec2TexCoordNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec2TexCoordNodeData: NodeData {
    override class var defaultTitle: String { return "UV (vec2 v_tex_coord)" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return []
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "UV")
        ]
    }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = v_tex_coord;
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
        return NodeType.Generator
    }
}
