import UIKit

class ShaderVec2Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec2" }
    override class var defaultCGValue : String { return "vec2(0.0)" }
}
