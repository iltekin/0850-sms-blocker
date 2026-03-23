import SwiftUI
import AVKit

struct InstructionVideoView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?

    var body: some View {
        NavigationStack {
            Group {
                if let player {
                    VideoPlayer(player: player)
                        .ignoresSafeArea(.all, edges: .bottom)
                } else {
                    ContentUnavailableView(
                        "Video bulunamadı",
                        systemImage: "film",
                        description: Text("Talimat videosu yüklenemedi.")
                    )
                }
            }
            .navigationTitle("Kurulum Rehberi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
        .onAppear {
            if let url = Bundle.main.url(forResource: "instructions", withExtension: "mov") {
                player = AVPlayer(url: url)
                player?.play()
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}
