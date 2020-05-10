import Foundation
import UIKit
import SpriteKit

public class NodeView: UIView, UIGestureRecognizerDelegate, UIContextMenuInteractionDelegate
{
    
    weak var data : NodeData?{
        didSet
        {
            guard let data = data else
            {
                self.subviews.forEach { (view) in
                    view.removeFromSuperview()
                }
                return
            }
            data.node = self
            titleLabel.text = data.title
            ports.removeAll()
            inPortsContainer.removeFromSuperview()
            outPortsContainer.removeFromSuperview()
            
            customView.removeFromSuperview()
            customView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            customView.frame = CGRect.init(origin: CGPoint.init(x: Constant.nodePadding,
                                                                y: Constant.nodePadding + Constant.nodeTitleHeight + Constant.nodePadding),
                                           size: CGSize.init(width: self.frame.size.width - Constant.nodePadding * 2,
                                                             height: data.customViewHeight))
            if data.customViewHeight > 0
            {
                data.setupCustomView(view: customView)
                visualEffectView.contentView.addSubview(customView)
            }
            
            let customViewHeightWithPadding : CGFloat =  data.customViewHeight > 0 ? (data.customViewHeight + Constant.nodePadding) : 0
            if data.inPorts.count != 0 && data.outPorts.count != 0
            {
                inPortsContainer.frame = CGRect.init(origin: CGPoint.init(x: Constant.nodePadding,
                                                                          y: Constant.nodePadding + Constant.nodeTitleHeight + Constant.nodePadding + customViewHeightWithPadding),
                                                     size: CGSize.init(width: (self.frame.size.width - Constant.nodePadding * 3) / 2.0,
                                                                       height: CGFloat(data.inPorts.count) * Constant.nodePortHeight))
                outPortsContainer.frame = CGRect.init(origin: CGPoint.init(x: (self.frame.size.width + Constant.nodePadding) / 2.0,
                                                                           y: Constant.nodePadding + Constant.nodeTitleHeight + Constant.nodePadding + customViewHeightWithPadding),
                                                      size: CGSize.init(width: (self.frame.size.width - Constant.nodePadding * 3) / 2.0,
                                                                        height: CGFloat(data.outPorts.count) * Constant.nodePortHeight))
            }else if (data.inPorts.count == 0 && data.outPorts.count != 0)
            {
                inPortsContainer.frame = CGRect.zero
                outPortsContainer.frame = CGRect.init(origin: CGPoint.init(x: Constant.nodePadding,
                                                                           y: Constant.nodePadding + Constant.nodeTitleHeight + Constant.nodePadding + customViewHeightWithPadding),
                                                      size: CGSize.init(width: self.frame.size.width - Constant.nodePadding * 2,
                                                                        height: CGFloat(data.outPorts.count) * Constant.nodePortHeight))
            }else if (data.inPorts.count != 0 && data.outPorts.count == 0)
            {
                inPortsContainer.frame = CGRect.init(origin: CGPoint.init(x: Constant.nodePadding,
                                                                          y: Constant.nodePadding + Constant.nodeTitleHeight + Constant.nodePadding + customViewHeightWithPadding),
                                                     size: CGSize.init(width: self.frame.size.width - Constant.nodePadding * 2,
                                                                       height: CGFloat(data.inPorts.count) * Constant.nodePortHeight))
                outPortsContainer.frame = CGRect.zero
            }else
            {
                inPortsContainer.frame = CGRect.zero
                outPortsContainer.frame = CGRect.zero
            }
            
            for i in 0..<data.inPorts.count
            {
                let nodePortView : NodePortView = NodePortView(frame: CGRect.init(x: 0,
                                                                                  y: CGFloat(i) * Constant.nodePortHeight,
                                                                                  width: inPortsContainer.frame.width,
                                                                                  height: Constant.nodePortHeight),
                                                               data: data.inPorts[i],
                                                               isOutPort: false,
                                                               nodeView: self)
                inPortsContainer.addSubview(nodePortView)
                if let pan = pan, let longPress = longPress, let knotPan = nodePortView.panOnKnot
                {
                    pan.require(toFail: knotPan)
                    longPress.require(toFail: knotPan)
                }
                ports.insert(nodePortView)
            }
            
            for i in 0..<data.outPorts.count
            {
                let nodePortView : NodePortView = NodePortView(frame: CGRect.init(x: 0,
                                                                                  y: CGFloat(i) * Constant.nodePortHeight,
                                                                                  width: outPortsContainer.frame.width,
                                                                                  height: Constant.nodePortHeight),
                                                               data: data.outPorts[i],
                                                               isOutPort: true,
                                                               nodeView: self)
                outPortsContainer.addSubview(nodePortView)
                if let pan = pan, let longPress = longPress, let knotPan = nodePortView.panOnKnot
                {
                    pan.require(toFail: knotPan)
                    longPress.require(toFail: knotPan)
                }
                ports.insert(nodePortView)
            }
            
            visualEffectView.contentView.addSubview(inPortsContainer)
            visualEffectView.contentView.addSubview(outPortsContainer)
            
            if let previewView = previewView
            {
                previewView.scene?.removeAllChildren()
                previewView.presentScene(nil)
                previewView.removeFromSuperview()
            }else if data.hasPreview
            {
                previewView = SKView(frame: CGRect.init(origin: CGPoint.init(x: Constant.nodePadding,
                                                                             y: self.frame.size.height - self.frame.size.width + Constant.nodePadding),
                                                        size: CGSize.init(width: self.frame.size.width - Constant.nodePadding * 2,
                                                                          height: self.frame.size.width - Constant.nodePadding * 2)))
                if let previewView = previewView
                {
                    let scene : SKScene = SKScene(size: CGSize.init(width: previewView.frame.size.width / 64.0, height: previewView.frame.size.height / 64.0))
                    scene.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
                    scene.scaleMode = .fill
                    let shaderNode : SKSpriteNode = SKSpriteNode(color: UIColor.black, size: scene.size)
                    let shader : SKShader = SKShader(source: data.previewShaderExperssion(),
                                                     uniforms: [AudioUniformProviderManager.shared.audioUniform])
                    shaderNode.shader = shader
                    scene.addChild(shaderNode)
                    previewView.presentScene(scene)
                    visualEffectView.contentView.addSubview(previewView)
                    previewView.layer.cornerRadius = 8
                    previewView.layer.masksToBounds = true
                    previewView.showsFPS = true
                }
            }
        }
    }
    weak var graphContainerView : NodeGraphContainerView?
    let visualEffectView : UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))
    var attachmentBehavior : UIAttachmentBehavior?
    var pushBehavior : UIPushBehavior?
    var ports : Set<NodePortView> = []
    var previewView : SKView?
    let customView : NodeValueCustomView = NodeValueCustomView(frame: CGRect.zero)
    
    
    var tap: UITapGestureRecognizer?
    var longPress : UILongPressGestureRecognizer?
    var pan : UIPanGestureRecognizer?
    
    var menuInteraction : UIContextMenuInteraction?
    
    let inPortsContainer : UIView = UIView(frame: CGRect.zero)
    let outPortsContainer : UIView = UIView(frame: CGRect.zero)
    let titleLabel : UILabel = UILabel(frame: CGRect.zero)
    
    var nodeViewSelectedHandler: (() -> Void)?
    
    var scaleAnimator : UIViewPropertyAnimator?
    
    required init(frame:CGRect, data:NodeData, parent:NodeGraphContainerView)
    {
        super.init(frame: frame)
        defer
        {
            postInit()
            self.graphContainerView = parent
            self.data = data
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }
    
    func postInit() -> Void
    {
        backgroundColor = UIColor.clear
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.backgroundColor = UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.6)
        visualEffectView.layer.shadowColor = UIColor.placeholderText.cgColor
        visualEffectView.layer.shadowOffset = CGSize.zero
        visualEffectView.layer.shadowOpacity = 1.0
        visualEffectView.layer.shadowRadius = 32
        visualEffectView.layer.masksToBounds = true
        visualEffectView.layer.cornerRadius = 8
        addSubview(visualEffectView)
        
        
        tap = UITapGestureRecognizer(target: self,
                                     action: #selector(handleTap(recognizer:)))

        pan = UIPanGestureRecognizer(target: self,
                                     action: #selector(handlePan(recognizer:)))

        longPress = UILongPressGestureRecognizer(target: self,
                                                 action: #selector(handleLongPress(recognizer:)))
        if let longPress = longPress,
            let pan = pan,
            let tap = tap
        {
            addGestureRecognizer(tap)
            pan.delegate = self
            addGestureRecognizer(pan)
            longPress.delegate = self
            addGestureRecognizer(longPress)
            longPress.require(toFail: pan)
        }
        
        titleLabel.frame = CGRect.init(x: Constant.nodePadding, y: Constant.nodePadding, width: self.frame.size.width - Constant.nodePadding * 2, height: Constant.nodeTitleHeight)
        titleLabel.font = UIFont.init(name: Constant.fontObliqueName, size: 16)
        
        visualEffectView.contentView.addSubview(titleLabel)
        
        inPortsContainer.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        inPortsContainer.layer.cornerRadius = 4;
        inPortsContainer.layer.masksToBounds = true
        outPortsContainer.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        outPortsContainer.layer.cornerRadius = 4;
        outPortsContainer.layer.masksToBounds = true
        
        customView.nodeView = self
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 8
        customView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        menuInteraction = UIContextMenuInteraction(delegate: self)
        if let menuInteraction = menuInteraction {
            self.addInteraction(menuInteraction)
        }
    }
    
    func makeSelected() -> Void
    {
        graphContainerView?.bringSubviewToFront(self)
        if let nodeViewSelectedHandler = nodeViewSelectedHandler {
            nodeViewSelectedHandler()
        }
        self.becomeFirstResponder()
    }
    
    func updateNode() -> Void
    {
        if let data = data
        {
            data.frame = self.frame
            self.visualEffectView.layer.borderColor = data.isSelected ? UIColor.orange.withAlphaComponent(0.6).cgColor : UIColor.clear.cgColor
            self.visualEffectView.layer.borderWidth = data.isSelected ? 4 : 0
            self.customView.layer.borderColor = data.isSelected ? UIColor.black.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
            self.customView.layer.borderWidth = data.isSelected ? 4 : 0
        }
    }
    
    // MARK: - UIContextMenuInteractionDelegate
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let share = UIAction(title: "Share Shader Source",
         image: UIImage(systemName: "square.and.arrow.up.fill"),
         attributes: []) { action in
            
        }
        
          let delete = UIAction(title: "Delete",
            image: UIImage(systemName: "trash.fill"),
            attributes: [.destructive]) { action in
                self.delete()
           }

           return UIContextMenuConfiguration(identifier: nil,
             previewProvider: nil) { _ in
             UIMenu(title: "Edit", children: [share,delete])
           }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView : UIView = touch.view,
            let nodeData = data,
            nodeData.isSelected
        {
           return !touchView.isDescendant(of: customView)
        }
        return true
    }
    
    // MARK: - Gesture Handler
    
    @objc func handleTap(recognizer : UITapGestureRecognizer) -> Void
    {
        makeSelected()
        if let pushBehavior = pushBehavior
        {
            self.graphContainerView?.dynamicAnimator?.removeBehavior(pushBehavior)
        }
        if let scaleAnimator = scaleAnimator
        {
            scaleAnimator.stopAnimation(true)
        }
        scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
            self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleZoomed, y: Constant.nodeScaleZoomed)
        })
        scaleAnimator?.addAnimations({ [weak self]  in
            guard let self = self else { return }
            self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleNormal, y: Constant.nodeScaleNormal)
            self.markNodeMoved()
        }, delayFactor: 0.5)
        scaleAnimator?.startAnimation()
        
//        if self.isFirstResponder
//        {
//            self.resignFirstResponder()
//            UIMenuController.shared.setMenuVisible(false, animated: true)
//        }
    }
    
    @objc func handleLongPress(recognizer : UILongPressGestureRecognizer) -> Void
    {
        makeSelected()
        switch recognizer.state
        {
        case .began:
            if let pushBehavior = pushBehavior
            {
                self.graphContainerView?.dynamicAnimator?.removeBehavior(pushBehavior)
            }
            scaleAnimator?.stopAnimation(true)
            scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: { [weak self]  in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleZoomed, y: Constant.nodeScaleZoomed)
                self.markNodeMoved()
            })
            scaleAnimator?.startAnimation()
//            self.becomeFirstResponder()
//            UIMenuController.shared.setTargetRect(bounds, in: self)
//            UIMenuController.shared.setMenuVisible(true, animated: true)
            break
        case .ended:
            scaleAnimator?.stopAnimation(true)
            scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: { [weak self]  in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleNormal, y: Constant.nodeScaleNormal)
                self.markNodeMoved()
            })
            scaleAnimator?.startAnimation()
            break
        default: break
        }
    }
    
    @objc func handlePan(recognizer : UIPanGestureRecognizer) -> Void
    {
        makeSelected()
        let velocityInParent = recognizer.velocity(in: graphContainerView)
        let locationInSelf = recognizer.location(in: self)
        
        switch recognizer.state
        {
        case .began:
            if let pushBehavior = pushBehavior
            {
                self.graphContainerView?.dynamicAnimator?.removeBehavior(pushBehavior)
            }
            scaleAnimator?.stopAnimation(true)
            scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: { [weak self]  in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleZoomed, y: Constant.nodeScaleZoomed)
                self.markNodeMoved()
            })
            scaleAnimator?.addCompletion({ [weak self]  (finalPosition) in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleZoomed, y: Constant.nodeScaleZoomed)
                self.markNodeMoved()
            })
            scaleAnimator?.startAnimation()
            
            if let attachmentBehavior = attachmentBehavior
            {
                self.graphContainerView?.dynamicAnimator?.removeBehavior(attachmentBehavior)
            }
            attachmentBehavior = UIAttachmentBehavior(item: self,
                                                      offsetFromCenter: UIOffset.init(horizontal: locationInSelf.x - self.bounds.size.width / 2.0,
                                                                                      vertical: locationInSelf.y - self.bounds.size.height / 2.0),
                                                      attachedToAnchor: recognizer.location(in: self.graphContainerView))
            attachmentBehavior?.action = { [weak self] in
                guard let self = self else { return }
                self.updateNode()
                self.transform = self.transform.scaledBy(x: Constant.nodeScaleZoomed, y: Constant.nodeScaleZoomed)
                self.markNodeMoved()
            }
            if let attachmentBehavior = attachmentBehavior
            {
                graphContainerView?.dynamicAnimator?.addBehavior(attachmentBehavior)
            }
//            self.resignFirstResponder()
//            UIMenuController.shared.setMenuVisible(false, animated: true)
            break
        case .changed:
            if let attachmentBehavior = attachmentBehavior
            {
                attachmentBehavior.anchorPoint = recognizer.location(in: self.graphContainerView)
            }
            break
        case .ended:
            if let attachmentBehavior = attachmentBehavior
            {
                graphContainerView?.dynamicAnimator?.removeBehavior(attachmentBehavior)
            }
            scaleAnimator?.stopAnimation(true)
            scaleAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleNormal, y: Constant.nodeScaleNormal)
                self.markNodeMoved()
            })
            scaleAnimator?.addCompletion({  [weak self]  (finalPosition) in
                guard let self = self else { return }
                self.transform = CGAffineTransform.init(scaleX: Constant.nodeScaleNormal, y: Constant.nodeScaleNormal)
                self.markNodeMoved()
            })
            scaleAnimator?.startAnimation()
            
            if let pushBehavior = pushBehavior
            {
                graphContainerView?.dynamicAnimator?.removeBehavior(pushBehavior)
            }
            pushBehavior = UIPushBehavior(items: [self], mode: .instantaneous)
            if let pushBehavior = pushBehavior
            {
                pushBehavior.action = { [weak self] in
                    guard let self = self else { return }
                    self.updateNode()
                    self.markNodeMoved()
                }
                let length = hypot(velocityInParent.x, velocityInParent.y)
                if length > 100
                {
                    pushBehavior.pushDirection = CGVector.init(dx: velocityInParent.x / 4.0 / pow(length, 0.5) ,
                                                               dy: velocityInParent.y / 4.0 / pow(length, 0.5))
                    graphContainerView?.dynamicAnimator?.addBehavior(pushBehavior)
                }
            }
            break
        default:
            if let attachmentBehavior = attachmentBehavior
            {
                graphContainerView?.dynamicAnimator?.removeBehavior(attachmentBehavior)
            }
            break
        }
    }
    
    func markNodeMoved() -> Void
    {
        guard let graphContainerView = graphContainerView else {
            return
        }
        graphContainerView.delegate?.nodeMoved(nodeGraphContainerView: graphContainerView)
    }
    
    public func delete()
    {
        if let data = data {
            graphContainerView?.nodeGraphView?.dataSource?.delete(node: data)
        }
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(delete(_:))
    }
    
    public override var canBecomeFirstResponder: Bool
    {
        return true
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil
        {
            if let attachmentBehavior = attachmentBehavior
            {
                graphContainerView?.dynamicAnimator?.removeBehavior(attachmentBehavior)
            }
            if let pushBehavior = pushBehavior
            {
                self.graphContainerView?.dynamicAnimator?.removeBehavior(pushBehavior)
            }
            data = nil
            while subviews.count > 0
            {
                var view = subviews.last
                view?.removeFromSuperview()
                view = nil
            }
            self.gestureRecognizers?.forEach({ [weak self] (gesture) in
                guard let self = self else { return }
                self.removeGestureRecognizer(gesture)
            })
        }
    }
}
