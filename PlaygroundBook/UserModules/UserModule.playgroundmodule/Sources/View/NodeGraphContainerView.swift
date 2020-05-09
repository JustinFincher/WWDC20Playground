import Foundation
import UIKit

public protocol NodeGraphContainerViewDelegate: AnyObject
{
    func nodeMoved(nodeGraphContainerView: NodeGraphContainerView) -> Void
    func showNodeList(nodeGraphContainerView: NodeGraphContainerView,location:CGPoint) -> Void
}

public protocol NodeGraphContainerViewDataSource: AnyObject
{
    func selectedNodeCurrentInteractiveState(point: CGPoint, dragging: Bool, fromNode: NodePortView?) -> Void
}

public class NodeGraphContainerView: UIView
{
    weak var delegate: NodeGraphContainerViewDelegate?
    weak var datasource : NodeGraphContainerViewDataSource?
    weak var nodeGraphView : NodeGraphView?
    var dynamicAnimator : UIDynamicAnimator?
    private var dynamicItemBehavior : UIDynamicItemBehavior = UIDynamicItemBehavior(items: [])
    private var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items: [])
    private var longPress: UILongPressGestureRecognizer?
    private var tap: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.postInit()
    }
    
    required init(frame: CGRect, nodeGraphView: NodeGraphView)
    {
        super.init(frame: frame)
        self.nodeGraphView = nodeGraphView
        self.postInit()
    }
    
    func getNodeView(index : String) -> NodeView?
    {
        let nodeViews = self.subviews.filter{$0 is NodeView}.compactMap{$0 as? NodeView}
        return nodeViews.filter({$0.data?.index == index}).first
    }
    
    func postInit() -> Void
    {
        backgroundColor = UIColor.clear
        dynamicAnimator = UIDynamicAnimator(referenceView: self)
        
        guard let dynamicAnimator = dynamicAnimator else
        {
            return
        }
        
        dynamicItemBehavior.allowsRotation = false
        dynamicItemBehavior.friction = 1000
        dynamicItemBehavior.elasticity = 0.9
        dynamicItemBehavior.resistance = 0.7
        dynamicItemBehavior.action = { [weak self] in
            guard let self = self else { return }
            let nodeViews = self.subviews.filter{$0 is NodeView}.compactMap{$0 as? NodeView}
            for view : NodeView in nodeViews
            {
                view.updateNode()
            }
            self.delegate?.nodeMoved(nodeGraphContainerView: self)
        }
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        collisionBehavior.collisionMode = .boundaries
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.action = { [weak self] in
            guard let self = self else { return }
            let nodeViews = self.subviews.filter{$0 is NodeView}.compactMap{$0 as? NodeView}
            for view : NodeView in nodeViews
            {
                view.updateNode()
            }
            self.delegate?.nodeMoved(nodeGraphContainerView: self)
        }
        dynamicAnimator.addBehavior(collisionBehavior)
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        if let longPress = longPress,
            let tap = tap
        {
            self.addGestureRecognizer(longPress)
            self.addGestureRecognizer(tap)
        }
    }
    @objc func handleTap(recognizer : UITapGestureRecognizer) -> Void
    {
        self.becomeFirstResponder()
    }
    @objc func handleLongPress(recognizer : UILongPressGestureRecognizer) -> Void
    {
        switch recognizer.state
        {
        case .began:
            recognizer.state = .ended
            let point = recognizer.location(in: self)
            delegate?.showNodeList(nodeGraphContainerView: self, location: point)
            break
        default: break
        }
    }
    
    @objc func handleKnotPan(recognizer : UIPanGestureRecognizer) -> Void
    {
        if let view = recognizer.view,
            view.isKind(of: NodePortKnotView.self),
            let knot : NodePortKnotView = view as? NodePortKnotView,
            var portView : NodePortView = NodePortView.getSelfFromKnot(knot: knot),
            let originalPortView : NodePortView = portView
        {
            let point : CGPoint = recognizer.location(in: self)
            // when remove connection from in-port, portview.data.connection is 1 and portview is inport
            let shouldProxyingNodeInReverseDirection : Bool = portView.data?.connections.count == 1 && !portView.isOutPort
            if shouldProxyingNodeInReverseDirection,
                let proxyingNodeView : NodeView = portView.data?.connections.first?.inPort.node?.node,
                let proxyingNodePortView : NodePortView = proxyingNodeView.ports.filter({$0.data?.index == portView.data?.connections.first?.inPort.index}).first
            {
                portView = proxyingNodePortView
            }
            
            switch recognizer.state
            {
            case .began, .changed:
                datasource?.selectedNodeCurrentInteractiveState(point: point, dragging: true, fromNode: portView)
                break
            case .ended:
                if shouldProxyingNodeInReverseDirection,
                    let connectionToRemove = originalPortView.data?.connections.first
                {
                    nodeGraphView?.dataSource?.breakConnection(connection: connectionToRemove)
                }
                if  let portViewToConnect = getPortViewFrom(point: point),
                    let portViewData = portView.data,
                    let portViewToConnectData = portViewToConnect.data,
                    let graphDataSource = nodeGraphView?.dataSource
                {
                    if portViewData.isInPortRelativeToConnection() &&
                        portViewToConnectData.isOutPortRelativeToConnection() &&
                        graphDataSource.canConnectNode(outPort: portViewData, inPort: portViewToConnectData)
                    {
                        graphDataSource.connectNode(outPort: portViewData, inPort: portViewToConnectData)
                    }else if portViewData.isOutPortRelativeToConnection() &&
                        portViewToConnectData.isInPortRelativeToConnection() &&
                        graphDataSource.canConnectNode(outPort: portViewToConnectData, inPort: portViewData)
                    {
                        graphDataSource.connectNode(outPort: portViewToConnectData, inPort: portViewData)
                    }
                }
                datasource?.selectedNodeCurrentInteractiveState(point: point, dragging: false, fromNode: nil)
                break
            case .cancelled, .failed:
                datasource?.selectedNodeCurrentInteractiveState(point: point, dragging: false, fromNode: nil)
                break
            default:
                break
            }
        }
    }
    
    func reloadData() -> Void
    {
        let nodeViews = self.subviews.filter{$0 is NodeView}.compactMap{$0 as? NodeView}
        for view : NodeView in nodeViews
        {
            self.collisionBehavior.removeItem(view)
            self.dynamicItemBehavior.removeItem(view)
            view.nodeViewSelectedHandler = nil
            view.data?.frame = view.frame
            view.removeFromSuperview()
        }
        guard let nodeGraphView = self.nodeGraphView, let dataSource = nodeGraphView.dataSource else
        {
            return
        }
        let count : Int = dataSource.numberOfNodes(in: nodeGraphView)
        for i in 0 ..< count
        {
            guard let nodeView = dataSource.nodeGraphView(nodeGraphView: nodeGraphView, nodeWithIndex: "\(i)") else
            {
                // WTF?
                continue
            }
            nodeView.nodeViewSelectedHandler = { [weak self] in
                guard let self = self else { return }
                self.subviews.filter{$0 is NodeView}.compactMap{$0 as? NodeView}.forEach({ [weak nodeView] (eachNodeView) in
                    guard let nodeView = nodeView else { return }
                    eachNodeView.data?.isSelected = eachNodeView.data?.index == nodeView.data?.index
                    eachNodeView.updateNode()
                })
            }
            self.addSubview(nodeView)
            
            // TODO add recogiser
            if let nodePan = nodeView.pan, let nodeLongPress = nodeView.longPress
            {
                self.nodeGraphView?.parentScrollView?.panGestureRecognizer.require(toFail: nodePan)
                self.nodeGraphView?.parentScrollView?.panGestureRecognizer.require(toFail: nodeLongPress)
                self.nodeGraphView?.parentScrollView?.pinchGestureRecognizer!.require(toFail: nodePan)
                self.nodeGraphView?.parentScrollView?.pinchGestureRecognizer!.require(toFail: nodeLongPress)
                self.longPress?.require(toFail: nodePan)
                self.longPress?.require(toFail: nodeLongPress)
            }
            self.dynamicItemBehavior.addItem(nodeView)
            self.collisionBehavior.addItem(nodeView)
        }
        self.delegate?.nodeMoved(nodeGraphContainerView: self)
    }
    
    func getPortKnotViewFrom(point : CGPoint) -> NodePortKnotView?
    {
        if let hitView = hitTest(point, with: nil), hitView.isKind(of: NodePortKnotView.self)
        {
            return hitView as? NodePortKnotView
        }
        return nil
    }
    
    func getPortViewFrom(point: CGPoint) -> NodePortView?
    {
        if let knot = getPortKnotViewFrom(point: point), let portView = NodePortView.getSelfFromKnot(knot: knot)
        {
            return portView
        }
        return nil
    }
    
    public override var canBecomeFirstResponder: Bool
    {
        return true
    }
}
