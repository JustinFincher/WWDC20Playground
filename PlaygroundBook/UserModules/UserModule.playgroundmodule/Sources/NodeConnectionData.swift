import Foundation

public class NodeConnectionData: NSObject
{
    var inPort : NodePortData! = nil;
    weak var outPort : NodePortData! = nil;
    
    func expressionRule() -> String
    {
        let outputRequiredCGType = outPort.requiredType.defaultCGType
        let outPortName = outPort.getPortVariableName()
        let inPortName = inPort.getPortVariableName()
        return "\(outputRequiredCGType) \(outPortName) = \(inPortName);"
    }
}
