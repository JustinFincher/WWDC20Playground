import UIKit

class FloatNodePortData: NodePortData
{
    override class var defaultTitle : String { return "Float" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderFloatType.self }
}
