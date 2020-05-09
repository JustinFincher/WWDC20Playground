import UIKit

open class NodeEditorViewController: UIViewController, NodeListTableViewControllerSelectDelegate, NodeGraphViewDelegate, NodeGraphViewDataSource
{

    let nodeEditorData : NodeGraphData = NodeGraphData()
    let nodeEditorView : NodeGraphScrollView = NodeGraphScrollView(frame: CGRect.zero, canvasSize: CGSize.init(width: 2000, height: 2000))
    let loadingIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        AudioUniformProviderManager.shared.requestPermission()
        
        loadingIndicator.frame = CGRect.init(origin: CGPoint.init(x:
            (self.view.frame.size.width - loadingIndicator.frame.size.width)/2.0, y:
            (self.view.frame.size.height - loadingIndicator.frame.size.height)/2.0), size: loadingIndicator.frame.size)
        loadingIndicator.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        
        self.title = "Shader Node Editor"
        nodeEditorView.frame = self.view.bounds
        nodeEditorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nodeEditorView.isUserInteractionEnabled = false
        nodeEditorView.alpha = 0.0
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
        
        DispatchQueue.global(qos: .background).async
            {
                print("warmUp +")
                NodeInfoCacheManager.shared.warmUp()
                DispatchQueue.main.async
                    {
                        print("warmUp -")
                        self.nodeEditorView.isUserInteractionEnabled = true
                        UIView.animate(withDuration: 0.5, animations: {
                            self.nodeEditorView.alpha = 1.0
                        })
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

