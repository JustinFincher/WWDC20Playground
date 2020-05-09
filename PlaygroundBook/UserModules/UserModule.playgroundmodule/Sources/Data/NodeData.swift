import Foundation
import UIKit

public enum NodeType : String
{
    case Generator
    case Consumer
    case Modifier
    case Packer
    case Calculator
}

@objc public class NodeData: NSObject
{
    weak var graph : NodeGraphData? = nil
    weak var node : NodeView? = nil
        
    class var defaultCanHavePreview: Bool { return false }
    class var defaultPreviewOutportIndex: Int { return -1 }
    class var defaultTitle: String { return "" }
    class var defaultSize: CGSize { return CGSize.init(width: Constant.nodeWidth,height: 0) }
    class var customViewHeight: CGFloat { return 0 }
    class var defaultInPorts: Array<NodePortData> { return [] }
    class var defaultOutPorts: Array<NodePortData> { return [] }
    
    var index : String = ""
    {
        didSet
        {
            var portIndex : Int = 0
            for nodePort in inPorts + outPorts
            {
                nodePort.node = self
                nodePort.index = "\(nodePort.node!.index)_\(portIndex)"
                portIndex += 1
            }
        }
    }
    var title : String = ""
    var frame : CGRect = CGRect.init(x: 0, y: 0, width: defaultSize.width, height: defaultSize.height)
    var selected : Bool = false
    var inPorts : Array<NodePortData> = []
    var outPorts : Array<NodePortData> = []
    var previewOutportIndex : Int = -1
    var isSelected : Bool = false
    var hasPreview : Bool = false
    var customViewHeight : CGFloat = 0
    
    required override init()
    {
        super.init()
        title = type(of: self).defaultTitle
        inPorts = type(of: self).defaultInPorts
        outPorts = type(of: self).defaultOutPorts
        previewOutportIndex = type(of: self).defaultPreviewOutportIndex
        hasPreview = type(of: self).defaultCanHavePreview
        customViewHeight = type(of: self).customViewHeight
        
        let width : CGFloat = Constant.nodeWidth
        let height : CGFloat = Constant.nodePadding +
            Constant.nodeTitleHeight +
            (customViewHeight > 0 ? Constant.nodePadding : 0) +
            customViewHeight +
            (max(inPorts.count, outPorts.count) > 0 ? Constant.nodePadding : 0) +
            Constant.nodePortHeight * CGFloat(max(inPorts.count, outPorts.count)) +
            (hasPreview ? Constant.nodePadding : 0) +
            (hasPreview ? (Constant.nodeWidth - Constant.nodePadding * 2) : 0) +
            Constant.nodePadding
        let size : CGSize = CGSize.init(width: width, height: height)
        frame = CGRect.init(origin: frame.origin, size: size)
    }
    
    // single node shader block, need to override
    func singleNodeExpressionRule() -> String
    {
        return ""
    }
    
    // combined shader blocks only, do not override
    var shaderBlocksCombinedExpression : String = ""
    {
        didSet
        {
            print(shaderBlocksCombinedExpression)
        }
    }
    
    // preview shader expression gl_FragColor only, need to override
    func shaderFinalColorExperssion() -> String
    {
        let zero : Float = 0;
        return String(format: "gl_FragColor = vec4(%.8f,%.8f,%.8f,%.8f);",zero,zero,zero,zero)
    }
    
    func previewShaderExperssion() -> String
    {
        return String(format:
            """
                void main() {
                %@
                %@
                } // From Node %@
            """,
                      shaderBlocksCombinedExpression,
                      shaderFinalColorExperssion(),
                      index)
    }
    
    func isSingleNode() -> Bool
    {
        return graph?.singleNodes.contains(self) ?? false
    }
    
    func shaderCommentHeader() -> String
    {
        return "\n// \(type(of: self)) Index \(index)\n"
    }
    
    func declareInPortsExpression() -> String
    {
        var expression = ""
        inPorts.forEach { (data) in
            if data.connections.count > 0, let first = data.connections.first
            {
                expression.append(first.expressionRule())
            }else
            {
                expression.append(data.getPortDefaultValueExpression())
            }
            expression.append("\n")
        }
        return expression
    }
    
    func breakAllConnections(clearPorts: Bool) -> Void
    {
        inPorts.forEach { (portData) in
            portData.breakAllConnections()
        }
        outPorts.forEach { (portData) in
            portData.breakAllConnections()
        }
        
        if clearPorts
        {
            inPorts.removeAll()
            outPorts.removeAll()
        }
    }
    
    class func nodeType() -> NodeType
    {
        return NodeType.Generator
    }
    
    func setupCustomView(view: UIView) -> Void
    {
        
    }
    
}
