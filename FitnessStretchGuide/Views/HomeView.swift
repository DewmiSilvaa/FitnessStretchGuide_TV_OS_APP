struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let instructions: String
    let videoURL: String
}

class WorkoutList {
    static let workouts = [
        Workout(
            name: "Squats",
            instructions: "1. Stand with feet shoulder-width apart\n2. Lower your body as if sitting back into a chair\n3. Keep your chest up and back straight\n4. Return to starting position",
            videoURL: "https://firebasestorage.googleapis.com/v0/b/kavinda-f44d7.appspot.com/o/sqauts.mp4?alt=media&token=7218318c-9d20-425b-9ea5-5717edcc4fb0"
        ),
        Workout(
            name: "Push-ups",
            instructions: "1. Start in plank position\n2. Lower your body until chest nearly touches ground\n3. Keep your core tight\n4. Push back up to starting position",
            videoURL: "https://firebasestorage.googleapis.com/v0/b/kavinda-f44d7.appspot.com/o/pushups.mp4?alt=media&token=1533f5e7-7586-446c-8fc7-c55db76a4492"
        )
    ]
}

import SwiftUI
import AVKit

struct HomeView: View {
    @State private var currentIndex = 0
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(WorkoutList.workouts[currentIndex].name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Instructions:")
                        .font(.title2)
                        .foregroundColor(.red)
                    
                    Text(WorkoutList.workouts[currentIndex].instructions)
                        .font(.title3)
                        .foregroundColor(.white)
                        .lineSpacing(10)
                }
                .frame(width: UIScreen.main.bounds.width * 0.3)
                .padding()
                
                VStack {
                    if let player = player {
                        VideoPlayer(player: player)
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.7)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .onChange(of: currentIndex) { _ in
            setupVideo()
        }
        .onAppear {
            setupVideo()
        }
        .onPlayPauseCommand {
            if let player = player {
                if player.timeControlStatus == .playing {
                    player.pause()
                } else {
                    player.play()
                }
            }
        }
        .onMoveCommand { direction in
            switch direction {
            case .right:
                if currentIndex < WorkoutList.workouts.count - 1 {
                    currentIndex += 1
                }
            case .left:
                if currentIndex > 0 {
                    currentIndex -= 1
                }
            default:
                break
            }
        }
    }
    
    private func setupVideo() {
        guard let url = URL(string: WorkoutList.workouts[currentIndex].videoURL) else { return }
        player = AVPlayer(url: url)
        player?.play()
    }
}

#Preview {
    HomeView()
}
