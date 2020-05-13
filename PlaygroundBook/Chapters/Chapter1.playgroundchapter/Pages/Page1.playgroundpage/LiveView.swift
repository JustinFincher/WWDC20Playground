//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import PlaygroundSupport
import SwiftUI
import UserModule

struct ContentView: View {
    @State var audioPermissionEnabled = AudioUniformProviderManager.shared.hasRecordPermission() {
        didSet {
            var trueVal = AudioUniformProviderManager.shared.hasRecordPermission()
            if (!trueVal)
            {
                AudioUniformProviderManager.shared.requestPermission()
            }
            trueVal = AudioUniformProviderManager.shared.hasRecordPermission()
            if (audioPermissionEnabled != trueVal)
            {
                audioPermissionEnabled = trueVal
            }
        }
    }
    
    var body: some View {
        List {
        Section{
            Text("Welcome to Shader Node Editor").font(.largeTitle).fontWeight(.black)
        }
        Section(header: Text("In order to give you a hassle-free experience in later chapters, please complete these task first"), footer: Text((audioPermissionEnabled) ? "You have completed all tasks, now please proceed to the next page":"")){
            Toggle(isOn: $audioPermissionEnabled) {
                Text("Allow Audio Permission")
            }.disabled(audioPermissionEnabled)
        }
        }
        .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }
}

//if (!NodeInfoCacheManager.shared.isNodeListLoaded())
//{
//    var nodeClassNames : Array<String> = []
//    NodeInfoCacheManager.shared.reload(force: false, blankArr:&nodeClassNames, useReflection: Constant.useReflectionToGetNodeList)
//}

PlaygroundPage.current.setLiveView(ContentView())
