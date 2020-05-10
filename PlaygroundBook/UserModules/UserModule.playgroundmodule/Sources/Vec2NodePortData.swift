import UIKit

class Vec2NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec2" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec2Type.self }
}
