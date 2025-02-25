//
//  RandomUserData.swift
//  UdacityStudies
//
//  Created by Cris Messias on 25/02/25.
//

import Foundation

@Observable
class RandomUserData: Codable {
    var name: String = "Mosquito"
    var email: String  = "MiauMiauMiau"

    // Function to fetch user data from the API
    func fetchData() {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(APIResponse.self, from: data)
                if let user = decodedData.results.first {
                    DispatchQueue.main.async {
                        self.name = user.name.first + "" + user.name.last
                        self.email = user.email
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}


struct APIResponse: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
}

struct Name: Codable {
    let first: String
    let last: String
}
