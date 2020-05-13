import Foundation

public class NodePortData: NSObject
{
    weak var node : NodeData? = nil
    
    class var defaultTitle : String { return "" }
    class var defaultRequiredType : ShaderDataType.Type { return ShaderDataType.self }
    
    var index : String = ""
    var title : String = defaultTitle
    var connections : Set<NodeConnectionData> = []
    var requiredType : ShaderDataType.Type = defaultRequiredType
    
    required override public init() {
        super.init()
        title = type(of: self).defaultTitle
        requiredType = type(of: self).defaultRequiredType
    }
    
    public convenience init(title : String)
    {
        self.init()
        self.title = title
        requiredType = type(of: self).defaultRequiredType
    }
    
    func getPortDefaultValueExpression() -> String
    {
        return requiredType.defaultCGType + " " + getPortVariableName() + " = " + requiredType.defaultCGValue + ";"
    }
    
    func getPortVariableName() -> String
    {
        return "var_\(index)"
    }
    
    func breakAllConnections() -> Void
    {
        for connection in connections
        {
            if connection.inPort != self
            {
                connection.inPort.connections.remove(connection)
            }
            if connection.outPort != self
            {
                connection.outPort.connections.remove(connection)
            }
            
            connections.remove(connection)
        }
    }
    
    func isInPortRelativeToNode() -> Bool
    {
        guard let node = node else { return false }
        return node.inPorts.contains(self)
    }
    
    func isOutPortRelativeToNode() -> Bool
    {
        guard let node = node else { return false }
        return node.outPorts.contains(self)
    }
    
    func isInPortRelativeToConnection() -> Bool
    {
        return isOutPortRelativeToNode()
    }
    
    func isOutPortRelativeToConnection() -> Bool
    {
        return isInPortRelativeToNode()
    }
}
