import Foundation

struct TranslationRequest: Codable {
    let input: String
    let source: String
    let target: String

    enum CodingKeys: String, CodingKey {
        case source, target
        case input = "q"
    }
}


enum Language: String, CaseIterable, Identifiable, Codable {
    case english = "en"
    case brasileiro = "pt"
    case french = "fr"
    case arabic = "ar"
    case chineseSimplified = "zh-CN"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .brasileiro: return "Brasileiro"
        case .french: return "Français"
        case .arabic: return "العربية"  
        case .chineseSimplified: return "中文 (简体)"
        }
    }
}

struct TranslationResponse: Codable {
    let data: Data

    struct Data: Codable {
        let translations: Translations
    }

    struct Translations: Codable {
        let translatedText: String
    }

}

