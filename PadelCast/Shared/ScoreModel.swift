import Foundation

class PadelGame: ObservableObject {
    // Team names
    @Published var team1Name = "Blue Team"
    @Published var team2Name = "Red Team"
    
    // Player names
    @Published var team1Player1 = "Player 1"
    @Published var team1Player2 = "Player 2"
    @Published var team2Player1 = "Player 3"
    @Published var team2Player2 = "Player 4"
    
    // Current game score (0, 15, 30, 40, deuce, advantage)
    @Published var team1GameScore = 0
    @Published var team2GameScore = 0
    
    // Games won in each set - dynamic array to handle any number of sets
    @Published var team1SetGames: [Int] = []
    @Published var team2SetGames: [Int] = []
    
    // Current set being played (1-9)
    @Published var currentSet = 1
    
    // Match settings
    @Published var bestOfSets = 3 // Best of 3, 5, or 9 sets
    @Published var courtNumber = "1" // Court number for display
    @Published var championshipName = "PADELCAST CHAMPIONSHIP" // Championship name for display
    @Published var courtLogoData: Data? = nil // Court logo image data
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
    
    func subtractPoint(for team: Int) {
        guard !isMatchFinished else { return }
        
        if team == 1 {
            if team1GameScore > 0 {
                team1GameScore -= 1
            }
        } else {
            if team2GameScore > 0 {
                team2GameScore -= 1
            }
        }
        
        // Reset deuce state when subtracting points
        if team1GameScore < 3 || team2GameScore < 3 {
            isDeuce = false
            advantageTeam = nil
        } else {
            checkGameWin()
        }
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
        print("🎾 winGame called for team \(team) in set \(currentSet)")
        
        // Ensure arrays are large enough for current set
        while team1SetGames.count < currentSet {
            team1SetGames.append(0)
        }
        while team2SetGames.count < currentSet {
            team2SetGames.append(0)
        }
        
        // Add game to current set (arrays are 0-indexed, so subtract 1)
        let setIndex = currentSet - 1
        
        if team == 1 {
            team1SetGames[setIndex] += 1
            print("🎾 Team 1 won game in Set \(currentSet). New score: \(team1SetGames[setIndex])")
        } else {
            team2SetGames[setIndex] += 1
            print("🎾 Team 2 won game in Set \(currentSet). New score: \(team2SetGames[setIndex])")
        }
        
        // Reset game score
        team1GameScore = 0
        team2GameScore = 0
        isDeuce = false
        advantageTeam = nil
        
        checkSetWin()
    }
    
    private func checkSetWin() {
        let team1CurrentSetGames = getTeam1GamesForSet(currentSet)
        let team2CurrentSetGames = getTeam2GamesForSet(currentSet)
        
        // Standard tennis set rules: first to 6 games with 2 game lead
        if team1CurrentSetGames >= 6 || team2CurrentSetGames >= 6 {
            let gamesDiff = team1CurrentSetGames - team2CurrentSetGames
            
            if abs(gamesDiff) >= 2 {
                // Set won with 2 game lead
                if team1CurrentSetGames > team2CurrentSetGames {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            } else if team1CurrentSetGames == 7 || team2CurrentSetGames == 7 {
                // Tiebreak won
                if team1CurrentSetGames > team2CurrentSetGames {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            }
            // If 6-6, continue playing (simplified - no tiebreak implementation)
        }
    }
    
    private func winSet(for team: Int) {
        // Move to next set
        currentSet += 1
        
        // Check if match is won
        checkMatchWin()
    }
    
    private func checkMatchWin() {
        let team1SetsWon = countSetsWon(for: 1)
        let team2SetsWon = countSetsWon(for: 2)
        
        // Calculate the minimum sets needed to win
        let setsToWin = (bestOfSets + 1) / 2
        
        // Check if either team has reached the required number of sets to win
        // AND if the other team cannot catch up even if they win all remaining sets
        let remainingSets = bestOfSets - currentSet + 1
        
        // Team 1 wins if they have enough sets AND Team 2 cannot catch up
        if team1SetsWon >= setsToWin && (team1SetsWon - team2SetsWon) > remainingSets {
            isMatchFinished = true
            winningTeam = 1
            print("🏆 Team 1 wins the match! Final score: \(team1SetsWon) - \(team2SetsWon)")
        }
        // Team 2 wins if they have enough sets AND Team 1 cannot catch up
        else if team2SetsWon >= setsToWin && (team2SetsWon - team1SetsWon) > remainingSets {
            isMatchFinished = true
            winningTeam = 2
            print("🏆 Team 2 wins the match! Final score: \(team1SetsWon) - \(team2SetsWon)")
        }
        
        // If we've played all sets and there's a clear winner
        if currentSet > bestOfSets && !isMatchFinished {
            if team1SetsWon > team2SetsWon {
                isMatchFinished = true
                winningTeam = 1
                print("🏆 Team 1 wins after all sets! Final score: \(team1SetsWon) - \(team2SetsWon)")
            } else if team2SetsWon > team1SetsWon {
                isMatchFinished = true
                winningTeam = 2
                print("🏆 Team 2 wins after all sets! Final score: \(team1SetsWon) - \(team2SetsWon)")
            } else {
                // This would be a tie, which shouldn't happen in best of N
                print("⚠️ Unexpected tie after all sets: \(team1SetsWon) - \(team2SetsWon)")
            }
        }
    }
    
    func countSetsWon(for team: Int) -> Int {
        var setsWon = 0
        
        // Count sets won by checking which team has more games in each set
        // Only count sets as won when a team reaches 6+ games and has more games than the other team
        let maxSets = max(team1SetGames.count, team2SetGames.count)
        
        for setIndex in 0..<maxSets {
            let team1Games = setIndex < team1SetGames.count ? team1SetGames[setIndex] : 0
            let team2Games = setIndex < team2SetGames.count ? team2SetGames[setIndex] : 0
            
            if team1Games >= 6 && team1Games > team2Games {
                setsWon += team == 1 ? 1 : 0
            } else if team2Games >= 6 && team2Games > team1Games {
                setsWon += team == 2 ? 1 : 0
            }
        }
        
        return setsWon
    }
    
    private func getTeam1GamesForSet(_ set: Int) -> Int {
        let setIndex = set - 1 // Convert to 0-based index
        return setIndex < team1SetGames.count ? team1SetGames[setIndex] : 0
    }
    
    private func getTeam2GamesForSet(_ set: Int) -> Int {
        let setIndex = set - 1 // Convert to 0-based index
        return setIndex < team2SetGames.count ? team2SetGames[setIndex] : 0
    }
    
    // MARK: - Utility Methods
    
    func resetMatch() {
        team1GameScore = 0
        team2GameScore = 0
        currentSet = 1
        isMatchFinished = false
        winningTeam = nil
        isDeuce = false
        advantageTeam = nil
        
        // Reset all set games arrays
        team1SetGames.removeAll()
        team2SetGames.removeAll()
    }
    
    func resetGame() {
        team1GameScore = 0
        team2GameScore = 0
        isDeuce = false
        advantageTeam = nil
    }
    
    func setBestOf(_ value: Int) {
        bestOfSets = value
        resetMatch()
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
    
    // Get games for a specific set
    func getGamesForSet(_ set: Int, team: Int) -> Int {
        let setIndex = set - 1 // Convert to 0-based index
        if team == 1 {
            return setIndex < team1SetGames.count ? team1SetGames[setIndex] : 0
        } else {
            return setIndex < team2SetGames.count ? team2SetGames[setIndex] : 0
        }
    }
    
    var currentSetScore: String {
        let team1Games = getTeam1GamesForSet(currentSet)
        let team2Games = getTeam2GamesForSet(currentSet)
        return "\(team1Games) - \(team2Games)"
    }
    
    var matchScore: String {
        let team1Sets = countSetsWon(for: 1)
        let team2Sets = countSetsWon(for: 2)
        return "\(team1Sets) - \(team2Sets)"
    }
}