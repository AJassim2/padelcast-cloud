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
    
    // Games won in each set (Set 1, Set 2, Set 3, Set 4, Set 5)
    @Published var team1Set1Games = 0
    @Published var team2Set1Games = 0
    @Published var team1Set2Games = 0
    @Published var team2Set2Games = 0
    @Published var team1Set3Games = 0
    @Published var team2Set3Games = 0
    @Published var team1Set4Games = 0
    @Published var team2Set4Games = 0
    @Published var team1Set5Games = 0
    @Published var team2Set5Games = 0
    
    // Current set being played (1-5)
    @Published var currentSet = 1
    
    // Match settings
    @Published var bestOfSets = 3 // Best of 3 or 5 sets
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
        
        // Add game to current set
        switch currentSet {
        case 1:
            if team == 1 {
                team1Set1Games += 1
                print("🎾 Team 1 won game in Set 1. New score: \(team1Set1Games)")
            } else {
                team2Set1Games += 1
                print("🎾 Team 2 won game in Set 1. New score: \(team2Set1Games)")
            }
        case 2:
            if team == 1 {
                team1Set2Games += 1
                print("🎾 Team 1 won game in Set 2. New score: \(team1Set2Games)")
            } else {
                team2Set2Games += 1
                print("🎾 Team 2 won game in Set 2. New score: \(team2Set2Games)")
            }
        case 3:
            if team == 1 {
                team1Set3Games += 1
                print("🎾 Team 1 won game in Set 3. New score: \(team1Set3Games)")
            } else {
                team2Set3Games += 1
                print("🎾 Team 2 won game in Set 3. New score: \(team2Set3Games)")
            }
        case 4:
            if team == 1 {
                team1Set4Games += 1
                print("🎾 Team 1 won game in Set 4. New score: \(team1Set4Games)")
            } else {
                team2Set4Games += 1
                print("🎾 Team 2 won game in Set 4. New score: \(team2Set4Games)")
            }
        case 5:
            if team == 1 {
                team1Set5Games += 1
                print("🎾 Team 1 won game in Set 5. New score: \(team1Set5Games)")
            } else {
                team2Set5Games += 1
                print("🎾 Team 2 won game in Set 5. New score: \(team2Set5Games)")
            }
        default:
            break
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
        let setsToWin = (bestOfSets + 1) / 2 // 2 for best of 3, 3 for best of 5
        
        let team1SetsWon = countSetsWon(for: 1)
        let team2SetsWon = countSetsWon(for: 2)
        
        if team1SetsWon >= setsToWin {
            isMatchFinished = true
            winningTeam = 1
        } else if team2SetsWon >= setsToWin {
            isMatchFinished = true
            winningTeam = 2
        }
    }
    
    func countSetsWon(for team: Int) -> Int {
        var setsWon = 0
        
        // Count sets won by checking which team has more games in each set
        if team1Set1Games > team2Set1Games { setsWon += team == 1 ? 1 : 0 }
        else if team2Set1Games > team1Set1Games { setsWon += team == 2 ? 1 : 0 }
        
        if team1Set2Games > team2Set2Games { setsWon += team == 1 ? 1 : 0 }
        else if team2Set2Games > team1Set2Games { setsWon += team == 2 ? 1 : 0 }
        
        if team1Set3Games > team2Set3Games { setsWon += team == 1 ? 1 : 0 }
        else if team2Set3Games > team1Set3Games { setsWon += team == 2 ? 1 : 0 }
        
        if team1Set4Games > team2Set4Games { setsWon += team == 1 ? 1 : 0 }
        else if team2Set4Games > team1Set4Games { setsWon += team == 2 ? 1 : 0 }
        
        if team1Set5Games > team2Set5Games { setsWon += team == 1 ? 1 : 0 }
        else if team2Set5Games > team1Set5Games { setsWon += team == 2 ? 1 : 0 }
        
        return setsWon
    }
    
    private func getTeam1GamesForSet(_ set: Int) -> Int {
        switch set {
        case 1: return team1Set1Games
        case 2: return team1Set2Games
        case 3: return team1Set3Games
        case 4: return team1Set4Games
        case 5: return team1Set5Games
        default: return 0
        }
    }
    
    private func getTeam2GamesForSet(_ set: Int) -> Int {
        switch set {
        case 1: return team2Set1Games
        case 2: return team2Set2Games
        case 3: return team2Set3Games
        case 4: return team2Set4Games
        case 5: return team2Set5Games
        default: return 0
        }
    }
    
    // MARK: - Utility Methods
    
    func resetMatch() {
        team1GameScore = 0
        team2GameScore = 0
        team1Set1Games = 0
        team2Set1Games = 0
        team1Set2Games = 0
        team2Set2Games = 0
        team1Set3Games = 0
        team2Set3Games = 0
        team1Set4Games = 0
        team2Set4Games = 0
        team1Set5Games = 0
        team2Set5Games = 0
        currentSet = 1
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
        switch set {
        case 1:
            return team == 1 ? team1Set1Games : team2Set1Games
        case 2:
            return team == 1 ? team1Set2Games : team2Set2Games
        case 3:
            return team == 1 ? team1Set3Games : team2Set3Games
        case 4:
            return team == 1 ? team1Set4Games : team2Set4Games
        case 5:
            return team == 1 ? team1Set5Games : team2Set5Games
        default:
            return 0
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