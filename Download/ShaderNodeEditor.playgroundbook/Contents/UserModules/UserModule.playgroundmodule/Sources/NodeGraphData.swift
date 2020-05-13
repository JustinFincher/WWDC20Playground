import Foundation

public class UpdateDictOperation: Operation
{
    var singleNodes: Set<NodeData>?
    var outDict:Dictionary<String,NodeData> = [:]
    
    override public func main()
    {
        guard let singleNodes = singleNodes else { return }
        outDict.removeAll()
        updateNodeRelations(singleNodes: singleNodes, dict: &outDict)
        updateNodeShaderText(singleNodes: singleNodes, dict: outDict)
    }
    
    private func updateNodeRelations(singleNodes: Set<NodeData>, dict: inout Dictionary<String,NodeData>) -> Void
    {
        for node in singleNodes
        {
            dfsNodeRelation(node: node, dict: &dict)
        }
    }
    
    private func dfsNodeRelation(node: NodeData?, dict: inout Dictionary<String,NodeData>)
    {
        guard let node = node else { return }
        
        if !dict.values.contains(node)
        {
            node.index = "\(dict.count)"
            dict.updateValue(node, forKey: node.index)
        }
        
        for nodeInPort in node.inPorts
        {
            for nodeConnection in nodeInPort.connections
            {
                dfsNodeRelation(node: nodeConnection.inPort.node, dict: &dict)
            }
        }
    }
    
    private func updateNodeShaderText(singleNodes: Set<NodeData>, dict : Dictionary<String,NodeData>) -> Void
    {
        for singleNode in singleNodes
        {
            var shaderListDict : Dictionary<String,Array<String>> = [:]
            dfsNodeShaderText(node: singleNode, shaderListDict: &shaderListDict)
            
            for (nodeIndex, nodeShaderBlocksList) in shaderListDict
            {
                guard let nodeData = dict[nodeIndex] else { continue }
                if type(of: nodeData).defaultCanHavePreview
                {
                    nodeData.shaderBlocksCombinedExpression = nodeShaderBlocksList.joined(separator: "\n")
                }else
                {
                    nodeData.shaderBlocksCombinedExpression = ""
                }
            }
            
        }
        
    }
    
    private func dfsNodeShaderText(node: NodeData?, shaderListDict: inout Dictionary<String,Array<String>>) -> Void
    {
        guard let node = node else { return }
        
        // add new index in the global list
        if !shaderListDict.keys.contains(node.index)
        {
            shaderListDict.updateValue(Array<String>(), forKey:node.index)
        }
        
        // loop current list and for each add the current shader block
        for (key, nodeShaderBlocksList) in shaderListDict
        {
            var nodeShaderBlocksList : Array<String> = nodeShaderBlocksList
            if nodeShaderBlocksList.contains(node.singleNodeExpressionRule())
            {
                // remove for later add, making the required reference always at the top
                nodeShaderBlocksList.removeAll { $0 == node.singleNodeExpressionRule() }
            }
            nodeShaderBlocksList.insert(node.singleNodeExpressionRule(), at: 0)
            shaderListDict.updateValue(nodeShaderBlocksList, forKey:key)
        }
        
        for nodeInPort in node.inPorts {
            for nodeConnection in nodeInPort.connections
            {
                dfsNodeShaderText(node: nodeConnection.inPort.node, shaderListDict: &shaderListDict)
            }
        }
    }
}

public class NodeGraphData: NSObject
{
    var singleNodes : Set<NodeData> = []
    private var indexNodeDataDict : Dictionary<String,NodeData> = [:]
    var updateDictOperation : UpdateDictOperation?
    let updateDictOperationQuene : OperationQueue = OperationQueue()
    var nodeGraphDataUpdatedHandler: (() -> Void)?
    
    public override init()
    {
        super.init()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constant.notificationNameShaderModified), object: nil, queue: OperationQueue.main) { (notif) in
                   self.updateIndexNodeDataDict()
        }
        updateIndexNodeDataDict()
    }
    
    func getNodesTotalCount() -> Int
    {
        return indexNodeDataDict.count
    }
    
    func getNode(index: String) -> NodeData?
    {
        return indexNodeDataDict[index]
    }
    
    func addNode(node: NodeData) -> Void
    {
        node.graph = self
        node.index = NSNumber(integerLiteral: getNodesTotalCount()).stringValue
        singleNodes.insert(node)
        updateIndexNodeDataDict()
    }
    
    func allNodeData() -> Array<NodeData>
    {
        return indexNodeDataDict.values.filter({ (data) -> Bool in
            return true
        })
    }
    
    func removeNode(node: NodeData) -> Void
    {
        if singleNodes.contains(node)
        {
            self.singleNodes.remove(node)
        }
        for portData : NodePortData in node.inPorts
        {
            for connectionData : NodeConnectionData in portData.connections
            {
                let connectedNodeData : NodeData! = connectionData.inPort?.node
                if connectedNodeData != nil
                {
                    singleNodes.insert(connectedNodeData)
                }
            }
        }
        node.breakAllConnections(clearPorts: true)
        updateIndexNodeDataDict()
    }
    
    func canConnectNode(outPort:NodePortData, inPort:NodePortData) -> Bool
    {
        let can : Bool = (outPort.isOutPortRelativeToNode() &&
            inPort.isInPortRelativeToNode() &&
            inPort.connections.count == 0 &&
            outPort.node?.index != inPort.node?.index &&
            outPort.requiredType.defaultCGType == inPort.requiredType.defaultCGType)
        
        return can
    }
    
    func connectNode(outPort:NodePortData, inPort:NodePortData) -> Void
    {
        let nodeConnection : NodeConnectionData = NodeConnectionData()
        nodeConnection.inPort = outPort
        nodeConnection.outPort = inPort
        
        inPort.connections.insert(nodeConnection)
        outPort.connections.insert(nodeConnection)
        
        if (singleNodes.contains(outPort.node!))
        {
            singleNodes.remove(outPort.node!)
        }
        updateIndexNodeDataDict()
    }
    
    func breakConnection(connection:NodeConnectionData) -> Void
    {
        connection.inPort.connections.remove(connection)
        connection.outPort.connections.remove(connection)
        if connection.inPort.connections.count == 0,
            let outPorts : Array<NodePortData> = connection.inPort.node?.outPorts
        {
            let nodeOutConnectionCount = outPorts.compactMap { (nodePortData) -> Int in
                nodePortData.connections.count
                }.reduce(0, +)
            if (nodeOutConnectionCount == 0)
            {
                singleNodes.insert(connection.inPort.node!)
            }
        }
        updateIndexNodeDataDict()
    }
    
    func removeAll() -> Void
    {
        indexNodeDataDict.values.forEach { (nodeData) in
            nodeData.inPorts.forEach({ (nodePortData) in
                nodePortData.connections.forEach({ (nodeConnectionData) in
                    breakConnection(connection: nodeConnectionData)
                })
            })
        }
        singleNodes.removeAll()
        updateIndexNodeDataDict()
    }
    
    func forceUpdate() -> Void
    {
        updateIndexNodeDataDict()
    }
    
    private func updateIndexNodeDataDict() -> Void
    {
        if let oldUpdateDictOperation = updateDictOperation
        {
            if (oldUpdateDictOperation.isExecuting)
            {
                oldUpdateDictOperation.cancel()
            }
        }
        self.updateDictOperation = UpdateDictOperation()
        guard let updateDictOperation = updateDictOperation else
        {
            return
        }
        updateDictOperation.singleNodes = singleNodes
        updateDictOperation.completionBlock =
            {
                self.indexNodeDataDict = updateDictOperation.outDict
                if let nodeGraphDataUpdatedHandler = self.nodeGraphDataUpdatedHandler
                {
                    nodeGraphDataUpdatedHandler()
                }
        }
        updateDictOperationQuene.addOperation(updateDictOperation)
    }
}
