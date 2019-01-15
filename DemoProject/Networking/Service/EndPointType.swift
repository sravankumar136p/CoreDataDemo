//
//  EndPointType.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
