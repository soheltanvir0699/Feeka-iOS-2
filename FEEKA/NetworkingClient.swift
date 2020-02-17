//
//  NetworkingClient.swift
//  FEEKA
//
//  Created by Apple Guru on 17/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient {
    
    static var networkingClient = NetworkingClient()
    //"https://feeka.co.za/wp-json/Home/v1/dashboard"
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
     func execute(_ url: URL,parameter: [String: String], completion: @escaping WebServiceResponse) {
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil)
            } else if let jsonDict = response.result.value as? [String: Any] {
                completion([jsonDict], nil)
            }
        }
    }
}


