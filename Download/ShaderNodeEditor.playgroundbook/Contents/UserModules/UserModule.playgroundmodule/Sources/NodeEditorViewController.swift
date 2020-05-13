import UIKit

open class NodeEditorViewController: UIViewController, NodeListTableViewControllerSelectDelegate, NodeGraphViewDelegate, NodeGraphViewDataSource
{

    let nodeEditorData : NodeGraphData = NodeGraphData()
    let nodeEditorView : NodeGraphScrollView = NodeGraphScrollView(frame: CGRect.zero, canvasSize: CGSize.init(width: 2000, height: 2000))
    let alert = UIAlertController(title: "\nLoading...", message: "Finding data models for all nodes, need 10 seconds", preferredStyle: .alert)
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGroupedBackground
        
        AudioUniformProviderManager.shared.requestPermission()
        
        self.title = "Shader Node Editor"
        nodeEditorView.frame = self.view.bounds
        nodeEditorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(nodeEditorView)
        
        if let nodeGraphView : NodeGraphView = nodeEditorView.nodeGraphView
        {
            nodeGraphView.delegate = self;
            nodeGraphView.dataSource = self;
            nodeGraphView.reloadData()
            
            nodeEditorData.nodeGraphDataUpdatedHandler = {
                DispatchQueue.main.async {
                    nodeGraphView.reloadData()
                }
            }
        }
        
        if (Constant.useReflectionToGetNodeList && !NodeInfoCacheManager.shared.isNodeListLoaded())
        {
            nodeEditorView.isUserInteractionEnabled = false
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.alpha = 0
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: {
                UIView.animate(withDuration: 0.5, animations: {
                    loadingIndicator.alpha = 1
                })
                loadingIndicator.frame = CGRect(x: (self.alert.view.frame.width - 50) / 2.0, y: 0, width: 50, height: 50)
            })

            DispatchQueue.global(qos: .background).async
                {
                    var nodeClassNames : Array<String> = []
                    NodeInfoCacheManager.shared.reload(force: false, blankArr:&nodeClassNames, useReflection: Constant.useReflectionToGetNodeList)
                    DispatchQueue.main.async
                        {
                            self.nodeEditorView.isUserInteractionEnabled = true
                            if let vc = self.presentedViewController, vc is UIAlertController { self.dismiss(animated: true, completion: nil)
                            }
                    }
            }
        }
    }
    
    public func nodeGraphView(nodeGraphView: NodeGraphView, nodeWithIndex: String) -> NodeView?
    {
        if let nodeData = nodeEditorData.getNode(index: nodeWithIndex), let containerView = nodeGraphView.containerView
        {
            let nodeView : NodeView = NodeView(frame: nodeData.frame, data: nodeData, parent: containerView)
            return nodeView
        }else
        {
            return nil
        }
    }
    
    public func numberOfNodes(in: NodeGraphView) -> Int {
        return nodeEditorData.getNodesTotalCount()
    }
    
    public func nodeGraphView(nodeGraphView: NodeGraphView, frameForNodeWithIndex: String) -> CGRect
    {
        guard let nodeData = nodeEditorData.getNode(index: frameForNodeWithIndex) else {
            return CGRect.zero
        }
        return nodeData.frame
    }
    
    public func requiredViewController() -> NodeEditorViewController
    {
        return self
    }
    
    public func allNodeData() -> Array<NodeData> {
        return nodeEditorData.allNodeData()
    }
    
    public func canConnectNode(outPort: NodePortData, inPort: NodePortData) -> Bool
    {
        return nodeEditorData.canConnectNode(outPort:outPort ,inPort: inPort)
    }
    
    public func connectNode(outPort: NodePortData, inPort: NodePortData) -> Void
    {
        nodeEditorData.connectNode(outPort:outPort,inPort:inPort)
    }
    
    public func breakConnection(connection: NodeConnectionData) {
        nodeEditorData.breakConnection(connection: connection)
    }
    
    public func canConnectPointIn(graphView: NodeGraphView, nodeOutPort: CGPoint, nodeInPort: CGPoint) -> Bool
    {
        if let outPortView = graphView.containerView?.getPortViewFrom(point: nodeOutPort),
            let inPortView = graphView.containerView?.getPortViewFrom(point: nodeInPort),
            let outPortViewData = outPortView.data,
            let inPortViewData = inPortView.data,
            canConnectNode(outPort: outPortViewData, inPort: inPortViewData)
        {
            return true
        }
        return false
    }
    
    public func delete(node: NodeData)
    {
        nodeEditorData.removeNode(node: node)
    }
    
    // MARK: - NodeListTableViewControllerSelectDelegate
    public func nodeClassSelected(controller: NodeListTableViewController, nodeDataClass: AnyClass, point: CGPoint)
    {
        let nodeDataType = nodeDataClass as! NodeData.Type
        let nodeData = nodeDataType.init()
        
        let x = point.x - nodeData.frame.size.width / 2.0 > 8 ? point.x - nodeData.frame.size.width / 2.0 : 8
        let y = point.y - nodeData.frame.size.height / 2.0 > 8 ? point.y - nodeData.frame.size.height / 2.0 : 8
        let rect : CGRect = CGRect.init(x: x,
                                        y: y,
                                        width: nodeData.frame.size.width,
                                        height: nodeData.frame.size.height)
        
        nodeData.frame = rect
        nodeEditorData.addNode(node: nodeData)
    }
}

