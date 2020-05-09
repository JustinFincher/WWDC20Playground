import Foundation
import UIKit

public class NodeGraphDrawRectView: UIView, NodeGraphContainerViewDataSource
{
    weak var nodeGraphView : NodeGraphView?
    
    var dragging : Bool = false
    var position : CGPoint = CGPoint.zero
    weak var draggingRelatedPortView : NodePortView? = nil
    
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
    
    func postInit() -> Void
    {
        isUserInteractionEnabled = false
        isOpaque = false
        backgroundColor = UIColor.clear
    }

    override public func draw(_ rect: CGRect)
    {
        guard let nodeGraphView : NodeGraphView = nodeGraphView,
            let nodeContainerView = nodeGraphView.containerView,
            let nodeGraphDataSource = nodeGraphView.dataSource
            else
        {
            return
        }
        var lineColor : UIColor = UIColor.white
        if let draggingRelatedPortView : NodePortView = draggingRelatedPortView,
            let dragginRelativePortData : NodePortData = draggingRelatedPortView.data,
            dragging
        {
            var canConnect : Bool = false
            
            let dragStartPos = nodeContainerView.convert(draggingRelatedPortView.getknotIndicatorPointRelativeToNodeView(), from: draggingRelatedPortView.nodeView)
            let dragEndPos = position
            
            let connectionInPos = dragginRelativePortData.isInPortRelativeToConnection() ? dragStartPos : dragEndPos
            let connectionOutPos = dragginRelativePortData.isInPortRelativeToConnection() ? dragEndPos : dragStartPos
            canConnect = nodeGraphDataSource.canConnectPointIn(graphView: nodeGraphView, nodeOutPort: connectionInPos, nodeInPort: connectionOutPos)
            lineColor = canConnect ? UIColor.green.withAlphaComponent(0.6) : UIColor.red.withAlphaComponent(0.6)
            drawLineConnection(inPoint: connectionInPos, outPoint: connectionOutPos, color: lineColor, width: 8.0)
        }
        
        lineColor = UIColor.yellow.withAlphaComponent(0.6)
        nodeGraphView.dataSource?.allNodeData().forEach({ (connectionOutNodeData) in
            connectionOutNodeData.inPorts.forEach({ (connectionOutNodePortData) in
                connectionOutNodePortData.connections.forEach({ (nodeConnectioData) in
                    if let connectionInNodeData : NodeData = nodeConnectioData.inPort.node,
                        let connectionInNodeView : NodeView = nodeGraphView.containerView?.getNodeView(index: connectionInNodeData.index),
                        let connectionOutNodeView : NodeView = nodeGraphView.containerView?.getNodeView(index: connectionOutNodeData.index),
                        let connectionInNodePortView : NodePortView = connectionInNodeView.ports.filter({ $0.data?.index == nodeConnectioData.inPort.index }).first,
                        let connectionOutNodePortView : NodePortView = connectionOutNodeView.ports.filter({ $0.data?.index == nodeConnectioData.outPort.index }).first
                    {
                        let connectionInPos = nodeContainerView.convert(connectionInNodePortView.getknotIndicatorPointRelativeToNodeView(), from: connectionInNodeView)
                        let connectionOutPos = nodeContainerView.convert(connectionOutNodePortView.getknotIndicatorPointRelativeToNodeView(), from: connectionOutNodeView)
                        drawLineConnection(inPoint: connectionInPos, outPoint: connectionOutPos, color: lineColor, width: 5.0)
                    }
                })
            })
        })
        
    }
    
    func drawLineConnection(inPoint:CGPoint,outPoint:CGPoint,color:UIColor,width:CGFloat) -> Void
    {
        let path : UIBezierPath = UIBezierPath.init()
        color.set()
        path.lineWidth = width
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.move(to: inPoint)
        path.addCurve(to: outPoint,
                      controlPoint1: inPoint.applyOffset(x: Constant.nodeConnectionCurveControlOffset, y: 0),
                      controlPoint2: outPoint.applyOffset(x: -Constant.nodeConnectionCurveControlOffset, y: 0))
        path.stroke()
        
    }
    
    func reloadData() -> Void {
        
    }
    
    // MARK : - NodeGraphContainerViewDataSource
    public func selectedNodeCurrentInteractiveState(point: CGPoint, dragging: Bool, fromNode: NodePortView?)
    {
        self.dragging = dragging
        self.position = point
        draggingRelatedPortView = fromNode
        setNeedsDisplay()
    }
}
