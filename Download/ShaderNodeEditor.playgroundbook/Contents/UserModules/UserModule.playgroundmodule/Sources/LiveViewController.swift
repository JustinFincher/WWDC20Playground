//
//  LiveViewController.swift
//  UserModule
//
//  Created by fincher on 5/11/20.
//

import Foundation
import UIKit
import PlaygroundSupport

open class LiveViewController : NodeEditorViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer
{
    public override func viewDidLoad() {
        super.viewDidLoad()
            
        self.navigationItem.prompt = "Long press on canvas to add nodes. Use Cheat Sheet if you need help"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🎲 Cheat Sheet", style: .plain, target: self, action: #selector(showCheatSheet))
    }
    
    @objc func showCheatSheet() -> Void {
        let alertController = UIAlertController(title: "Cheat Sheet", message: "Select pre-made node graph if you cannot complete corresponding tutorials but want to see the final result instantly", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Clear > Reset Graph", style: .default, handler: { (action) in
            self.nodeEditorData.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute:
                {
                    self.nodeEditorData.forceUpdate()
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Complete > Getting Started", style: .default, handler: { (action) in
            self.nodeEditorData.removeAll()
            let floatGeneratorNode1 : FloatGeneratorNodeData = FloatGeneratorNodeData()
            floatGeneratorNode1.frame  = CGRect.init(x: 16, y: 16, width: floatGeneratorNode1.frame.size.width, height: floatGeneratorNode1.frame.size.height)
            floatGeneratorNode1.value.value = 0.5
            self.nodeEditorData.addNode(node: floatGeneratorNode1)
            
            let floatGeneratorNode2 : FloatGeneratorNodeData = FloatGeneratorNodeData()
            floatGeneratorNode2.frame  = CGRect.init(x: 16, y: 300, width: floatGeneratorNode2.frame.size.width, height: floatGeneratorNode2.frame.size.height)
            floatGeneratorNode2.value.value = 0.5
            self.nodeEditorData.addNode(node: floatGeneratorNode2)
            
            let floatAddNode : FloatAddNodeData = FloatAddNodeData()
            floatAddNode.frame  = CGRect.init(x: 300, y: 30, width: floatAddNode.frame.size.width, height: floatAddNode.frame.size.height)
            self.nodeEditorData.addNode(node: floatAddNode)
            
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode1.outPorts[0], inPort: floatAddNode.inPorts[0])
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode2.outPorts[0], inPort: floatAddNode.inPorts[1])
            self.nodeEditorData.forceUpdate()
        }))
        
        alertController.addAction(UIAlertAction(title: "Complete > Advanced Usages", style: .default, handler: { (action) in
            self.nodeEditorData.removeAll()
            let uvNode : Vec2TexCoordNodeData = Vec2TexCoordNodeData()
            uvNode.frame  = CGRect.init(x: 16, y: 16, width: uvNode.frame.size.width, height: uvNode.frame.size.height)
            self.nodeEditorData.addNode(node: uvNode)
            
            let uvSplitNode : Vec2ChannelSplitNodeData = Vec2ChannelSplitNodeData()
            uvSplitNode.frame  = CGRect.init(x: 250, y: 16, width: uvSplitNode.frame.size.width, height: uvSplitNode.frame.size.height)
            self.nodeEditorData.addNode(node: uvSplitNode)
            self.nodeEditorData.connectNode(outPort: uvNode.outPorts[0], inPort: uvSplitNode.inPorts[0])
            
            let timeNode : FloatTimeNodeData = FloatTimeNodeData()
            timeNode.frame  = CGRect.init(x: 16, y: 300, width: timeNode.frame.size.width, height: timeNode.frame.size.height)
            self.nodeEditorData.addNode(node: timeNode)
            
            let sinNode : FloatSinNodeData = FloatSinNodeData()
             sinNode.frame  = CGRect.init(x: 250, y: 200, width: sinNode.frame.size.width, height: sinNode.frame.size.height)
             self.nodeEditorData.addNode(node: sinNode)
             self.nodeEditorData.connectNode(outPort: timeNode.outPorts[0], inPort: sinNode.inPorts[0])
            
            let vec4CombineNode : Vec4ChannelCombineNodeData = Vec4ChannelCombineNodeData()
            vec4CombineNode.frame  = CGRect.init(x: 550, y: 70, width: vec4CombineNode.frame.size.width, height: vec4CombineNode.frame.size.height)
            self.nodeEditorData.addNode(node: vec4CombineNode)
            self.nodeEditorData.connectNode(outPort: uvSplitNode.outPorts[0], inPort: vec4CombineNode.inPorts[0])
            self.nodeEditorData.connectNode(outPort: uvSplitNode.outPorts[1], inPort: vec4CombineNode.inPorts[1])
            self.nodeEditorData.connectNode(outPort: sinNode.outPorts[0], inPort: vec4CombineNode.inPorts[2])
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute:
                {
                    self.nodeEditorData.forceUpdate()
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Complete > VJ Machine", style: .default, handler: { (action) in
            self.nodeEditorData.removeAll()
            
            let atanNode : FloatUVCenterAtanNodeData = FloatUVCenterAtanNodeData()
            atanNode.frame  = CGRect.init(x: 16, y: 16, width: atanNode.frame.size.width, height: atanNode.frame.size.height)
            self.nodeEditorData.addNode(node: atanNode)
            
            let audioNode : FloatAudioDBNodeData = FloatAudioDBNodeData()
            audioNode.frame  = CGRect.init(x: 16, y: 300, width: audioNode.frame.size.width, height: audioNode.frame.size.height)
            self.nodeEditorData.addNode(node: audioNode)
            
            let floatGeneratorNode1 : FloatGeneratorNodeData = FloatGeneratorNodeData()
            floatGeneratorNode1.frame  = CGRect.init(x: 16, y: 400, width: floatGeneratorNode1.frame.size.width, height: floatGeneratorNode1.frame.size.height)
            floatGeneratorNode1.value.value = 5.0
            self.nodeEditorData.addNode(node: floatGeneratorNode1)
            
            let floatGeneratorNode2 : FloatGeneratorNodeData = FloatGeneratorNodeData()
            floatGeneratorNode2.frame  = CGRect.init(x: 16, y: 640, width: floatGeneratorNode2.frame.size.width, height: floatGeneratorNode2.frame.size.height)
            floatGeneratorNode2.value.value = 8.0
            self.nodeEditorData.addNode(node: floatGeneratorNode2)
            
            let discRayNode : FloatRayDiscNodeData = FloatRayDiscNodeData()
            discRayNode.frame  = CGRect.init(x: 300, y: 60, width: discRayNode.frame.size.width, height: discRayNode.frame.size.height)
            self.nodeEditorData.addNode(node: discRayNode)
            self.nodeEditorData.connectNode(outPort: atanNode.outPorts[0], inPort: discRayNode.inPorts[0])
            self.nodeEditorData.connectNode(outPort: audioNode.outPorts[0], inPort: discRayNode.inPorts[1])
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode1.outPorts[0], inPort: discRayNode.inPorts[2])
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode2.outPorts[0], inPort: discRayNode.inPorts[3])
            
            let floatGeneratorNode3 : FloatSliderGeneratorNodeData = FloatSliderGeneratorNodeData()
            floatGeneratorNode3.frame  = CGRect.init(x: 320, y: 470, width: floatGeneratorNode3.frame.size.width, height: floatGeneratorNode3.frame.size.height)
            floatGeneratorNode3.value.value = 0.0
            self.nodeEditorData.addNode(node: floatGeneratorNode3)
            
            let floatGeneratorNode4 : FloatSliderGeneratorNodeData = FloatSliderGeneratorNodeData()
            floatGeneratorNode4.frame  = CGRect.init(x: 370, y: 650, width: floatGeneratorNode4.frame.size.width, height: floatGeneratorNode4.frame.size.height)
            floatGeneratorNode4.value.value = 0.3
            self.nodeEditorData.addNode(node: floatGeneratorNode4)
            
            let circleOutlineNode : FloatCircleOutlineNodeData = FloatCircleOutlineNodeData()
            circleOutlineNode.frame  = CGRect.init(x: 550, y: 70, width: circleOutlineNode.frame.size.width, height: circleOutlineNode.frame.size.height)
            self.nodeEditorData.addNode(node: circleOutlineNode)
            
            self.nodeEditorData.connectNode(outPort: discRayNode.outPorts[0], inPort: circleOutlineNode.inPorts[0])
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode3.outPorts[0], inPort: circleOutlineNode.inPorts[1])
            self.nodeEditorData.connectNode(outPort: floatGeneratorNode4.outPorts[0], inPort: circleOutlineNode.inPorts[2])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute:
                {
                    self.nodeEditorData.forceUpdate()
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true, completion: {})
    }
    
    //MARK: PlaygroundLiveViewMessageHandler
    
    public func receive(_ message: PlaygroundValue) {
        // guard case let .string(messageString) = message else { return }
    }
    
    public func send(_ message: PlaygroundValue) {
        
    }
    
    public func liveViewMessageConnectionClosed() {
    }
    
    public func liveViewMessageConnectionOpened() {
    }
    
    //MARK: PlaygroundLiveViewSafeAreaContainer
}
