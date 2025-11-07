//
//  RotAppApp.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//
import SwiftUI

@main
struct RotAppApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(container)
        }
    }
}
