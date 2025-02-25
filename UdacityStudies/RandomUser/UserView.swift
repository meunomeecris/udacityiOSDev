import SwiftUI

struct UserView: View {
    private var modelData = ModelData()

    var body: some View {
        VStack {
            if let users = modelData.users {
                ForEach(users) { user in
                    UserCard(user: user, modelData: modelData)
                }
            }
        }
        .ignoresSafeArea(.all)
        .padding(16)
        .task {
            modelData.getUser()
        }
    }
}


struct UserCard: View {
    let user: User
    let modelData: ModelData
    @State private var countryFlag: String?

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                // Imagem de perfil
                AsyncImage(url: URL(string: user.picture.large)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Bandeira do país no canto superior direito
                AsyncImage(url: URL(string: getFlag(for: user.location.country))) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.5)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .offset(x: -10, y: 10)
            }

            // Informações do usuário
            VStack(alignment: .leading, spacing: 8) {
                Text("\(user.name.title) \(user.fullname)")
                    .font(.title2)
                    .fontWeight(.bold)
//                    .foregroundColor(.primary)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("📅 \(formatDate(isoDate: user.dateOfBirth.date))")
                    .font(.subheadline)
//                    .foregroundColor(.primary)

                Text("📍 \(user.fullAddress)")
                    .font(.subheadline)
//                    .foregroundColor(.primary)
            }
            .padding()
            Spacer()

            Button(action: modelData.getUser) {
                Text("Next User")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 24)
        }
    }

    func formatDate(isoDate date: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: date) else {
            return "Not from this timeline..."
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy" // Exemplo: "18 Oct 1985"

        return outputFormatter.string(from: date)
    }

    func getFlag(for countryName: String) -> String {
        if let country = Country(rawValue: countryName) {
            return country.flagURL
        }
        return "https://flagcdn.com/w320/un.png" // Retorna bandeira genérica se o país não estiver no enum
    }

}


enum Country: String {
    case usa = "United States"
    case uk = "United Kingdom"
    case france = "France"
    case germany = "Germany"
    case italy = "Italy"
    case spain = "Spain"
    case canada = "Canada"
    case brazil = "Brazil"
    case japan = "Japan"
    case china = "China"
    case india = "India"
    case russia = "Russia"
    case australia = "Australia"
    case mexico = "Mexico"
    case southKorea = "South Korea"
    case argentina = "Argentina"
    case belgium = "Belgium"
    case austria = "Austria"
    case sweden = "Sweden"
    case netherlands = "Netherlands"
    case norway = "Norway"
    case switzerland = "Switzerland"
    case portugal = "Portugal"
    case poland = "Poland"
    case greece = "Greece"
    case turkey = "Turkey"
    case southAfrica = "South Africa"
    case egypt = "Egypt"
    case tunisia = "Tunisia"
    case newZealand = "New Zealand"
    case singapore = "Singapore"
    case palestine = "Palestine"

    private var countryCode: String {
        switch self {
        case .usa: return "us"
        case .uk: return "gb"
        case .france: return "fr"
        case .germany: return "de"
        case .italy: return "it"
        case .spain: return "es"
        case .canada: return "ca"
        case .brazil: return "br"
        case .japan: return "jp"
        case .china: return "cn"
        case .india: return "in"
        case .russia: return "ru"
        case .australia: return "au"
        case .mexico: return "mx"
        case .southKorea: return "kr"
        case .argentina: return "ar"
        case .belgium: return "be"
        case .austria: return "at"
        case .sweden: return "se"
        case .netherlands: return "nl"
        case .norway: return "no"
        case .switzerland: return "ch"
        case .portugal: return "pt"
        case .poland: return "pl"
        case .greece: return "gr"
        case .turkey: return "tr"
        case .southAfrica: return "za"
        case .egypt: return "eg"
        case .tunisia: return "tn"
        case .newZealand: return "nz"
        case .singapore: return "sg"
        case .palestine: return "ps"
        }
    }

    var flagURL: String {
        return "https://flagcdn.com/w320/\(self.countryCode).png"
    }
}





