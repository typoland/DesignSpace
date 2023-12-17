//
//  HyperStyleDemoApp.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import DesignSpace

@main
struct HyperStyleDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AxesView<DemoAxis>()
                .environment(GLOBAL_SPACE)
        }
    }
}
