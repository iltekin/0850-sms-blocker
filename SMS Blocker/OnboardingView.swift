import SwiftUI

struct OnboardingView: View {

    let onComplete: () -> Void
    @State private var didOpenSettings = false
    @State private var showVideo = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                            .padding(.top, 14)
                    }

                    VStack(spacing: 8) {
                        Text("0850 SMS Engelleyici")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("0850 ile başlayan numaralardan gelen tüm SMS'leri otomatik olarak engeller")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Text("Filtreyi etkinleştirmek için\naşağıdaki adımları takip edin")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                    }

                    VStack(spacing: 0) {
                        stepRow(number: 1, icon: "gearshape", text: "Ayarlar'ı açın")
                        Divider().padding(.leading, 52)
                        stepRow(number: 2, icon: "square.grid.2x2", text: "Uygulamalar'a gidin")
                        Divider().padding(.leading, 52)
                        stepRow(number: 3, icon: "message", text: "Mesajlar → Bilinmeyen ve Spam")
                        Divider().padding(.leading, 52)
                        stepRow(number: 4, icon: "checkmark.shield", text: "\"0850 Engelleyici\"yi açın")
                    }
                    .padding(.vertical, 4)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Button {
                        showVideo = true
                    } label: {
                        Label("Videoyu İzle", systemImage: "play.circle.fill")
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue.opacity(0.12))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 24)
            }

            Button {
                didOpenSettings = true
                if let url = URL(string: "App-Prefs:root=MESSAGES") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("Ayarları Aç", systemImage: "arrow.up.forward.app")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
            .padding(.top, 12)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showVideo) {
            InstructionVideoView()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && didOpenSettings {
                onComplete()
            }
        }
    }

    private func stepRow(number: Int, icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .frame(width: 26, height: 26)
                .background(Color.blue.opacity(0.12))
                .foregroundStyle(.blue)
                .clipShape(Circle())

            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.blue)
                .frame(width: 22)

            Text(text)
                .font(.subheadline)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
