import Foundation
import WatchConnectivity

extension Notification.Name {
    static let watchScorePoint = Notification.Name("watchScorePoint")
    static let watchResetGame = Notification.Name("watchResetGame")
    static let watchResetMatch = Notification.Name("watchResetMatch")
    static let watchRequestGameState = Notification.Name("watchRequestGameState")
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
        guard WCSession.default.isReachable else { return }
        
        let gameData: [String: Any] = [
            "team1Name": game.team1Name,
            "team2Name": game.team2Name,
            "team1Player1": game.team1Player1,
            "team1Player2": game.team1Player2,
            "team2Player1": game.team2Player1,
            "team2Player2": game.team2Player2,
            "team1GameScore": game.team1GameScore,
            "team2GameScore": game.team2GameScore,
            "team1Sets": game.team1Sets,
            "team2Sets": game.team2Sets,
            "team1Games": game.team1Games,
            "team2Games": game.team2Games,
            "bestOfSets": game.bestOfSets,
            "isMatchFinished": game.isMatchFinished,
            "winningTeam": game.winningTeam ?? -1,
            "isDeuce": game.isDeuce,
            "advantageTeam": game.advantageTeam ?? -1
        ]
        
        WCSession.default.sendMessage(["gameState": gameData], replyHandler: nil) { error in
            print("Error sending game state: \(error.localizedDescription)")
        }
    }
    
    func sendScoreUpdate(team: Int, gameState: PadelGame) {
        guard WCSession.default.isReachable else { return }
        
        let scoreData: [String: Any] = [
            "action": "scorePoint",
            "team": team,
            "team1GameScore": gameState.team1GameScore,
            "team2GameScore": gameState.team2GameScore,
            "team1Sets": gameState.team1Sets,
            "team2Sets": gameState.team2Sets,
            "team1Games": gameState.team1Games,
            "team2Games": gameState.team2Games,
            "isMatchFinished": gameState.isMatchFinished,
            "winningTeam": gameState.winningTeam ?? -1,
            "currentGameScore1": gameState.displayGameScore(for: 1),
            "currentGameScore2": gameState.displayGameScore(for: 2)
        ]
        
        WCSession.default.sendMessage(scoreData, replyHandler: nil) { error in
            print("Error sending score update: \(error.localizedDescription)")
        }
    }
    
    func sendMatchReset() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetMatch"], replyHandler: nil) { error in
            print("Error sending match reset: \(error.localizedDescription)")
        }
    }
    
    func sendGameReset() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "resetGame"], replyHandler: nil) { error in
            print("Error sending game reset: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Watch-specific methods
    
    func sendScorePoint(team: Int) {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["action": "scorePoint", "team": team], replyHandler: nil) { error in
            print("Error sending score point: \(error.localizedDescription)")
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
        
        switch action {
        case "scorePoint":
            if let team = message["team"] as? Int {
                NotificationCenter.default.post(name: .watchScorePoint, object: nil, userInfo: ["team": team])
                return ["success": true, "action": "scorePoint", "team": team]
            }
        case "resetMatch":
            NotificationCenter.default.post(name: .watchResetMatch, object: nil)
            return ["success": true, "action": "resetMatch"]
        case "resetGame":
            NotificationCenter.default.post(name: .watchResetGame, object: nil)
            return ["success": true, "action": "resetGame"]
        case "getGameState":
            NotificationCenter.default.post(name: .watchRequestGameState, object: nil)
            return ["success": true, "action": "getGameState"]
        default:
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
        }
        
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
        } else {
            print("WC Session activated successfully")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        // Reactivate the session for both iOS and watchOS
        session.activate()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Handle messages without reply handler
        DispatchQueue.main.async {
            // Store game data for Watch app
            if let gameState = message["gameState"] as? [String: Any] {
                self.gameData = gameState
            } else if message["action"] != nil {
                // Store score updates
                self.gameData = message
            }
            
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
            // Handle application context updates
            print("Received application context: \(applicationContext)")
        }
    }
}

// MARK: - watchOS-specific delegate method (not available on iOS)

#if os(watchOS)
extension WatchConnectivityManager {
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}
#endif