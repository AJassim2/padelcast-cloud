import SwiftUI
import AVKit
import MediaPlayer

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
                games: game.team1Games,
                points: game.team1GameScore,
                color: .blue
            )
            
            TVVSView(currentSet: game.team1Sets + game.team2Sets + 1)
            
            TVTeamView(
                teamName: game.team2Name,
                player1: game.team2Player1,
                player2: game.team2Player2,
                games: game.team2Games,
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
                Text("Best of \(game.bestOfSets) Sets")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Set \(game.team1Sets + game.team2Sets + 1) of \(game.bestOfSets)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.yellow)
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
    @State private var showingTVCodeAlert = false
    @State private var tvCodeAlertMessage = ""
    
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
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchResetGame)) { _ in
            game.resetGame()
            connectivityManager.sendGameState(game)
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchResetMatch)) { _ in
            game.resetMatch()
            connectivityManager.sendGameState(game)
        }
                            .onReceive(NotificationCenter.default.publisher(for: .watchRequestGameState)) { _ in
            connectivityManager.sendGameState(game)
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
            TVCodeInputView(tvCode: $tvCode, onCodeSaved: {
                fetchMatchDataFromWebServer()
            })
        }

    }
    
    // MARK: - Web Server Communication
    private func sendUpdateToWebServer() {
        guard !tvCode.isEmpty else { return }
        
        let useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        
        if useCloud {
            // Use cloud service
            let cloudURL = UserDefaults.standard.string(forKey: "cloudURL") ?? "http://localhost:8080"
            
            Task {
                do {
                    let cloudService = PadelCastCloudService(baseURL: cloudURL)
                    let matchData: [String: Any] = [
                        "team1_name": game.team1Name,
                        "team2_name": game.team2Name,
                        "team1_game_score": game.team1GameScore,
                        "team2_game_score": game.team2GameScore,
                        "team1_games": game.team1Games,
                        "team2_games": game.team2Games,
                        "team1_sets": game.team1Sets,
                        "team2_sets": game.team2Sets,
                        "is_match_finished": game.isMatchFinished,
                        "winning_team": game.winningTeam ?? -1
                    ]
                    
                    try await cloudService.updateMatch(code: tvCode, matchData: matchData)
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
            
            let data: [String: Any] = [
                "code": tvCode,
                "team1_name": game.team1Name,
                "team2_name": game.team2Name,
                "team1_game_score": game.team1GameScore,
                "team2_game_score": game.team2GameScore,
                "team1_games": game.team1Games,
                "team2_games": game.team2Games,
                "team1_sets": game.team1Sets,
                "team2_sets": game.team2Sets,
                "is_match_finished": game.isMatchFinished,
                "winning_team": game.winningTeam ?? -1
            ]
            
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
        guard !tvCode.isEmpty else { return }
        
        let useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        
        if useCloud {
            // Use cloud service
            let cloudURL = UserDefaults.standard.string(forKey: "cloudURL") ?? "http://localhost:8080"
            
            Task {
                do {
                    let url = URL(string: "\(cloudURL)/api/match-status/\(tvCode)")!
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
            
            let url = URL(string: "http://\(serverIP):\(serverPort)/api/match-status/\(tvCode)")!
            
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
                HStack {
                    Text("Sets: \(game.matchScore)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Games: \(game.currentSetScore)")
                        .font(.headline)
            
            Spacer()
                    
                    Text("Best of \(game.bestOfSets)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
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
                    .frame(width: 2)
                
                Text("VS")
                    .font(.title)
                    .padding(.vertical, 8)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 2)
            }
            .frame(width: 40)
            
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
                        .font(.title2)
                }
                
                Text(teamName)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(teamNumber == 1 ? .blue : .red)
                
                if isWinner {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)
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
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(player2)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Current game score - large and prominent
            VStack(spacing: 8) {
                Text("CURRENT")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(gameScore)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(teamNumber == 1 ? .blue : .red)
                    .frame(minHeight: 80)
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(16)
            .shadow(radius: 4)
                    
                    Spacer()
            
            // Score breakdown
            VStack(spacing: 4) {
                HStack {
                    Text("Sets Won:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(teamNumber == 1 ? game.team1Sets : game.team2Sets)")
                        .font(.headline)
                        .foregroundColor(teamNumber == 1 ? .blue : .red)
                }
                
                HStack {
                    Text("Games Won:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(teamNumber == 1 ? game.team1Games : game.team2Games)")
                        .font(.headline)
                        .foregroundColor(teamNumber == 1 ? .blue : .red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom)
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
                        .frame(height: 80)
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
                        .frame(height: 80)
                        .background(Color.red)
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
            
            // Reset buttons
            HStack(spacing: 16) {
                Button("Reset Game") {
                    game.resetGame()
                    connectivityManager.sendGameReset()
                    sendUpdateToWebServer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .cornerRadius(8)
                
                Button("Reset Match") {
                    game.resetMatch()
                    connectivityManager.sendMatchReset()
                    sendUpdateToWebServer()
                }
                .padding(.horizontal, 24)
            .padding(.vertical, 12)
                .background(Color.purple.opacity(0.1))
                .foregroundColor(.purple)
                .cornerRadius(8)
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
            
            Picker("Match Format", selection: $game.bestOfSets) {
                Text("Best of 3 Sets").tag(3)
                Text("Best of 5 Sets").tag(5)
            }
            .pickerStyle(.segmented)
        }
        .padding(20)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Cloud Service
class PadelCastCloudService: ObservableObject {
    private let baseURL: String
    
    init(baseURL: String = "http://localhost:8080") {
        self.baseURL = baseURL
    }
    
    func generateCode(team1: String, team2: String) async throws -> (code: String, tvURL: String) {
        let url = URL(string: "\(baseURL)/generate-code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = [
            "team1_name": team1,
            "team2_name": team2
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(CodeResponse.self, from: responseData)
        
        return (response.code, "\(baseURL)/tv/\(response.code)")
    }
    
    func updateMatch(code: String, matchData: [String: Any]) async throws {
        let url = URL(string: "\(baseURL)/api/update-match")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var data = matchData
        data["code"] = code
        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}

struct CodeResponse: Codable {
    let success: Bool
    let code: String
    let match_id: String
    let tv_url: String
}

// MARK: - TV Code Input View
struct TVCodeInputView: View {
    @Binding var tvCode: String
    @Environment(\.dismiss) private var dismiss
    @State private var tempCode = ""
    @State private var serverIP = "192.168.100.122"
    @State private var serverPort = "8080"
    @State private var cloudURL = "http://localhost:8080"
    @State private var useCloud = false
    @State private var team1Name = "Team A"
    @State private var team2Name = "Team B"
    @State private var isGeneratingCode = false
    @State private var generatedTVURL = ""
    @State private var showCloudAlert = false
    @State private var cloudAlertMessage = ""
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
                        
                        // Team Names for Cloud
                        VStack(spacing: 12) {
                            Text("Team Names")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 12) {
                                TextField("Team 1", text: $team1Name)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.body)
                                
                                TextField("Team 2", text: $team2Name)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.body)
                            }
                        }
                        
                        // Generate Code Button
                        Button(action: generateCodeFromCloud) {
                            HStack {
                                if isGeneratingCode {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "cloud.fill")
                                        .foregroundColor(.white)
                                }
                                Text(isGeneratingCode ? "Generating..." : "Generate Code from Cloud")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .disabled(isGeneratingCode || team1Name.isEmpty || team2Name.isEmpty)
                        
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
                
                // Instructions
                VStack(spacing: 12) {
                    Text(useCloud ? "Cloud Service Instructions:" : "Local Server Instructions:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if useCloud {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Enter your cloud URL above")
                            Text("2. Enter team names")
                            Text("3. Tap 'Generate Code from Cloud'")
                            Text("4. Copy the TV URL to your TV browser")
                            Text("5. Start scoring in the app")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Open your web browser")
                            Text("2. Go to: http://\(serverIP):\(serverPort)")
                            Text("3. Enter team names and generate code")
                            Text("4. Enter the code here")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if useCloud {
                        Button(action: {
                            // Save cloud configuration to UserDefaults
                            UserDefaults.standard.set(cloudURL, forKey: "cloudURL")
                            UserDefaults.standard.set(team1Name, forKey: "team1Name")
                            UserDefaults.standard.set(team2Name, forKey: "team2Name")
                            UserDefaults.standard.set(true, forKey: "useCloud")
                            onCodeSaved?()
                            dismiss()
                        }) {
                            Text("Save Cloud Configuration")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(!cloudURL.isEmpty && !team1Name.isEmpty && !team2Name.isEmpty ? Color.blue : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(cloudURL.isEmpty || team1Name.isEmpty || team2Name.isEmpty)
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
            if let savedTeam1 = UserDefaults.standard.string(forKey: "team1Name") {
                team1Name = savedTeam1
            }
            if let savedTeam2 = UserDefaults.standard.string(forKey: "team2Name") {
                team2Name = savedTeam2
            }
            useCloud = UserDefaults.standard.bool(forKey: "useCloud")
        }
        .alert("Cloud Service", isPresented: $showCloudAlert) {
            Button("OK") { }
        } message: {
            Text(cloudAlertMessage)
        }
    }
    
    private func generateCodeFromCloud() {
        isGeneratingCode = true
        
        Task {
            do {
                let cloudService = PadelCastCloudService(baseURL: cloudURL)
                let result = try await cloudService.generateCode(team1: team1Name, team2: team2Name)
                
                await MainActor.run {
                    tempCode = result.code
                    generatedTVURL = result.tvURL
                    isGeneratingCode = false
                    cloudAlertMessage = "Code generated successfully! Copy the TV URL to your TV browser."
                    showCloudAlert = true
                }
            } catch {
                await MainActor.run {
                    isGeneratingCode = false
                    cloudAlertMessage = "Failed to generate code: \(error.localizedDescription)"
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
