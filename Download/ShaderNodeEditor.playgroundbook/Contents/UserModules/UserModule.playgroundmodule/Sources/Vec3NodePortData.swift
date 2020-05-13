import UIKit

class Vec3NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec3" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec3Type.self }
}
