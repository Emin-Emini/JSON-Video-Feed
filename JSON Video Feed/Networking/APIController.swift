//
//  APIController.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    
    var errorDescription: String? {
        switch self {
        case .responseProblem:
            return "Response Problem"
        case .decodingProblem:
            return "Decoding Problem"
        default:
            return "Other Error"
        }
    }
}

class APIController {
    
    var feedList: [Feed] = []
    
    var baseURL = URL(string: "https://private-anon-9a67925951-technicaltaskapi.apiary-mock.com/feed?page=1&sport=football")!
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        let resoucreString = "https://private-anon-9a67925951-technicaltaskapi.apiary-mock.com/feed?page=1&sport=football"
        guard let resourceURL = URL(string: resoucreString) else { print("Wrong URL"); fatalError() }
        
        self.baseURL = resourceURL
    }
    
    func getFeed(completion: @escaping(Result<[Feed]?, APIError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                completion(.failure(.responseProblem))
                return
            }
            do {
                let newFeed = try JSONDecoder().decode([Feed].self, from: jsonData)
                //print(newFeed)
                self.feedList = newFeed
                completion(.success(newFeed))
            } catch {
                completion(.failure(.decodingProblem))
                return
            }
        }
        dataTask.resume()
        
        
    }
}
