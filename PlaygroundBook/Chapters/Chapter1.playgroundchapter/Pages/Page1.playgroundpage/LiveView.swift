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

final class ContentViewStore: ObservableObject {
    @Published var audioPermissionEnabled = AudioUniformProviderManager.shared.hasRecordPermission() {
        didSet {
            if audioPermissionEnabled {
                AudioUniformProviderManager.shared.requestPermission()
            }
            var trueVal = AudioUniformProviderManager.shared.hasRecordPermission()
            if (audioPermissionEnabled != trueVal)
            {
                audioPermissionEnabled = trueVal
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var store = ContentViewStore()
    
    var body: some View {
        List {
        Section{
            Text("Welcome to Shader Node Editor").font(.largeTitle).fontWeight(.black)
        }
            Section(header: Text("In order to give you a hassle-free experience in later chapters, please complete these task first"), footer: Text((store.audioPermissionEnabled ? "You have completed all tasks, now please proceed to the next page":""))){
                Toggle(isOn: $store.audioPermissionEnabled) {
                Text("Allow Audio Permission")
                }.disabled(store.audioPermissionEnabled)
        }
            Section(header: Text("Tutorial: How to connect nodes")) {
                VStack(alignment: .leading){
                    HStack()
                    {
                        Image(uiImage: UIImage(named:"NodeTutorial1.jpg")!).resizable()
                        .frame(width: Constant.tutorialRowHeight, height: Constant.tutorialRowHeight)
                        Text("1. Drag the knot on any side of a node and a line would appear following your position").font(.footnote)
                    }
                    HStack()
                    {
                        Image(uiImage: UIImage(named:"NodeTutorial2.jpg")!).resizable()
                            .frame(width: Constant.tutorialRowHeight, height: Constant.tutorialRowHeight)
                            Text("2. The line would display in red if it cannot connect (no knot or invalid data format)").font(.footnote)
                    }
                    HStack()
                    {
                        Image(uiImage: UIImage(named:"NodeTutorial3.jpg")!).resizable()
                        .frame(width: Constant.tutorialRowHeight, height: Constant.tutorialRowHeight)
                            Text("3. The line would display in green if target knot is compatible").font(.footnote)
                    }
                    HStack()
                    {
                        Image(uiImage: UIImage(named:"NodeTutorial4.jpg")!).resizable()
                        .frame(width: Constant.tutorialRowHeight, height: Constant.tutorialRowHeight)
                            Text("4. Lift your finger when the line is green and it would be added between two knots").font(.footnote)
                    }
                    HStack()
                    {
                        Image(uiImage: UIImage(named:"NodeTutorial5.jpg")!).resizable()
                        .frame(width: Constant.tutorialRowHeight, height: Constant.tutorialRowHeight)
                            Text("5. Drag an already connected knot would make the line disconnected").font(.footnote)
                            }
                }
                
            }
        }
        .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
