import UIKit

class ShaderFloatType: ShaderDataType
{
    override class var defaultCGType : String { return "float" }
    override class var defaultCGValue : String { return "0.0" }
}
