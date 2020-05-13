import UIKit

@objc(FloatRayDiscNodeData) class FloatRayDiscNodeData: NodeData
{
    override class var defaultTitle: String { return "Float Disc Ray" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "Atan"),
            FloatNodePortData(title: "Fill Rate"),
            FloatNodePortData(title: "Ray Num 1"),
            FloatNodePortData(title: "Ray Num 2"),
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
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = smoothstep(0.0,2.0,smoothstep(10.0 * (1.0 - \(inPorts[1].getPortVariableName())), 0.5, sin(\(inPorts[0].getPortVariableName()) * \(inPorts[2].getPortVariableName()) + u_time)* 1.0 + cos(\(inPorts[0].getPortVariableName()) * \(inPorts[3].getPortVariableName()))* 1.0));
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
