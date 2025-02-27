import Foundation

class Item: Codable {
    let id: Int
    let name: String
}


enum APIError: Error {
    case urlError
    case networkError(Error)
    case dataDecodingError(Error)
    case dataEncodingError(Error)
    case httpError(Int)
}


class APIClient {
    func getAllItems(completion: @escaping (Result<[Item], APIError>) -> Void) {
        guard let url = URL(string: "https://example.com/api/items") else {
            completion(.failure(.urlError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    guard let data = data else {
                        completion(.failure(.urlError))
                        return
                    }

                    do {
                        let items = try JSONDecoder().decode([Item].self, from: data)
                        completion(.success(items))
                    } catch let decodingError {
                        completion(.failure(.dataDecodingError(decodingError)))
                    }
                } else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
            }
        }

        task.resume()
    }
}
