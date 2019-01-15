//
//  NetworkManager.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import Foundation


enum NetworkResponse: String {
    case success
    case badRequest = "Bad request"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
}


enum Result<String> {
    case success
    case failure(String)
}


struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    let router = Router<MyContactAPI>()
    
    func getAllContries(completion:@escaping(_ data:[Country]?, _ error: String?) ->()) {
        router.request(.countries) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                    let result  =  self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                      completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        
                         let apiResponse = try JSONDecoder().decode([Country].self, from: responseData)
                        
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    break
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                    break
                }
            }
        }
    }

    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
