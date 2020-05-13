import UIKit

class ShaderVec3Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec3" }
    override class var defaultCGValue : String { return "vec3(0.0)" }
}
