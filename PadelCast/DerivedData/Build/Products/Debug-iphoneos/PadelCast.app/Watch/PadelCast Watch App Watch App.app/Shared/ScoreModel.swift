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
    
    // Current game score (0, 15, 30, 40, deuce, advantage)
    @Published var team1GameScore = 0
    @Published var team2GameScore = 0
    
    // Sets won
    @Published var team1Sets = 0
    @Published var team2Sets = 0
    
    // Games won in current set
    @Published var team1Games = 0
    @Published var team2Games = 0
    
    // Match settings
    @Published var bestOfSets = 3 // Best of 3 or 5 sets
    @Published var isMatchFinished = false
    @Published var winningTeam: Int? = nil // 1 or 2
    
    // Game state
    @Published var isDeuce = false
    @Published var advantageTeam: Int? = nil // 1 or 2
    
    init() {
        resetMatch()
    }
    
    // MARK: - Scoring Methods
    
    func scorePoint(for team: Int) {
        guard !isMatchFinished else { return }
        
        if team == 1 {
            team1GameScore += 1
        } else {
            team2GameScore += 1
        }
        
        checkGameWin()
    }
    
    private func checkGameWin() {
        // Standard tennis scoring: 0, 15, 30, 40
        
        // Check if either team has won the game
        if team1GameScore >= 3 && team2GameScore >= 3 {
            // Deuce situation
            let scoreDiff = team1GameScore - team2GameScore
            
            if abs(scoreDiff) == 1 {
                isDeuce = false
                advantageTeam = scoreDiff > 0 ? 1 : 2
            } else if abs(scoreDiff) >= 2 {
                // Game won
                if team1GameScore > team2GameScore {
                    winGame(for: 1)
                } else {
                    winGame(for: 2)
                }
            } else {
                isDeuce = true
                advantageTeam = nil
            }
        } else if team1GameScore >= 4 || team2GameScore >= 4 {
            // Normal game win (4 points with at least 2 point lead)
            if team1GameScore >= 4 && team1GameScore - team2GameScore >= 2 {
                winGame(for: 1)
            } else if team2GameScore >= 4 && team2GameScore - team1GameScore >= 2 {
                winGame(for: 2)
            }
        }
    }
    
    private func winGame(for team: Int) {
        if team == 1 {
            team1Games += 1
        } else {
            team2Games += 1
        }
        
        // Reset game score
        team1GameScore = 0
        team2GameScore = 0
        isDeuce = false
        advantageTeam = nil
        
        checkSetWin()
    }
    
    private func checkSetWin() {
        // Standard tennis set rules: first to 6 games with 2 game lead, or tiebreak at 6-6
        if team1Games >= 6 || team2Games >= 6 {
            let gamesDiff = team1Games - team2Games
            
            if abs(gamesDiff) >= 2 {
                // Set won with 2 game lead
                if team1Games > team2Games {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            } else if team1Games == 7 || team2Games == 7 {
                // Tiebreak won
                if team1Games > team2Games {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            }
            // If 6-6, continue playing (simplified - no tiebreak implementation)
        }
    }
    
    private func winSet(for team: Int) {
        if team == 1 {
            team1Sets += 1
        } else {
            team2Sets += 1
        }
        
        // Reset games
        team1Games = 0
        team2Games = 0
        
        checkMatchWin()
    }
    
    private func checkMatchWin() {
        let setsToWin = (bestOfSets + 1) / 2 // 2 for best of 3, 3 for best of 5
        
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
        team1Games = 0
        team2Games = 0
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
        
        if isDeuce {
            return "40"
        } else if let advTeam = advantageTeam {
            return advTeam == team ? "AD" : "40"
        } else {
            switch score {
            case 0: return "0"
            case 1: return "15"
            case 2: return "30"
            case 3: return "40"
            default: return "40"
            }
        }
    }
    
    var currentSetScore: String {
        return "\(team1Games) - \(team2Games)"
    }
    
    var matchScore: String {
        return "\(team1Sets) - \(team2Sets)"
    }
}