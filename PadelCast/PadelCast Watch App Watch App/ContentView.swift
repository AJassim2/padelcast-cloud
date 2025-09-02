import SwiftUI

struct ContentView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    // Game state properties from iPhone
    @State private var team1Name = "Blue Team"
    @State private var team2Name = "Red Team"
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
            VStack(spacing: 8) {
                // Header
                headerSection
                
                // Game status
                if isMatchFinished {
                    matchFinishedSection
                } else {
                    // Add Point buttons
                    addPointButtons
                    
                    // Remove Point buttons
                    removePointButtons
                }
                
                // Connectivity status
                connectivityStatus
            }
            .padding()
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
        }
    }
    
    // MARK: - Add Point Buttons
    private var addPointButtons: some View {
        HStack(spacing: 16) {
                // Team 1 Add Point Button
                Button(action: {
                    print("🎾 Watch: Team 1 scored a point!")
                    connectivityManager.sendScorePoint(team: 1)
                }) {
                                    VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(team1Name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .truncationMode(.tail)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                // Team 2 Add Point Button
                Button(action: {
                    print("🎾 Watch: Team 2 scored a point!")
                    connectivityManager.sendScorePoint(team: 2)
                }) {
                                    VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(team2Name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .truncationMode(.tail)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.red)
                    .cornerRadius(12)
                }
            }
    }
    
    // MARK: - Remove Point Buttons
    private var removePointButtons: some View {
        HStack(spacing: 16) {
                // Team 1 Remove Point Button
                Button(action: {
                    print("🎾 Watch: Team 1 point removed!")
                    connectivityManager.sendRemovePoint(team: 1)
                }) {
                                    VStack(spacing: 4) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(team1Name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .truncationMode(.tail)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(12)
                }
                
                // Team 2 Remove Point Button
                Button(action: {
                    print("🎾 Watch: Team 2 point removed!")
                    connectivityManager.sendRemovePoint(team: 2)
                }) {
                                    VStack(spacing: 4) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(team2Name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .truncationMode(.tail)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(12)
                }
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
        
        print("📱 Watch: Updating UI with game data: \(data)")
        print("📱 Watch: team1Name in data: \(data["team1Name"] ?? "NOT FOUND")")
        print("📱 Watch: team2Name in data: \(data["team2Name"] ?? "NOT FOUND")")
        
        if let team1 = data["team1Name"] as? String {
            print("📱 Watch: Setting team1Name to: \(team1)")
            team1Name = team1
        } else {
            print("📱 Watch: team1Name not found or not a string")
        }
        if let team2 = data["team2Name"] as? String {
            print("📱 Watch: Setting team2Name to: \(team2)")
            team2Name = team2
        } else {
            print("📱 Watch: team2Name not found or not a string")
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