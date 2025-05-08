//
//  APIParameters.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import Alamofire

protocol APIParameters {
    
    func makeSendableParameters() -> Parameters
}

extension APIParameters {
    func makeSendableParameters() -> Parameters {
        let mirror = Mirror(reflecting: self)
        let results: Parameters = mirror.children.reduce([:]) { partialResult, children in
            if let label = children.label {
                return partialResult.merging([label: children.value], uniquingKeysWith: { $1 })
            } else {
                return partialResult
            }
        }
        return results
    }
}

struct NoneParameter {}

extension NoneParameter: APIParameters {
    func makeSendableParameters() -> Parameters {
        [:]
    }
}
