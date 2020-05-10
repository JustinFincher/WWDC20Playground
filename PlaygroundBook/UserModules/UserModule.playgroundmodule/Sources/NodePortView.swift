import UIKit

public class NodePortView: UIView
{
    let titleLabel : UILabel = UILabel(frame: CGRect.zero)
    let knot : NodePortKnotView = NodePortKnotView(frame: CGRect.zero)
    private let knotIndicator : UIView = UIView(frame: CGRect.zero)
    weak var data : NodePortData?
    weak var nodeView : NodeView?
    var isOutPort : Bool = false
    var panOnKnot : UIPanGestureRecognizer?
    
    required init(frame: CGRect, data: NodePortData, isOutPort: Bool, nodeView : NodeView)
    {
        super.init(frame: frame)
        self.data = data
        self.isOutPort = isOutPort
        self.nodeView = nodeView
        
        titleLabel.frame = CGRect.init(origin: CGPoint.init(x: isOutPort ? 0 : Constant.nodePortKnotWidth,
                                                            y: 0),
                                       size: CGSize.init(width: frame.size.width - Constant.nodePortKnotWidth,
                                                         height: frame.size.height))
        titleLabel.text = data.title;
        titleLabel.font = UIFont.init(name: Constant.fontBoldName, size: 10)
        titleLabel.textColor = UIColor.placeholderText.withAlphaComponent(0.8)
        titleLabel.textAlignment = isOutPort ? .right : .left
        addSubview(titleLabel)
        
        knot.frame = CGRect.init(origin: CGPoint.init(x: isOutPort ? frame.size.width - Constant.nodePortKnotWidth : 0,
                                                      y: 0),
                                 size: CGSize.init(width: Constant.nodePortKnotWidth,
                                                   height: Constant.nodePortHeight))
        addSubview(knot)
        
        panOnKnot = UIPanGestureRecognizer(target: self.nodeView?.graphContainerView, action: #selector(NodeGraphContainerView.handleKnotPan(recognizer:)))
        if let panOnKnot = panOnKnot
        {
            knot.addGestureRecognizer(panOnKnot)
        }
        
        knot.addSubview(knotIndicator)
        knotIndicator.frame = CGRect.init(origin: CGPoint.init(x: Constant.nodePortKnotWidth / 2 - Constant.nodePortHeight / 8,
                                                               y: Constant.nodePortHeight / 2 - Constant.nodePortHeight / 8),
                                          size: CGSize.init(width: Constant.nodePortHeight / 4,
                                                            height: Constant.nodePortHeight / 4))
        knotIndicator.layer.cornerRadius = Constant.nodePortHeight / 8
        knotIndicator.layer.masksToBounds = true
        knotIndicator.backgroundColor = Constant.nodeKnotIndicatorColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func getSelfFromKnot(knot: NodePortKnotView) -> NodePortView?
    {
        if let view : NodePortView = knot.getSuperView(typeClass: NodePortView.self) as? NodePortView
        {
            return view
        }
        return nil
    }
    
    func getknotIndicatorPointRelativeToNodeView() -> CGPoint
    {
        guard let nodeView = self.nodeView else {
            return CGPoint.zero
        }
        return nodeView.convert(knotIndicator.frame, from: knot).center()
    }
}
