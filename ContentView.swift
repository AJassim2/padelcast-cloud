import SwiftUI
import AVKit
import MediaPlayer
import PhotosUI
import AudioToolbox

// MARK: - TV Streaming View
struct TVStreamingView: View {
    @EnvironmentObject var game: PadelGame
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @State private var player: AVPlayer?
    
    var body: some View {
            ZStack {
                // Background gradient
                LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                // Header
                TVHeaderView()
                
                // Score Display
                TVScoreDisplayView(game: game)
                
                // Interactive Scoring Controls
                TVScoringControlsView()
                
                // Match Progress
                TVMatchProgressView(game: game)
                
                Spacer()
                
                // Footer
                TVFooterView()
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            setupVideoPlayer()
        }
    }
    
    private func setupVideoPlayer() {
        let player = AVPlayer()
        self.player = player
        player.play()
    }
}

// MARK: - TV Header View
struct TVHeaderView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("PADEL MATCH")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            
            Text("LIVE STREAMING")
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundColor(.yellow)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
        }
        .padding(.top, 40)
    }
}

// MARK: - TV Score Display View
struct TVScoreDisplayView: View {
    let game: PadelGame
    
    var body: some View {
        HStack(spacing: 60) {
            TVTeamView(
                teamName: game.team1Name,
                player1: game.team1Player1,
                player2: game.team1Player2,
                games: game.getGamesForSet(game.currentSet, team: 1),
                points: game.team1GameScore,
                color: .blue
            )
            
            TVVSView(currentSet: game.currentSet)
            
            TVTeamView(
                teamName: game.team2Name,
                player1: game.team2Player1,
                player2: game.team2Player2,
                games: game.getGamesForSet(game.currentSet, team: 2),
                points: game.team2GameScore,
                color: .red
            )
        }
    }
}

// MARK: - TV Team View
struct TVTeamView: View {
    let teamName: String
    let player1: String
    let player2: String
    let games: Int
    let points: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Text(teamName)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            
            VStack(spacing: 10) {
                Text(player1)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                Text(player2)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(games)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    Text("GAMES")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack {
                    Text("\(points)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    Text("POINTS")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - TV VS View
struct TVVSView: View {
    let currentSet: Int
    
    var body: some View {
        VStack {
            Text("VS")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.yellow)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            
            Text("SET \(currentSet)")
                .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                    .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.purple.opacity(0.6))
                )
        }
    }
}

// MARK: - TV Match Progress View
struct TVMatchProgressView: View {
    let game: PadelGame
    
    var body: some View {
        VStack(spacing: 15) {
            Text("MATCH PROGRESS")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            
            HStack(spacing: 30) {
                Text(game.matchFormat.displayName)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                if game.isSuperTiebreak {
                    Text("Super Tie-break")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.yellow)
                } else {
                    Text("Set \(game.currentSet) of \(game.bestOfSets)")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - TV Scoring Controls View
struct TVScoringControlsView: View {
    @EnvironmentObject var game: PadelGame
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("SCORE POINTS")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            
            HStack(spacing: 40) {
                // Team 1 Score Button
                Button(action: {
                    print("🎾 TV: Team 1 scored a point!")
                    game.scorePoint(for: 1)
                    connectivityManager.sendScoreUpdate(team: 1, gameState: game)
                }) {
                    VStack(spacing: 8) {
                        Text("+1")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(game.team1Name)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(width: 120, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                }
                
                // Team 2 Score Button
                Button(action: {
                    print("🎾 TV: Team 2 scored a point!")
                    game.scorePoint(for: 2)
                    connectivityManager.sendScoreUpdate(team: 2, gameState: game)
                }) {
                    VStack(spacing: 8) {
                        Text("+1")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(game.team2Name)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(width: 120, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.red.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                }
            }
            
            // Reset Controls
            HStack(spacing: 20) {
                        Button(action: {
                    game.resetGame()
                            connectivityManager.sendGameState(game)
                        }) {
                    Text("Reset Game")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        .frame(width: 100, height: 40)
                                .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange.opacity(0.7))
                        )
                }
                
                        Button(action: {
                    game.resetMatch()
                            connectivityManager.sendGameState(game)
                        }) {
                    Text("Reset Match")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        .frame(width: 100, height: 40)
                                .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple.opacity(0.7))
                        )
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - TV Footer View
struct TVFooterView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Interactive TV Controls")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
            
            Text("Score points directly from TV")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.green)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - AirPlay Manager
class AirPlayManager: ObservableObject {
    static let shared = AirPlayManager()
    @Published var isStreaming = false
    
    private init() {}
    
    func startStreaming() {
        isStreaming = true
    }
    
    func stopStreaming() {
        isStreaming = false
    }
}

struct ContentView: View {
    @EnvironmentObject var game: PadelGame
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingEndMatchAlert = false
    @State private var showingTVCodeInput = false
    @State private var tvCode = ""
    @State private var tvId = "" // Store the scanned TV ID from QR code
    @State private var showingTVCodeAlert = false
    @State private var tvCodeAlertMessage = ""
    @State private var customBestOf = ""

    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header with match info and controls
                headerSection
                    .frame(height: geometry.size.height * 0.15)
                
                // Main scoring area
                scoringSection
                    .frame(height: geometry.size.height * 0.6)
                
                // Action buttons
                actionButtonsSection
                    .frame(height: geometry.size.height * 0.25)
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarHidden(true)
        .onAppear {
            // Send initial game state to watch
            connectivityManager.sendGameState(game)
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchScorePoint)) { notification in
            if let team = notification.userInfo?["team"] as? Int {
                game.scorePoint(for: team)
                connectivityManager.sendScoreUpdate(team: team, gameState: game)
                
                // Automatically sync with cloud server when watch updates score
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    sendUpdateToWebServer()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchRemovePoint)) { notification in
            if let team = notification.userInfo?["team"] as? Int {
                game.subtractPoint(for: team)
                connectivityManager.sendScoreUpdate(team: team, gameState: game)
                
                // Automatically sync with cloud server when watch removes point
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    sendUpdateToWebServer()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchResetGame)) { _ in
            game.resetGame()
            connectivityManager.sendGameState(game)
            
            // Automatically sync with cloud server when watch resets game
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sendUpdateToWebServer()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchResetMatch)) { _ in
            game.resetMatch()
            connectivityManager.sendGameState(game)
            
            // Automatically sync with cloud server when watch resets match
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sendUpdateToWebServer()
            }
        }
                            .onReceive(NotificationCenter.default.publisher(for: .watchRequestGameState)) { _ in
            connectivityManager.sendGameState(game)
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchGameStateUpdated)) { _ in
            // Automatically sync with cloud server when watch sends complete game state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sendUpdateToWebServer()
            }
        }


        .alert("End Match", isPresented: $showingEndMatchAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Match", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end this match? All progress will be lost.")
        }
        .alert("TV Code", isPresented: $showingTVCodeAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(tvCodeAlertMessage)
        }
        .sheet(isPresented: $showingTVCodeInput) {
            TVCodeInputView(tvCode: $tvCode, mainTVId: $tvId, onCodeSaved: {
                fetchMatchDataFromWebServer()
            })
        }


    }
    
    // MARK: - Web Server Communication
    private func sendUpdateToWebServer() {
        // Use the scanned TV ID from QR code, or fall back to tvCode for backward compatibility
        let targetTVId = tvId.isEmpty ? tvCode : tvId
        print("🔗 Using TV ID for update: \(targetTVId) (scanned: \(tvId), fallback: \(tvCode))")
        guard !targetTVId.isEmpty else { 
            print("❌ No TV ID available for update")
            return 
        }
        
        let useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        
        if useCloud {
            // Use cloud service
            let cloudURL = UserDefaults.standard.string(forKey: "cloudURL") ?? "https://padelcast-production.up.railway.app"
            
            Task {
                do {
                    let cloudService = PadelCastCloudService(baseURL: cloudURL)
                    var matchData: [String: Any] = [
                        "team1_name": game.team1Name,
                        "team2_name": game.team2Name,
                        "team1_game_score": game.team1GameScore,
                        "team2_game_score": game.team2GameScore,
                        "current_set": game.currentSet,
                        "is_match_finished": game.isMatchFinished,
                        "winning_team": game.winningTeam ?? -1
                    ]
                    
                    // Add set data for best_of_sets
                    for i in 1...game.bestOfSets {
                        let team1Games = game.getGamesForSet(i, team: 1)
                        let team2Games = game.getGamesForSet(i, team: 2)
                        matchData["set\(i)_games"] = [team1Games, team2Games]
                    }
                    
                    // Add super tie-break data if applicable
                    if game.isSuperTiebreak {
                        matchData["super_tiebreak_score"] = [game.superTiebreakScore1, game.superTiebreakScore2]
                    }
                    
                    print("📱 iPhone sending to cloud (\(game.matchFormat.displayName), Current Set: \(game.currentSet)):")
                    for i in 1...game.bestOfSets {
                        let team1Games = game.getGamesForSet(i, team: 1)
                        let team2Games = game.getGamesForSet(i, team: 2)
                        print("   Set \(i): [\(team1Games), \(team2Games)]")
                    }
                    if game.isSuperTiebreak {
                        print("   Super Tie-break: [\(game.superTiebreakScore1), \(game.superTiebreakScore2)]")
                    }
                    print("   Current Set: \(game.currentSet)")
                    
                    try await cloudService.updateMatch(tvId: targetTVId, matchData: matchData)
                    print("✅ Successfully sent update to cloud server")
                } catch {
                    print("❌ Error sending update to cloud server: \(error)")
                }
            }
        } else {
            // Use local server
            let serverIP = UserDefaults.standard.string(forKey: "serverIP") ?? "192.168.100.122"
            let serverPort = UserDefaults.standard.string(forKey: "serverPort") ?? "8080"
            
            let url = URL(string: "http://\(serverIP):\(serverPort)/api/update-match")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 5.0 // 5 second timeout for faster response
            
            var data: [String: Any] = [
                "code": targetTVId,
                "team1_name": game.team1Name,
                "team2_name": game.team2Name,
                "team1_game_score": game.team1GameScore,
                "team2_game_score": game.team2GameScore,
                "current_set": game.currentSet,
                "is_match_finished": game.isMatchFinished,
                "winning_team": game.winningTeam ?? -1
            ]
            
            // Add set data for best_of_sets
            for i in 1...game.bestOfSets {
                let team1Games = game.getGamesForSet(i, team: 1)
                let team2Games = game.getGamesForSet(i, team: 2)
                data["set\(i)_games"] = [team1Games, team2Games]
            }
            
            // Add super tie-break data if applicable
            if game.isSuperTiebreak {
                data["super_tiebreak_score"] = [game.superTiebreakScore1, game.superTiebreakScore2]
            }
            
            print("📱 iPhone sending to local server (\(game.matchFormat.displayName), Current Set: \(game.currentSet)):")
            for i in 1...game.bestOfSets {
                let team1Games = game.getGamesForSet(i, team: 1)
                let team2Games = game.getGamesForSet(i, team: 2)
                print("   Set \(i): [\(team1Games), \(team2Games)]")
            }
            if game.isSuperTiebreak {
                print("   Super Tie-break: [\(game.superTiebreakScore1), \(game.superTiebreakScore2)]")
            }
            print("   Current Set: \(game.currentSet)")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data)
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("❌ Error sending update to web server: \(error)")
                    } else if let data = data {
                        do {
                            let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            if let success = result?["success"] as? Bool, success {
                                print("✅ Successfully sent update to web server")
                            } else {
                                print("❌ Failed to send update to web server")
                            }
                        } catch {
                            print("❌ Error parsing web server response: \(error)")
                        }
                    }
                }.resume()
            } catch {
                print("❌ Error creating request: \(error)")
            }
        }
    }
    
    // MARK: - Fetch Match Data from Web Server
    private func fetchMatchDataFromWebServer() {
        // Use the scanned TV ID from QR code, or fall back to tvCode for backward compatibility
        let targetTVId = tvId.isEmpty ? tvCode : tvId
        print("🔗 Using TV ID for fetch: \(targetTVId) (scanned: \(tvId), fallback: \(tvCode))")
        guard !targetTVId.isEmpty else { 
            print("❌ No TV ID available for fetch")
            return 
        }
        
        let useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        
        if useCloud {
            // Use cloud service
            let cloudURL = UserDefaults.standard.string(forKey: "cloudURL") ?? "https://padelcast-production.up.railway.app"
            
            Task {
                do {
                    let url = URL(string: "\(cloudURL)/api/match-status/\(targetTVId)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let success = result?["success"] as? Bool, success,
                       let matchData = result?["match"] as? [String: Any] {
                        
                        await MainActor.run {
                            // Update team names from cloud server
                            if let team1Name = matchData["team1_name"] as? String {
                                self.game.team1Name = team1Name
                            }
                            if let team2Name = matchData["team2_name"] as? String {
                                self.game.team2Name = team2Name
                            }
                            
                            print("✅ Successfully synced team names from cloud server")
                            print("   Team 1: \(self.game.team1Name)")
                            print("   Team 2: \(self.game.team2Name)")
                        }
                    } else {
                        print("❌ Failed to fetch match data from cloud server")
                    }
                } catch {
                    print("❌ Error fetching match data from cloud server: \(error)")
                }
            }
        } else {
            // Use local server
            let serverIP = UserDefaults.standard.string(forKey: "serverIP") ?? "192.168.100.122"
            let serverPort = UserDefaults.standard.string(forKey: "serverPort") ?? "8080"
            
            let url = URL(string: "http://\(serverIP):\(serverPort)/api/match-status/\(targetTVId)")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("❌ Error fetching match data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("❌ No data received from web server")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let success = result?["success"] as? Bool, success,
                       let matchData = result?["match"] as? [String: Any] {
                        
                        DispatchQueue.main.async {
                            // Update team names from web server
                            if let team1Name = matchData["team1_name"] as? String {
                                self.game.team1Name = team1Name
                            }
                            if let team2Name = matchData["team2_name"] as? String {
                                self.game.team2Name = team2Name
                            }
                            
                            print("✅ Successfully synced team names from web server")
                            print("   Team 1: \(self.game.team1Name)")
                            print("   Team 2: \(self.game.team2Name)")
                        }
                    } else {
                        print("❌ Failed to fetch match data from web server")
                    }
                } catch {
                    print("❌ Error parsing match data: \(error)")
                }
            }.resume()
        }
    }
    

    
    // MARK: - Header Section
    private var headerSection: some View {
                VStack(spacing: 8) {
            HStack {
                Button("End Match") {
                    showingEndMatchAlert = true
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(8)
                

                
                Spacer()
                
                VStack(spacing: 4) {
                    HStack {
                        Button("← Setup") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("PADEL MATCH")
                                .font(.title2)
                                .foregroundColor(.primary)
                            
                                            // Watch connectivity status
                HStack(spacing: 4) {
                    Image(systemName: "applewatch")
                        .foregroundColor(connectivityManager.isConnected ? 
                                       (connectivityManager.isReachable ? .green : .orange) : .red)
                        .font(.caption)
                    Text(connectivityManager.isConnected ? 
                         (connectivityManager.isReachable ? "Watch Connected" : "Watch Paired") : "Watch Disconnected")
                        .font(.caption2)
                        .foregroundColor(connectivityManager.isConnected ? 
                                       (connectivityManager.isReachable ? .green : .orange) : .red)
                }
                

                        }
                        
                        Spacer()
                        
                        // Balance the layout
                        Text("← Setup").opacity(0).font(.headline)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Match status
            if game.isMatchFinished {
                HStack {
                    Text("🏆 MATCH FINISHED")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    if let winner = game.winningTeam {
                        Text("Winner: \(winner == 1 ? game.team1Name : game.team2Name)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            } else {
                // Clean header - removed current set indicator
            }
        }
        .padding(.vertical, 8)
        .background(Color.primary.opacity(0.05))
        .shadow(radius: 2)
    }
    
    // MARK: - Scoring Section
    private var scoringSection: some View {
        HStack(spacing: 0) {
            // Team 1 Side
            teamSide(
                teamName: game.team1Name,
                player1: game.team1Player1,
                player2: game.team1Player2,
                gameScore: game.displayGameScore(for: 1),
                isWinner: game.winningTeam == 1,
                teamNumber: 1
            )
            .background(Color.blue.opacity(0.1))
            
            // Center divider with VS
            VStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1)
                
                Text("VS")
                    .font(.title2)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1)
            }
            .frame(width: 20)
            
            // Team 2 Side
            teamSide(
                teamName: game.team2Name,
                player1: game.team2Player1,
                player2: game.team2Player2,
                gameScore: game.displayGameScore(for: 2),
                isWinner: game.winningTeam == 2,
                teamNumber: 2
            )
            .background(Color.red.opacity(0.1))
        }
    }
    
    // MARK: - Team Side View
    private func teamSide(
        teamName: String,
        player1: String,
        player2: String,
        gameScore: String,
        isWinner: Bool,
        teamNumber: Int
    ) -> some View {
        VStack(spacing: 16) {
            // Team name with winner indicator
            HStack {
                if isWinner {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                }
                
                Text(teamName)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(teamNumber == 1 ? .blue : .red)
                
                if isWinner {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                }
            }
            .padding(.top)
            
            // Player names
            VStack(spacing: 12) {
                Text(player1)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("&")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(player2)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            
            // Sets won display
            VStack(spacing: 6) {
                Text("SETS WON")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text("\(game.countSetsWon(for: teamNumber))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(teamNumber == 1 ? .blue : .red)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            
            Spacer()
            
            // Current game score - large and prominent
            VStack(spacing: 12) {
                Text("CURRENT")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(gameScore)
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(teamNumber == 1 ? .blue : .red)
                    .frame(minHeight: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(20)
            .shadow(radius: 6)
                    
                    Spacer()
            
            // Clean interface - removed redundant Sets Won and Games Won display
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            if !game.isMatchFinished {
                // Point scoring buttons
                HStack(spacing: 20) {
                    Button(action: {
                        game.scorePoint(for: 1)
                        connectivityManager.sendScoreUpdate(team: 1, gameState: game)
                        sendUpdateToWebServer()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                            Text("Point \(game.team1Name)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color.blue)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    
                    Button(action: {
                        game.scorePoint(for: 2)
                        connectivityManager.sendScoreUpdate(team: 2, gameState: game)
                        sendUpdateToWebServer()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                            Text("Point \(game.team2Name)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color.red)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
                
                // Subtraction buttons
                HStack(spacing: 20) {
                    Button(action: {
                        game.subtractPoint(for: 1)
                        connectivityManager.sendScoreUpdate(team: 1, gameState: game)
                        sendUpdateToWebServer()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                            Text("Remove Point \(game.team1Name)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    
                    Button(action: {
                        game.subtractPoint(for: 2)
                        connectivityManager.sendScoreUpdate(team: 2, gameState: game)
                        sendUpdateToWebServer()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                            Text("Remove Point \(game.team2Name)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
            } else {
                // Match finished - show options
            VStack(spacing: 12) {
                    Text("🎉 Match Complete!")
                        .font(.title2)
                        .foregroundColor(.green)
                    
                    if let winner = game.winningTeam {
                        Text("\(winner == 1 ? game.team1Name : game.team2Name) Wins!")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // TV Code Input Button
            Button(action: {
                print("🎾 TV Code Input button tapped!")
                showingTVCodeInput = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "tv")
                        .font(.title2)
                    Text(tvCode.isEmpty ? "Enter TV Code" : "Code: \(tvCode)")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(tvCode.isEmpty ? Color.orange : Color.green)
                .cornerRadius(12)
                .shadow(radius: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
        .padding()
        .background(Color.primary.opacity(0.05))
    }
}

struct PlayerSetupView: View {
    @EnvironmentObject var game: PadelGame
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @State private var showingScorer = false
    @State private var customBestOf = ""
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
                ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🎾 PADEL SCORER")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        
                        Text("Setup your match")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Team 1 Setup
                    teamSetupCard(
                        title: "Team 1",
                        teamName: $game.team1Name,
                        player1: $game.team1Player1,
                        player2: $game.team1Player2,
                        color: .blue
                    )
                    
                    // Team 2 Setup
                    teamSetupCard(
                        title: "Team 2",
                        teamName: $game.team2Name,
                        player1: $game.team2Player1,
                        player2: $game.team2Player2,
                        color: .red
                    )
                    
                    // Match Settings
                    matchSettingsCard
                    
                    // Court Number Setup
                    courtNumberCard
                    
                    // Start Match Button
                    Button("Start Match") {
                        game.resetMatch()
                        showingScorer = true
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.green)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingScorer) {
                ContentView()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImageData: $game.courtLogoData)
            }
            .onChange(of: game.team1Name) { _ in
                connectivityManager.sendGameState(game)
            }
            .onChange(of: game.team2Name) { _ in
                connectivityManager.sendGameState(game)
            }
            .onChange(of: game.team1Player1) { _ in
                connectivityManager.sendGameState(game)
            }
            .onChange(of: game.team1Player2) { _ in
                connectivityManager.sendGameState(game)
            }
            .onChange(of: game.team2Player1) { _ in
                connectivityManager.sendGameState(game)
            }
            .onChange(of: game.team2Player2) { _ in
                connectivityManager.sendGameState(game)
            }
            .onAppear {
                connectivityManager.sendGameState(game)
            }
        }
    }
    
    // MARK: - Team Setup Card
    private func teamSetupCard(
        title: String,
        teamName: Binding<String>,
        player1: Binding<String>,
        player2: Binding<String>,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                    .foregroundColor(color)
                    .font(.title2)
            }
            
            VStack(spacing: 12) {
                TextField("Team Name", text: teamName)
                    .textFieldStyle(.plain)
                    .font(.headline)
                
                TextField("Player 1 Name", text: player1)
                    .textFieldStyle(.plain)
                
                TextField("Player 2 Name", text: player2)
                    .textFieldStyle(.plain)
            }
        }
        .padding(20)
        .background(color.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Match Settings Card
    private var matchSettingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
        HStack {
                Text("Match Format")
                    .font(.title2)
                    .foregroundColor(.purple)
            
            Spacer()
            
                Image(systemName: "trophy.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Match Format")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                // Preset options
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button("One Set (6 games)") {
                            game.setMatchFormat(.oneSet)
                        }
                        .buttonStyle(BestOfButtonStyle(isSelected: game.matchFormat == .oneSet))
                        
                        Button("Pro Set (9 games)") {
                            game.setMatchFormat(.proSet)
                        }
                        .buttonStyle(BestOfButtonStyle(isSelected: game.matchFormat == .proSet))
                    }
                    
                    HStack(spacing: 12) {
                        Button("Best of 3 Sets") {
                            game.setMatchFormat(.bestOf3Sets)
                        }
                        .buttonStyle(BestOfButtonStyle(isSelected: game.matchFormat == .bestOf3Sets))
                        
                        Button("Best of 3 + Super TB") {
                            game.setMatchFormat(.bestOf3WithSuperTiebreak)
                        }
                        .buttonStyle(BestOfButtonStyle(isSelected: game.matchFormat == .bestOf3WithSuperTiebreak))
                    }
                }
                
                // Selected format display
                Text("Selected: \(game.matchFormat.displayName)")
                    .font(.caption)
                    .foregroundColor(.purple)
                    .padding(.top, 4)
            }
        }
        .padding(20)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Court Information Card
    private var courtNumberCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Court Information")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Image(systemName: "building.2.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                // Championship Name
                Text("Championship Name")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                TextField("Enter championship name", text: $game.championshipName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Court Number
                Text("Court Number")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                HStack {
                    Text("Court:")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    
                    TextField("Enter court number", text: $game.courtNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 120)
                }
                
                // Court Logo Upload
                Text("Court Logo")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                HStack {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(.orange)
                            Text("Upload Logo")
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    if game.courtLogoData != nil {
                        Text("✓ Logo uploaded")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                // Preview
                if !game.courtNumber.isEmpty || !game.championshipName.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Preview:")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        
                        if !game.championshipName.isEmpty {
                            Text("Championship: \(game.championshipName)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        if !game.courtNumber.isEmpty {
                            Text("Court: \(game.courtNumber)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(20)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Cloud Service
class PadelCastCloudService: ObservableObject {
    private let baseURL: String
    
    init(baseURL: String = "http://localhost:8080") {
        self.baseURL = baseURL
    }
    
    func linkToTV(tvId: String, team1: String, team2: String, bestOfSets: Int, courtNumber: String, championshipName: String, courtLogoData: Data?, game: PadelGame) async throws -> (matchId: String, tvId: String) {
        let url = URL(string: "\(baseURL)/api/link-tv")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10.0 // 10 second timeout for network requests
        
        var data: [String: Any] = [
            "tv_id": tvId,
            "match_data": [
                "team1_name": team1,
                "team2_name": team2,
                "best_of_sets": bestOfSets,
                "court_number": courtNumber,
                "championship_name": championshipName,
                "team1_player1": game.team1Player1,
                "team1_player2": game.team1Player2,
                "team2_player1": game.team2Player1,
                "team2_player2": game.team2Player2
            ]
        ]
        
        if let logoData = courtLogoData {
            var matchData = data["match_data"] as? [String: Any] ?? [:]
            matchData["court_logo_data"] = logoData.base64EncodedString()
            data["match_data"] = matchData
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        
        print("🔗 Making request to: \(url)")
        print("🔗 Request data: \(data)")
        print("🔗 Sending request...")
        let (responseData, httpResponse) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = httpResponse as? HTTPURLResponse {
            print("🔗 Response status: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("🔗 Error response: \(String(data: responseData, encoding: .utf8) ?? "Unknown")")
            }
        }
        
        print("🔗 Response data: \(String(data: responseData, encoding: .utf8) ?? "Unknown")")
        let response = try JSONDecoder().decode(LinkTVResponse.self, from: responseData)
        
        return (response.match_id, response.tv_id)
    }
    
    func updateMatch(tvId: String, matchData: [String: Any]) async throws {
        let url = URL(string: "\(baseURL)/api/update-match")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5.0 // 5 second timeout for faster response
        
        var data = matchData
        data["tv_id"] = tvId
        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}

struct LinkTVResponse: Codable {
    let success: Bool
    let match_id: String
    let code: String
    let tv_id: String
}

// MARK: - QR Code Scanner (iOS 15.0 Compatible)
struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedTVId: String?
    @Binding var mainTVId: String // Add binding to main ContentView's tvId
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> QRScannerViewController {
        let scanner = QRScannerViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, QRScannerDelegate {
        let parent: QRCodeScannerView
        
        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }
        
        func qrScanner(_ scanner: QRScannerViewController, didScanCode code: String) {
            // Parse the QR code data to extract TV ID
            if let data = code.data(using: .utf8),
               let qrData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let tvId = qrData["tv_id"] as? String {
                print("📱 QR Code scanned successfully - TV ID: \(tvId)")
                parent.scannedTVId = tvId
                parent.mainTVId = tvId // Also update the main ContentView's tvId
                parent.presentationMode.wrappedValue.dismiss()
            } else {
                print("❌ Failed to parse QR code data: \(code)")
            }
        }
        
        func qrScannerDidFail(_ scanner: QRScannerViewController) {
            // Handle failure if needed
        }
    }
}

// MARK: - Custom QR Scanner View Controller
class QRScannerViewController: UIViewController {
    weak var delegate: QRScannerDelegate?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let captureSession = captureSession, !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let captureSession = captureSession, captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    private func setupCamera() {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
        // Add a close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        closeButton.layer.cornerRadius = 20
        closeButton.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Add instructions label
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Point camera at QR code"
        instructionsLabel.textColor = .white
        instructionsLabel.textAlignment = .center
        instructionsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        instructionsLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        instructionsLabel.layer.cornerRadius = 8
        instructionsLabel.frame = CGRect(x: 20, y: view.bounds.height - 100, width: view.bounds.width - 40, height: 40)
        instructionsLabel.textAlignment = .center
        view.addSubview(instructionsLabel)
        
        captureSession.startRunning()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

// MARK: - QR Scanner Delegate
protocol QRScannerDelegate: AnyObject {
    func qrScanner(_ scanner: QRScannerViewController, didScanCode code: String)
    func qrScannerDidFail(_ scanner: QRScannerViewController)
}

// MARK: - AVCapture Metadata Output Delegate
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.qrScanner(self, didScanCode: stringValue)
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            // Resize image to reasonable size for web display
                            let resizedImage = self.resizeImage(image, targetSize: CGSize(width: 200, height: 200))
                            self.parent.selectedImageData = resizedImage.jpegData(compressionQuality: 0.8)
                        }
                    }
                }
            }
        }
        
        private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
    }
}

// MARK: - Best Of Button Style
struct BestOfButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - TV Code Input View
struct TVCodeInputView: View {
    @Binding var tvCode: String
    @Binding var mainTVId: String // Add binding to main ContentView's tvId
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var game: PadelGame
    @State private var tempCode = ""
    @State private var serverIP = "192.168.100.122"
    @State private var serverPort = "8080"
    @State private var cloudURL = "https://padelcast-production.up.railway.app"
    @State private var useCloud = false
    // Team names removed - will be taken from main game state
    @State private var isGeneratingCode = false
    @State private var generatedTVURL = ""
    @State private var showCloudAlert = false
    @State private var cloudAlertMessage = ""
    @State private var showQRScanner = false
    @State private var scannedTVId: String?
    var onCodeSaved: (() -> Void)?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "tv.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("TV Display Setup")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Choose between local server or cloud service")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Cloud vs Local Toggle
                    VStack(spacing: 16) {
                        Text("Connection Type")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Picker("Connection Type", selection: $useCloud) {
                            Text("🌐 Cloud Service").tag(true)
                            Text("💻 Local Server").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 40)
                    }
                
                // Cloud Configuration
                if useCloud {
                    VStack(spacing: 16) {
                        Text("Cloud Service Configuration")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Cloud URL", text: $cloudURL)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        
                        if !cloudURL.isEmpty {
                            Text("Cloud Server: \(cloudURL)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        
                        // Team names removed - will be taken from main setup page
                        

                        
                        // Generate Code Button
                        Button(action: {
                            showQRScanner = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "qrcode.viewfinder")
                                    .foregroundColor(.white)
                                Text("Scan TV QR Code")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        if let scannedTVId = scannedTVId {
                            VStack(spacing: 8) {
                                Text("Connected to TV:")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Text(scannedTVId)
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(8)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Text("TV ID scanned successfully")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    Task {
                                        await testConnection()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "wifi")
                                            .foregroundColor(.white)
                                        Text("Test Connection")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.orange)
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    Task {
                                        await linkToTVFromQR(tvId: scannedTVId)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "link")
                                            .foregroundColor(.white)
                                        Text("Link to TV")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        
                        if !generatedTVURL.isEmpty {
                            VStack(spacing: 8) {
                                Text("Generated TV URL:")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Text(generatedTVURL)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        UIPasteboard.general.string = generatedTVURL
                                    }
                                
                                Text("Tap to copy URL")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                } else {
                    // Local Server Configuration
                    VStack(spacing: 16) {
                        Text("Local Server Configuration")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            TextField("Server IP", text: $serverIP)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                                .keyboardType(.numbersAndPunctuation)
                            
                            TextField("Port", text: $serverPort)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                        }
                        
                        if !serverIP.isEmpty && !serverPort.isEmpty {
                            Text("Server: \(serverIP):\(serverPort)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                // Code Input (for local server)
                if !useCloud {
                    VStack(spacing: 16) {
                        Text("Match Code")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter 6-character code", text: $tempCode)
                            .textFieldStyle(.roundedBorder)
                            .font(.title2)
                            .textInputAutocapitalization(.characters)
                            .onChange(of: tempCode) { newValue in
                                // Convert to uppercase and limit to 6 characters
                                tempCode = String(newValue.uppercased().prefix(6))
                            }
                        
                        if !tempCode.isEmpty {
                            Text("Code: \(tempCode)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                // Instructions removed for cleaner interface
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if useCloud {
                        Button(action: {
                            tvCode = tempCode
                            // Save cloud configuration to UserDefaults
                            UserDefaults.standard.set(cloudURL, forKey: "cloudURL")
                            UserDefaults.standard.set(true, forKey: "useCloud")
                            UserDefaults.standard.set(tempCode, forKey: "tvCode")
                            onCodeSaved?()
                            dismiss()
                        }) {
                            Text("Save Cloud Configuration")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(!cloudURL.isEmpty ? Color.blue : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(cloudURL.isEmpty)
                    } else {
                        Button(action: {
                            tvCode = tempCode
                            // Save server configuration to UserDefaults
                            UserDefaults.standard.set(serverIP, forKey: "serverIP")
                            UserDefaults.standard.set(serverPort, forKey: "serverPort")
                            UserDefaults.standard.set(false, forKey: "useCloud")
                            onCodeSaved?()
                            dismiss()
                        }) {
                            Text("Save Configuration")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(tempCode.count == 6 && !serverIP.isEmpty && !serverPort.isEmpty ? Color.blue : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(tempCode.count != 6 || serverIP.isEmpty || serverPort.isEmpty)
                    }
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
    
    .onAppear {
            tempCode = tvCode
            // Load saved configuration
            if let savedIP = UserDefaults.standard.string(forKey: "serverIP") {
                serverIP = savedIP
            }
            if let savedPort = UserDefaults.standard.string(forKey: "serverPort") {
                serverPort = savedPort
            }
            if let savedCloudURL = UserDefaults.standard.string(forKey: "cloudURL") {
                cloudURL = savedCloudURL
            }
            // Team names removed - will be taken from main game state
            useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        }
        .alert("Cloud Service", isPresented: $showCloudAlert) {
            Button("OK") { }
        } message: {
            Text(cloudAlertMessage)
        }
        .sheet(isPresented: $showQRScanner) {
            QRCodeScannerView(scannedTVId: $scannedTVId, mainTVId: $mainTVId)
        }
    }
    
    private func generateCodeFromCloud() {
        // This function is now replaced with QR code scanning
        // The user should scan the QR code displayed on the TV
        cloudAlertMessage = "Please scan the QR code displayed on your TV to connect automatically."
        showCloudAlert = true
    }
    
    private func testConnection() async {
        print("🔗 Testing connection to Railway server...")
        
        let testURL = "https://padelcast-production.up.railway.app/"
        
        do {
            let url = URL(string: testURL)!
            let (_, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔗 Connection test successful! Status: \(httpResponse.statusCode)")
                await MainActor.run {
                    cloudAlertMessage = "✅ Connection successful! Status: \(httpResponse.statusCode)"
                    showCloudAlert = true
                }
            }
        } catch {
            print("❌ Connection test failed: \(error)")
            await MainActor.run {
                cloudAlertMessage = "❌ Connection failed: \(error.localizedDescription)"
                showCloudAlert = true
            }
        }
    }
    
    private func linkToTVFromQR(tvId: String) async {
        isGeneratingCode = true
        print("🔗 Starting TV linking process for TV ID: \(tvId)")
        
        // Force update to use the correct Railway URL
        let currentCloudURL = "https://padelcast-production.up.railway.app"
        print("🔗 Using Railway URL: \(currentCloudURL)")
        
        Task {
            do {
                print("🔗 Creating cloud service with URL: \(currentCloudURL)")
                let cloudService = PadelCastCloudService(baseURL: currentCloudURL)
                
                print("🔗 Calling linkToTV API...")
                let result = try await cloudService.linkToTV(tvId: tvId, team1: game.team1Name, team2: game.team2Name, bestOfSets: game.bestOfSets, courtNumber: game.courtNumber, championshipName: game.championshipName, courtLogoData: game.courtLogoData, game: game)
                
                print("🔗 API call successful! Result: \(result)")
                
                await MainActor.run {
                    generatedTVURL = "\(cloudURL)/tv/\(result.tvId)"
                    isGeneratingCode = false
                    cloudAlertMessage = "Successfully linked to TV! The TV will now display your match."
                    showCloudAlert = true
                }
            } catch {
                print("❌ Error linking to TV: \(error)")
                if let decodingError = error as? DecodingError {
                    print("❌ Decoding error details: \(decodingError)")
                }
                
                await MainActor.run {
                    isGeneratingCode = false
                    cloudAlertMessage = "Failed to link to TV: \(error.localizedDescription)"
                    showCloudAlert = true
                }
            }
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(PadelGame())
}
