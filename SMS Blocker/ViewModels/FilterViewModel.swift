import Foundation

@Observable
final class FilterViewModel {

    static let appGroupID = "group.com.iltekin.SMS-Blocker"
    static let filterKey = "isFilteringEnabled"

    private let onboardingKey = "hasSeenOnboarding"
    private let sharedDefaults: UserDefaults?

    var isFilteringEnabled: Bool {
        didSet { sharedDefaults?.set(isFilteringEnabled, forKey: Self.filterKey) }
    }

    var hasSeenOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: onboardingKey) }
    }

    init() {
        let defaults = UserDefaults(suiteName: Self.appGroupID)
        self.sharedDefaults = defaults

        // Default value is true (filtering ON) when user hasn't explicitly changed it
        if defaults?.object(forKey: Self.filterKey) != nil {
            self.isFilteringEnabled = defaults?.bool(forKey: Self.filterKey) ?? true
        } else {
            self.isFilteringEnabled = true
            defaults?.set(true, forKey: Self.filterKey)
        }

        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
}
