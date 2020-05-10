import UIKit

class ShaderVec4Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec4" }
    override class var defaultCGValue : String { return "vec4(0.0)" }
}
