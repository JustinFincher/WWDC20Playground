//
//  LiveViewController.swift
//  UserModule
//
//  Created by fincher on 5/11/20.
//

import Foundation
import PlaygroundSupport

open class LiveViewController : NodeEditorViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer
{
    
    //MARK: PlaygroundLiveViewMessageHandler
    
    public func receive(_ message: PlaygroundValue) {
    }
    
    public func send(_ message: PlaygroundValue) {
        
    }
    
    public func liveViewMessageConnectionClosed() {
    }
    
    public func liveViewMessageConnectionOpened() {
    }
    
    //MARK: PlaygroundLiveViewSafeAreaContainer
}
