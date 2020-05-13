import UIKit

@objc(FloatUVCenterAtanNodeData) class FloatUVCenterAtanNodeData: NodeData
{
    override class var defaultTitle: String { return "UV Center Atan (atan(uv-vec2(0.5)))" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData> { return [] }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "A")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = atan(0.5-v_tex_coord.y,0.5-v_tex_coord.x);
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
        return NodeType.Generator
    }
}
