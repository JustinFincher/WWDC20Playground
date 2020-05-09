import UIKit

class NodeInfoCacheManager: NSObject
{
    static let shared = NodeInfoCacheManager()
    
    private var nodeClasses : Array<AnyClass> = []
    
    override init()
    {
        super.init()
        nodeClasses = NodeData.directSubclasses()
    }
    
    func getNodeClasses() -> Array<AnyClass>
    {
        return nodeClasses
    }
    
    func warmUp() -> Void
    {
        
    }
}
