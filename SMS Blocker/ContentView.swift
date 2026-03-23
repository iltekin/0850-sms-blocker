import SwiftUI

struct ContentView: View {

    @State private var viewModel = FilterViewModel()
    @State private var showVideo = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        if viewModel.hasSeenOnboarding {
            homeView
        } else {
            OnboardingView {
                withAnimation { viewModel.hasSeenOnboarding = true }
            }
        }
    }

    // MARK: - Home

    private var homeView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    toggleCard
                    setupInstructions
                    privacyBadge
                    twitterLink
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showVideo) {
                InstructionVideoView()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 14) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .padding(.top, 14)

            Text("0850 SMS Engelleyici")
                .font(.title)
                .fontWeight(.bold)

            Text("0850 ile başlayan numaralardan gelen tüm SMS'leri otomatik olarak engeller")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Toggle

    private var toggleCard: some View {
        Toggle(isOn: $viewModel.isFilteringEnabled) {
            Label("Filtreleme Durumu", systemImage: "line.3.horizontal.decrease.circle.fill")
                .font(.body.weight(.medium))
        }
        .tint(.blue)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Setup Instructions

    private var setupInstructions: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Nasıl Kurulur?", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundStyle(.blue)

            instructionRow(number: "1", text: "Ayarlar'ı açın")
            instructionRow(number: "2", text: "Uygulamalar'a gidin")
            instructionRow(number: "3", text: "Mesajlar → Bilinmeyen ve Spam")
            instructionRow(number: "4", text: "\"0850 Engelleyici\"yi etkinleştirin")

            HStack(spacing: 10) {
                Button {
                    showVideo = true
                } label: {
                    Label("Video", systemImage: "play.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.12))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button {
                    if let url = URL(string: "App-Prefs:root=MESSAGES") {
                        openURL(url)
                    }
                } label: {
                    Label("Ayarları Aç", systemImage: "arrow.up.forward.app")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.12))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func instructionRow(number: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.caption.weight(.bold))
                .frame(width: 24, height: 24)
                .background(Color.blue.opacity(0.12))
                .foregroundStyle(.blue)
                .clipShape(Circle())

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Privacy

    private var privacyBadge: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.shield.fill")
                .font(.title2)
                .foregroundStyle(.green)

            Text("Gizlilik Odaklı")
                .font(.headline)

            Text("SMS içeriği okunmaz veya saklanmaz.\nYalnızca gönderici numarası kontrol edilir.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    // MARK: - Twitter

    private var twitterLink: some View {
        Button {
            if let url = URL(string: "https://x.com/sezeriltekin") {
                openURL(url)
            }
        } label: {
            HStack(spacing: 6) {
                Image("XLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)

                Text("sezeriltekin")
                    .font(.footnote)
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    ContentView()
}
