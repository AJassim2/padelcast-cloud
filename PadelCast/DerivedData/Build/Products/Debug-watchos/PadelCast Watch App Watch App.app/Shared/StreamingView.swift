import SwiftUI
import AVKit
import MediaPlayer

struct StreamingView: View {
    @EnvironmentObject var game: PadelGame
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("PADEL MATCH")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                    
                    Text("LIVE STREAM")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 5)
                }
                .padding(.top, 40)
                
                // AirPlay Controls
                HStack(spacing: 20) {
                    Button(action: {
                        // Show AirPlay menu
                        let airPlayButton = MPVolumeView()
                        airPlayButton.showsRouteButton = true
                        airPlayButton.showsVolumeSlider = false
                        
                        if let airPlayButton = airPlayButton.subviews.first(where: { $0 is UIButton }) as? UIButton {
                            airPlayButton.sendActions(for: .touchUpInside)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "airplayvideo")
                                .font(.title2)
                            Text("AirPlay to TV")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                            Text("Close")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                // Match Status
                if game.isMatchFinished {
                    VStack(spacing: 20) {
                        Text("MATCH COMPLETE")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .shadow(color: .black, radius: 8)
                        
                        Text("Winner: \(game.winningTeam == 1 ? game.team1Name : game.team2Name)")
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 6)
                    }
                } else {
                    // Current Set Display
                    VStack(spacing: 15) {
                        Text("SET \(game.currentSet)")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                            .shadow(color: .black, radius: 8)
                        
                        Text("Best of \(game.bestOfSets)")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: .black, radius: 4)
                    }
                }
                
                Spacer()
                
                // Teams and Scores
                HStack(spacing: 60) {
                    // Team 1
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text(game.team1Name)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 6)
                                .multilineTextAlignment(.center)
                            
                            Text("\(game.team1Player1) & \(game.team1Player2)")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black, radius: 4)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 10) {
                            // Sets
                            HStack(spacing: 15) {
                                ForEach(1...game.bestOfSets, id: \.self) { setNumber in
                                    Text("\(setNumber <= game.team1Sets ? "●" : "○")")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(setNumber <= game.team1Sets ? .green : .white.opacity(0.3))
                                        .shadow(color: .black, radius: 4)
                                }
                            }
                            
                            // Current Game Score
                            Text(game.displayGameScore(for: 1))
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // VS Separator
                    VStack {
                        Text("VS")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                            .shadow(color: .black, radius: 6)
                        
                        if game.isDeuce {
                            Text("DEUCE")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                                .shadow(color: .black, radius: 4)
                        } else if let advantageTeam = game.advantageTeam {
                            Text("ADV")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 4)
                        }
                    }
                    
                    // Team 2
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text(game.team2Name)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 6)
                                .multilineTextAlignment(.center)
                            
                            Text("\(game.team2Player1) & \(game.team2Player2)")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black, radius: 4)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 10) {
                            // Sets
                            HStack(spacing: 15) {
                                ForEach(1...game.bestOfSets, id: \.self) { setNumber in
                                    Text("\(setNumber <= game.team2Sets ? "●" : "○")")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(setNumber <= game.team2Sets ? .green : .white.opacity(0.3))
                                        .shadow(color: .black, radius: 4)
                                }
                            }
                            
                            // Current Game Score
                            Text(game.displayGameScore(for: 2))
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Footer
                VStack(spacing: 10) {
                    Text("Streamed from PadelCast")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .shadow(color: .black, radius: 3)
                    
                    Text(Date().formatted(date: .abbreviated, time: .shortened))
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .shadow(color: .black, radius: 2)
                }
                .padding(.bottom, 40)
                

            }
        }
        .onAppear {
            // Auto-refresh every second for live updates
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                // Force view update
            }
        }
    }
}

#Preview {
    StreamingView()
        .environmentObject(PadelGame())
}
