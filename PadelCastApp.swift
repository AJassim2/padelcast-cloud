import SwiftUI

@main
struct PadelCastApp: App {
    @StateObject private var gameModel = PadelGame()
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some Scene {
        WindowGroup {
            PlayerSetupView()
                .environmentObject(gameModel)
                .environmentObject(connectivityManager)
        }
    }
}