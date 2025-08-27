import SwiftUI

struct ContentView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    // Game state properties from iPhone
    @State private var team1Name = "Team 1"
    @State private var team2Name = "Team 2"
    @State private var currentGameScore1 = "0"
    @State private var currentGameScore2 = "0"
    @State private var team1Sets = 0
    @State private var team2Sets = 0
    @State private var team1Games = 0
    @State private var team2Games = 0
    @State private var isMatchFinished = false
    @State private var winningTeam: Int? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    headerSection
                    
                    // Game status
                    if isMatchFinished {
                        matchFinishedSection
                    } else {
                        // Current scores - simplified
                        scoreSection
                        
                        // Scoring buttons - more prominent
                        scoringButtons
                        
                        // Reset buttons
                        resetButtons
                    }
                    
                    // Connectivity status
                    connectivityStatus
                }
                .padding()
            }
        }
        .onReceive(connectivityManager.$gameData) { gameData in
            updateGameState(from: gameData)
        }
        .onAppear {
            connectivityManager.requestGameState()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Padel Score")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Watch Controller")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Score Section (Simplified)
    private var scoreSection: some View {
        VStack(spacing: 12) {
            // Team 1 Score
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(team1Name)
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("Game")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(currentGameScore1)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Games")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(team1Games)")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Sets")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(team1Sets)")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // VS Separator
            Text("VS")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 4)
            
            // Team 2 Score
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(team2Name)
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("Game")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(currentGameScore2)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Games")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(team2Games)")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Sets")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(team2Sets)")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Scoring Buttons (More Prominent)
    private var scoringButtons: some View {
        VStack(spacing: 12) {
            Text("Add Point")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                // Team 1 Score Button
                Button(action: {
                    print("🎾 Watch: Team 1 scored a point!")
                    connectivityManager.sendScorePoint(team: 1)
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text(team1Name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                // Team 2 Score Button
                Button(action: {
                    print("🎾 Watch: Team 2 scored a point!")
                    connectivityManager.sendScorePoint(team: 2)
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text(team2Name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.red)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Reset Buttons
    private var resetButtons: some View {
        HStack(spacing: 12) {
            Button("Reset Game") {
                connectivityManager.sendResetGame()
            }
            .buttonStyle(.bordered)
            .font(.caption)
            
            Button("Reset Match") {
                connectivityManager.sendResetMatch()
            }
            .buttonStyle(.bordered)
            .font(.caption)
        }
    }
    
    // MARK: - Match Finished Section
    private var matchFinishedSection: some View {
        VStack(spacing: 8) {
            Text("🏆 Match Finished!")
                .font(.headline)
                .foregroundColor(.green)
            
            if let winner = winningTeam {
                Text("Winner: \(winner == 1 ? team1Name : team2Name)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Button("New Match") {
                connectivityManager.sendResetMatch()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Connectivity Status
    private var connectivityStatus: some View {
        HStack(spacing: 6) {
            Image(systemName: connectivityManager.isReachable ? "iphone" : "iphone.slash")
                .foregroundColor(connectivityManager.isReachable ? .green : .orange)
                .font(.caption)
            
            Text(connectivityManager.isReachable ? "iPhone Connected" : "iPhone Not Available")
                .font(.caption2)
                .foregroundColor(connectivityManager.isReachable ? .green : .orange)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Update Game State
    private func updateGameState(from gameData: [String: Any]?) {
        guard let data = gameData else { return }
        
        print("Updating Watch UI with game data: \(data)")
        
        if let team1 = data["team1Name"] as? String {
            team1Name = team1
        }
        if let team2 = data["team2Name"] as? String {
            team2Name = team2
        }
        if let score1 = data["currentGameScore1"] as? String {
            currentGameScore1 = score1
        }
        if let score2 = data["currentGameScore2"] as? String {
            currentGameScore2 = score2
        }
        if let games1 = data["team1Games"] as? Int {
            team1Games = games1
        }
        if let games2 = data["team2Games"] as? Int {
            team2Games = games2
        }
        if let sets1 = data["team1Sets"] as? Int {
            team1Sets = sets1
        }
        if let sets2 = data["team2Sets"] as? Int {
            team2Sets = sets2
        }
        if let finished = data["isMatchFinished"] as? Bool {
            isMatchFinished = finished
        }
        if let winner = data["winningTeam"] as? Int, winner != -1 {
            winningTeam = winner
        } else {
            winningTeam = nil
        }
    }
}

#Preview {
    ContentView()
}