import UIKit
import PlaygroundSupport

class NodeInfoCacheManager: NSObject
{
    static let shared = NodeInfoCacheManager()
    
    private var nodeClasses : Array<NodeData.Type> = []
    
    override init()
    {
        super.init()
    }
    
    func isNodeListLoaded() -> Bool {
        return nodeClasses.count > 0
    }
    
    func getNodeClasses() -> Array<NodeData.Type>
    {
        var nodeClassNames : Array<String> = []
        reload(force: false, blankArr: &nodeClassNames, useReflection: true)
        let list = nodeClassNames.compactMap{NSClassFromString($0) as? NodeData.Type}
        return list
    }
    
    func reload(force: Bool, blankArr: inout Array<String>, useReflection: Bool) -> Void
    {
        blankArr.removeAll()
        if let storedNamesRef = PlaygroundKeyValueStore.current["nodeClassNames"],
        case let PlaygroundValue.array(storedNames) = storedNamesRef
        {
                  blankArr = storedNames.compactMap
                      {
                          (strVal) -> String? in
                       if case let PlaygroundValue.string(str) = strVal { return str }; return nil
          }
                  }
        else if (useReflection)
        {
            blankArr = Helper.subclassNames(of: NodeData.self)
            print(blankArr.joined(separator: "\n"))
        }else
        {
            let filePath = Bundle.main.path(forResource:"NodeList", ofType: "txt")
            let contentData = FileManager.default.contents(atPath: filePath!)
            let content = String(data:contentData!, encoding:String.Encoding.utf8)!
            blankArr = content.split { $0.isNewline }.compactMap{String($0)}
        }
        PlaygroundKeyValueStore.current["nodeClassNames"] = PlaygroundValue.array(blankArr.map{PlaygroundValue.string($0)})
    }
}
