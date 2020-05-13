import UIKit

class Vec4NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec4" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec4Type.self }
}
