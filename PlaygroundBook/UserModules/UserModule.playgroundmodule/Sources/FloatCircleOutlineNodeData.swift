//
//  FloatCircleOutlineNodeData.swift
//  PlaygroundBook
//
//  Created by fincher on 5/13/20.
//
import UIKit

@objc(FloatCircleOutlineNodeData) class FloatCircleOutlineNodeData: NodeData
{
    override class var defaultTitle: String { return "Float Circle Outline" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "Value"),
            FloatNodePortData(title: "In Radius"),
            FloatNodePortData(title: "Out Radius")
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
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = smoothstep(\(inPorts[0].getPortVariableName()),\(inPorts[0].getPortVariableName()),length(vec2(0.5)-v_tex_coord)*2.0 - \(inPorts[1].getPortVariableName())) - smoothstep(\(inPorts[0].getPortVariableName()),\(inPorts[0].getPortVariableName()),length(vec2(0.5)-v_tex_coord)*2.0 - \(inPorts[2].getPortVariableName()));
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
        return NodeType.Consumer
    }
}
