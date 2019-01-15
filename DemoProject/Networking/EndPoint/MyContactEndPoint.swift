//
//  MyContactEndPoint.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum MyContactAPI {
    
    case  countries

}

extension MyContactAPI: EndPointType {
    var environmentsBaseURL: String {
        switch
        NetworkManager.environment {
        case .production: return "https://demo6869072.mockable.io/cricket"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string:environmentsBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .countries:
            return "countries"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .countries:
            return .get

        }
        
    }
    
    var task: HTTPTask {
        switch self {
        case .countries:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)

        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
