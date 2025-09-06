import Foundation

enum MatchFormat: String, CaseIterable {
    case oneSet = "One Set (6 games)"
    case proSet = "One Set - 9 Games (Pro Set)"
    case bestOf3Sets = "Best of 3 Sets"
    case bestOf3WithSuperTiebreak = "Best of 3 with Super Tie-break"
    
    var displayName: String {
        return self.rawValue
    }
    
    var maxSets: Int {
        switch self {
        case .oneSet, .proSet:
            return 1
        case .bestOf3Sets, .bestOf3WithSuperTiebreak:
            return 3
        }
    }
    
    var setsToWin: Int {
        switch self {
        case .oneSet, .proSet:
            return 1
        case .bestOf3Sets, .bestOf3WithSuperTiebreak:
            return 2
        }
    }
    
    var gamesToWinSet: Int {
        switch self {
        case .oneSet:
            return 6
        case .proSet:
            return 9
        case .bestOf3Sets, .bestOf3WithSuperTiebreak:
            return 6
        }
    }
    
    var hasSuperTiebreak: Bool {
        return self == .bestOf3WithSuperTiebreak
    }
}

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
    @Published var matchFormat: MatchFormat = .bestOf3Sets // Match format type
    @Published var courtNumber = "1" // Court number for display
    @Published var championshipName = "PADELCAST CHAMPIONSHIP" // Championship name for display
    @Published var courtLogoData: Data? = nil // Court logo image data
    @Published var isMatchFinished = false
    @Published var winningTeam: Int? = nil // 1 or 2
    
    // Super tie-break specific
    @Published var isSuperTiebreak = false
    @Published var superTiebreakScore1 = 0
    @Published var superTiebreakScore2 = 0
    
    // Game state
    @Published var isDeuce = false
    @Published var advantageTeam: Int? = nil // 1 or 2
    
    init() {
        resetMatch()
    }
    
    // MARK: - Scoring Methods
    
    func scorePoint(for team: Int) {
        guard !isMatchFinished else { return }
        
        // Handle super tie-break scoring
        if isSuperTiebreak {
            if team == 1 {
                superTiebreakScore1 += 1
            } else {
                superTiebreakScore2 += 1
            }
            checkSuperTiebreakWin()
            return
        }
        
        // Regular game scoring
        if team == 1 {
            team1GameScore += 1
        } else {
            team2GameScore += 1
        }
        
        checkGameWin()
    }
    
    func subtractPoint(for team: Int) {
        guard !isMatchFinished else { return }
        
        // Handle super tie-break scoring
        if isSuperTiebreak {
            if team == 1 {
                if superTiebreakScore1 > 0 {
                    superTiebreakScore1 -= 1
                }
            } else {
                if superTiebreakScore2 > 0 {
                    superTiebreakScore2 -= 1
                }
            }
            return
        }
        
        // Regular game scoring
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
        
        let gamesToWin = matchFormat.gamesToWinSet
        let gamesDiff = team1CurrentSetGames - team2CurrentSetGames
        
        // Check for set win conditions based on match format
        if matchFormat == .proSet {
            // Pro Set: First to 9 games, tiebreak at 8-8
            if team1CurrentSetGames >= 9 || team2CurrentSetGames >= 9 {
                if team1CurrentSetGames > team2CurrentSetGames {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            } else if team1CurrentSetGames == 8 && team2CurrentSetGames == 8 {
                // Tiebreak at 8-8 for Pro Set (simplified - first to 9 wins)
                if team1CurrentSetGames > team2CurrentSetGames {
                    winSet(for: 1)
                } else {
                    winSet(for: 2)
                }
            }
        } else {
            // Standard sets: First to 6 games with 2 game lead, tiebreak at 6-6
            if team1CurrentSetGames >= 6 || team2CurrentSetGames >= 6 {
                if abs(gamesDiff) >= 2 {
                    // Set won with 2 game lead
                    if team1CurrentSetGames > team2CurrentSetGames {
                        winSet(for: 1)
                    } else {
                        winSet(for: 2)
                    }
                } else if team1CurrentSetGames == 7 || team2CurrentSetGames == 7 {
                    // Tiebreak won (first to 7)
                    if team1CurrentSetGames > team2CurrentSetGames {
                        winSet(for: 1)
                    } else {
                        winSet(for: 2)
                    }
                }
                // If 6-6, continue playing (simplified - no tiebreak implementation)
            }
        }
    }
    
    private func winSet(for team: Int) {
        // Check if we need to start super tie-break
        if matchFormat == .bestOf3WithSuperTiebreak && currentSet == 2 {
            let team1SetsWon = countSetsWon(for: 1)
            let team2SetsWon = countSetsWon(for: 2)
            
            // If each team has won one set, start super tie-break instead of set 3
            if team1SetsWon == 1 && team2SetsWon == 1 {
                startSuperTiebreak()
                return
            }
        }
        
        // Move to next set
        currentSet += 1
        
        // Check if match is won
        checkMatchWin()
    }
    
    private func checkMatchWin() {
        let team1SetsWon = countSetsWon(for: 1)
        let team2SetsWon = countSetsWon(for: 2)
        
        // Calculate the minimum sets needed to win based on match format
        let setsToWin = matchFormat.setsToWin
        
        // Check if either team has reached the required number of sets to win
        if team1SetsWon >= setsToWin {
            isMatchFinished = true
            winningTeam = 1
            print("🏆 Team 1 wins the match! Final score: \(team1SetsWon) - \(team2SetsWon)")
        } else if team2SetsWon >= setsToWin {
            isMatchFinished = true
            winningTeam = 2
            print("🏆 Team 2 wins the match! Final score: \(team1SetsWon) - \(team2SetsWon)")
        }
        
        // If we've played all sets and there's a clear winner
        if currentSet > matchFormat.maxSets && !isMatchFinished {
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
        let maxSets = max(team1SetGames.count, team2SetGames.count)
        let gamesToWin = matchFormat.gamesToWinSet
        
        for setIndex in 0..<maxSets {
            let team1Games = setIndex < team1SetGames.count ? team1SetGames[setIndex] : 0
            let team2Games = setIndex < team2SetGames.count ? team2SetGames[setIndex] : 0
            
            if matchFormat == .proSet {
                // Pro Set: first to 9 games
                if team1Games >= 9 && team1Games > team2Games {
                    setsWon += team == 1 ? 1 : 0
                } else if team2Games >= 9 && team2Games > team1Games {
                    setsWon += team == 2 ? 1 : 0
                }
            } else {
                // Standard sets: first to 6 games with 2 game lead, or 7-6 tiebreak
                if team1Games >= 6 && team1Games > team2Games {
                    setsWon += team == 1 ? 1 : 0
                } else if team2Games >= 6 && team2Games > team1Games {
                    setsWon += team == 2 ? 1 : 0
                }
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
        
        // Reset super tie-break
        isSuperTiebreak = false
        superTiebreakScore1 = 0
        superTiebreakScore2 = 0
        
        // Reset all set games arrays
        team1SetGames.removeAll()
        team2SetGames.removeAll()
    }
    
    func resetGame() {
        if isSuperTiebreak {
            superTiebreakScore1 = 0
            superTiebreakScore2 = 0
        } else {
            team1GameScore = 0
            team2GameScore = 0
            isDeuce = false
            advantageTeam = nil
        }
    }
    
    func setMatchFormat(_ format: MatchFormat) {
        matchFormat = format
        resetMatch()
    }
    
    // MARK: - Super Tie-break Methods
    
    private func startSuperTiebreak() {
        isSuperTiebreak = true
        superTiebreakScore1 = 0
        superTiebreakScore2 = 0
        print("🎾 Starting Super Tie-break (first to 10 points, win by 2)")
    }
    
    private func checkSuperTiebreakWin() {
        // Super tie-break: first to 10 points, win by 2
        let scoreDiff = superTiebreakScore1 - superTiebreakScore2
        
        if superTiebreakScore1 >= 10 || superTiebreakScore2 >= 10 {
            if abs(scoreDiff) >= 2 {
                // Super tie-break won
                if superTiebreakScore1 > superTiebreakScore2 {
                    winSuperTiebreak(for: 1)
                } else {
                    winSuperTiebreak(for: 2)
                }
            }
        }
    }
    
    private func winSuperTiebreak(for team: Int) {
        isMatchFinished = true
        winningTeam = team
        print("🏆 Team \(team) wins the Super Tie-break! Final score: \(superTiebreakScore1) - \(superTiebreakScore2)")
    }
    
    // MARK: - Display Helpers
    
    func displayGameScore(for team: Int) -> String {
        // Handle super tie-break display
        if isSuperTiebreak {
            let score = team == 1 ? superTiebreakScore1 : superTiebreakScore2
            return "\(score)"
        }
        
        // Regular game scoring display
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
        if isSuperTiebreak {
            return "\(superTiebreakScore1) - \(superTiebreakScore2)"
        }
        let team1Games = getTeam1GamesForSet(currentSet)
        let team2Games = getTeam2GamesForSet(currentSet)
        return "\(team1Games) - \(team2Games)"
    }
    
    var matchScore: String {
        let team1Sets = countSetsWon(for: 1)
        let team2Sets = countSetsWon(for: 2)
        return "\(team1Sets) - \(team2Sets)"
    }
    
    var bestOfSets: Int {
        return matchFormat.maxSets
    }
}