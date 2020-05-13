//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import UserModule
import PlaygroundSupport

//let liveVC = LiveViewController()
PlaygroundPage.current.liveView = UINavigationController(rootViewController: LiveViewController());
