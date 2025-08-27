import Foundation

class PadelGame: ObservableObject {
    // Team names
    @Published var team1Name = "Team 1"
    @Published var team2Name = "Team 2"
    
    // Player names
    @Published var team1Player1 = "Player 1"
    @Published var team1Player2 = "Player 2"
    @Published var team2Player1 = "Player 3"
    @Published var team2Player2 = "Player 4"
    
    // Current game score (simplified - just track games won)
    @Published var team1GameScore = 0
    @Published var team2GameScore = 0
    
    // Sets won
    @Published var team1Sets = 0
    @Published var team2Sets = 0
    
    // Games won in current set
    @Published var team1Games = 0
    @Published var team2Games = 0
    
    // Match settings
    @Published var bestOfSets = 3 // Best of 3, 5, 9, or custom
    @Published var isMatchFinished = false
    @Published var winningTeam: Int? = nil // 1 or 2
    
    // Game state (simplified - no deuce/advantage needed)
    @Published var isDeuce = false
    @Published var advantageTeam: Int? = nil // 1 or 2
    
    init() {
        resetMatch()
    }
    
    // MARK: - Scoring Methods
    
        func scorePoint(for team: Int) {
        guard !isMatchFinished else { return }

        // Simplified scoring: each point = 1 set point
        if team == 1 {
            team1GameScore += 1
        } else {
            team2GameScore += 1
        }

        // Check if this point wins the set
        checkSetWin()
    }

    private func checkSetWin() {
        // First to 6 points wins the set
        if team1GameScore >= 6 && team1GameScore - team2GameScore >= 2 {
            winSet(for: 1)
        } else if team2GameScore >= 6 && team2GameScore - team1GameScore >= 2 {
            winSet(for: 2)
        }
    }
    
    private func winSet(for team: Int) {
        if team == 1 {
            team1Sets += 1
        } else {
            team2Sets += 1
        }
        
        // Reset game scores for next set
        team1GameScore = 0
        team2GameScore = 0
        
        checkMatchWin()
    }
    
    private func checkMatchWin() {
        let setsToWin = (bestOfSets + 1) / 2 // 2 for best of 3, 3 for best of 5, 5 for best of 9
        
        if team1Sets >= setsToWin {
            isMatchFinished = true
            winningTeam = 1
        } else if team2Sets >= setsToWin {
            isMatchFinished = true
            winningTeam = 2
        }
    }
    
    // MARK: - Utility Methods
    
    func resetMatch() {
        team1GameScore = 0
        team2GameScore = 0
        team1Sets = 0
        team2Sets = 0
        isMatchFinished = false
        winningTeam = nil
        isDeuce = false
        advantageTeam = nil
    }
    
    func resetGame() {
        team1GameScore = 0
        team2GameScore = 0
        isDeuce = false
        advantageTeam = nil
    }
    
    // MARK: - Display Helpers
    
    func displayGameScore(for team: Int) -> String {
        let score = team == 1 ? team1GameScore : team2GameScore
        
        // Traditional tennis scoring: 0, 15, 30, 40
        switch score {
        case 0: return "0"
        case 1: return "15"
        case 2: return "30"
        case 3: return "40"
        case 4: return "AD"  // Advantage
        default: return "\(score)"
        }
    }
    
    var currentSetScore: String {
        return "\(team1GameScore) - \(team2GameScore)"
    }
    
    var matchScore: String {
        return "\(team1Sets) - \(team2Sets)"
    }
    
    // MARK: - Best of Configuration
    
    func setBestOf(_ value: Int) {
        bestOfSets = value
        resetMatch()
    }
}