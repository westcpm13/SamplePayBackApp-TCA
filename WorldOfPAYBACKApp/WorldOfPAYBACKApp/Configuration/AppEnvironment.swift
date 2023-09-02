import Foundation

struct AppEnvironment: Equatable {
    enum Keys {
        static let baseURL = "BASE_URL"
    }
    let isDemoUser: Bool = true
    let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.baseURL
        ) as? String else {
            fatalError("BASE_URL not found")
        }
        return baseURLProperty
    }()
}
