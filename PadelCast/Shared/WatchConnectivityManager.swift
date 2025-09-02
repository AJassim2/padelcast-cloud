import Foundation
import WatchConnectivity

// Notification extensions for Watch communication
extension Notification.Name {
    static let watchScorePoint = Notification.Name("watchScorePoint")
    static let watchRemovePoint = Notification.Name("watchRemovePoint")
    static let watchResetGame = Notification.Name("watchResetGame")
    static let watchResetMatch = Notification.Name("watchResetMatch")
    static let watchRequestGameState = Notification.Name("watchRequestGameState")
    static let watchGameStateUpdated = Notification.Name("watchGameStateUpdated")
}

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var isConnected = false
    @Published var isReachable = false
    @Published var gameData: [String: Any]? = nil
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // MARK: - Send Methods
    
    func sendGameState(_ game: PadelGame) {
        guard WCSession.isSupported() else {
            print("WCSession not supported")
            return
        }
        
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated yet")
            return
        }
        
        // In simulator, isReachable might be false even when connected
        // So we'll try to send anyway and handle errors gracefully
        if !WCSession.default.isReachable {
            print("Watch not reachable - attempting to send anyway (might be simulator)")
        }
        
        print("📱 iPhone: Sending game state to Watch")
        print("📱 iPhone: team1Name = '\(game.team1Name)'")
        print("📱 iPhone: team2Name = '\(game.team2Name)'")
        
        let gameData: [String: Any] = [
            "action": "gameState",
            "team1Name": game.team1Name,
            "team2Name": game.team2Name,
            "team1Player1": game.team1Player1,
            "team1Player2": game.team1Player2,
            "team2Player1": game.team2Player1,
            "team2Player2": game.team2Player2,
            "team1GameScore": game.team1GameScore,
            "team2GameScore": game.team2GameScore,
            "team1SetGames": game.team1SetGames,
            "team2SetGames": game.team2SetGames,
            "currentSet": game.currentSet,
            "bestOfSets": game.bestOfSets,
            "isMatchFinished": game.isMatchFinished,
            "winningTeam": game.winningTeam ?? -1,
            "isDeuce": game.isDeuce,
            "advantageTeam": game.advantageTeam ?? -1,
            "currentGameScore1": game.displayGameScore(for: 1),
            "currentGameScore2": game.displayGameScore(for: 2)
        ]
        
        WCSession.default.sendMessage(gameData, replyHandler: nil) { error in
            print("Error sending game state: \(error.localizedDescription)")
            // In simulator, don't treat pairing errors as fatal
            if error.localizedDescription.contains("not paired") {
                print("Simulator pairing issue - this is expected in some simulator configurations")
            }
        }
    }
    
    func sendScoreUpdate(team: Int, gameState: PadelGame) {
        guard WCSession.isSupported() && WCSession.default.activationState == .activated else {
            print("WCSession not available - cannot send score update")
            return
        }
        
        if !WCSession.default.isReachable {
            print("Watch not reachable - attempting to send score anyway (might be simulator)")
        }
        
        let scoreData: [String: Any] = [
            "action": "scoreUpdate",
            "team": team,
            "team1GameScore": gameState.team1GameScore,
            "team2GameScore": gameState.team2GameScore,
            "team1SetGames": gameState.team1SetGames,
            "team2SetGames": gameState.team2SetGames,
            "currentSet": gameState.currentSet,
            "isMatchFinished": gameState.isMatchFinished,
            "winningTeam": gameState.winningTeam ?? -1,
            "currentGameScore1": gameState.displayGameScore(for: 1),
            "currentGameScore2": gameState.displayGameScore(for: 2),
            "isDeuce": gameState.isDeuce,
            "advantageTeam": gameState.advantageTeam ?? -1
        ]
        
        WCSession.default.sendMessage(scoreData, replyHandler: nil) { error in
            print("Error sending score update: \(error.localizedDescription)")
            // In simulator, don't treat pairing errors as fatal
            if error.localizedDescription.contains("not paired") {
                print("Simulator pairing issue - this is expected in some simulator configurations")
            }
        }
    }
    
    func sendGameReset() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetGame"], replyHandler: nil) { error in
            print("Error sending game reset: \(error.localizedDescription)")
        }
    }
    
    func sendMatchReset() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetMatch"], replyHandler: nil) { error in
            print("Error sending match reset: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Watch-specific methods
    
    func sendScorePoint(team: Int) {
        guard WCSession.default.isReachable else { 
            print("iPhone not reachable - cannot send score point")
            return 
        }
        
        WCSession.default.sendMessage(["action": "scorePoint", "team": team], replyHandler: nil) { error in
            print("Error sending score point: \(error.localizedDescription)")
        }
    }
    
    func sendRemovePoint(team: Int) {
        guard WCSession.default.isReachable else { 
            print("iPhone not reachable - cannot send remove point")
            return 
        }
        
        WCSession.default.sendMessage(["action": "removePoint", "team": team], replyHandler: nil) { error in
            print("Error sending remove point: \(error.localizedDescription)")
        }
    }
    
    func sendResetGame() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetGame"], replyHandler: nil) { error in
            print("Error sending reset game: \(error.localizedDescription)")
        }
    }
    
    func sendResetMatch() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetMatch"], replyHandler: nil) { error in
            print("Error sending reset match: \(error.localizedDescription)")
        }
    }
    
    func requestGameState() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "getGameState"], replyHandler: nil) { error in
            print("Error requesting game state: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Receive Methods
    
    private func handleReceivedMessage(_ message: [String: Any]) -> [String: Any]? {
        guard let action = message["action"] as? String else { return nil }
        
        print("Received message with action: \(action)")
        
        switch action {
        case "scorePoint":
            if let team = message["team"] as? Int {
                print("Watch scored point for team \(team)")
                NotificationCenter.default.post(name: .watchScorePoint, object: nil, userInfo: ["team": team])
                return ["success": true, "action": "scorePoint", "team": team]
            }
        case "removePoint":
            if let team = message["team"] as? Int {
                print("Watch removed point for team \(team)")
                NotificationCenter.default.post(name: .watchRemovePoint, object: nil, userInfo: ["team": team])
                return ["success": true, "action": "removePoint", "team": team]
            }
        case "resetMatch":
            print("Watch requested match reset")
            NotificationCenter.default.post(name: .watchResetMatch, object: nil)
            return ["success": true, "action": "resetMatch"]
        case "resetGame":
            print("Watch requested game reset")
            NotificationCenter.default.post(name: .watchResetGame, object: nil)
            return ["success": true, "action": "resetGame"]
        case "getGameState":
            print("Watch requested game state")
            NotificationCenter.default.post(name: .watchRequestGameState, object: nil)
            return ["success": true, "action": "getGameState"]
        case "gameState", "scoreUpdate":
            // Store the received data for Watch app
            DispatchQueue.main.async {
                self.gameData = message
            }
            // Notify that game state was updated from watch
            NotificationCenter.default.post(name: .watchGameStateUpdated, object: nil, userInfo: message)
            return ["success": true, "action": action]
        default:
            print("Unknown action: \(action)")
            break
        }
        
        return ["success": false, "error": "Unknown action"]
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
            print("WCSession activation state: \(activationState == .activated ? "Connected" : "Disconnected")")
        }
        
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
        } else {
            print("WC Session activated successfully")
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            print("Watch reachability changed: \(session.isReachable ? "Reachable" : "Not reachable")")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Handle messages without reply handler
        DispatchQueue.main.async {
            let _ = self.handleReceivedMessage(message)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle messages with reply handler
        DispatchQueue.main.async {
            let response = self.handleReceivedMessage(message) ?? ["success": false, "error": "Failed to process message"]
            replyHandler(response)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        DispatchQueue.main.async {
            print("Received application context: \(applicationContext)")
            self.gameData = applicationContext
        }
    }
}

// MARK: - Platform-specific methods

#if !os(watchOS)
// iOS-specific implementation
extension WatchConnectivityManager {
    func sessionDidBecomeInactive(_ session: WCSession) {
        // This method is only available on watchOS
        // Providing stub for iOS compilation
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        // iOS apps should reactivate the session
        session.activate()
    }
}
#else
// watchOS-specific implementation
extension WatchConnectivityManager {
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        // watchOS apps should reactivate the session
        session.activate()
    }
}
#endif