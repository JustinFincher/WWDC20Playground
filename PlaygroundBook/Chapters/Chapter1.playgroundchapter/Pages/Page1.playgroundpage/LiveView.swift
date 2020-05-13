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
        }
        .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
