import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

// MARK: - ILMessageFilterQueryHandling

extension MessageFilterExtension: ILMessageFilterQueryHandling {

    /// Apple's Message Filter API calls this method for every incoming SMS from an unknown sender.
    /// We only inspect the sender's phone number — message content is never read or stored.
    func handle(
        _ queryRequest: ILMessageFilterQueryRequest,
        context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterQueryResponse) -> Void
    ) {
        let response = ILMessageFilterQueryResponse()

        // Read the user preference from the shared App Group container
        let defaults = UserDefaults(suiteName: "group.com.iltekin.SMS-Blocker")
        let isEnabled: Bool = {
            if defaults?.object(forKey: "isFilteringEnabled") != nil {
                return defaults?.bool(forKey: "isFilteringEnabled") ?? true
            }
            return true // enabled by default
        }()

        guard isEnabled, let sender = queryRequest.sender else {
            response.action = .allow
            completion(response)
            return
        }

        // Strip whitespace, dashes, and parentheses for reliable prefix matching
        let normalized = sender
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        if normalized.hasPrefix("+90850") || normalized.hasPrefix("0850") {
            response.action = .junk
            response.subAction = .none
        } else {
            response.action = .allow
        }

        completion(response)
    }
}
