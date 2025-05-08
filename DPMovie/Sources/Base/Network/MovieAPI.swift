//
//  MovieAPI.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import Alamofire

extension MovieAPI {
    static func fetchConfiguration() async throws -> AppConfiguration {
        let value = try await HTTP.request(P.configuration)
            .serializingDecodable(AppConfiguration.self).value
        return value
    }
    
    static func fetchPopularMovies(page: Int) async throws -> [MovieSummary] {
        let result = try await HTTP.request(P.popularMovies, parameters: .init(page: page))
            .serializingDecodable(APIListResult<MovieSummary>.self).value
        return result.results
    }
}

extension MovieAPI {
    enum P {
        static let configuration = HTTP.PathDefinition(method: .get, path: "/3/configuration")
        static let popularMovies = HTTP.PathDefinition(method: .get, path: "/3/movie/popular", parameterType: MovieListParameters.self)
    }
}

enum MovieAPI {}

extension MovieAPI {
    
    enum HTTP {
        
        struct PathDefinition<Parameters: APIParameters> {
            let method: HTTPMethod
            let path: String
            let parameterType: Parameters.Type
            
            init(method: HTTPMethod, path: String, parameterType: Parameters.Type) {
                self.method = method
                self.path = path
                self.parameterType = parameterType
            }
        }
        
        static func request(
            _ path: PathDefinition<NoneParameter>,
            encoding: any ParameterEncoding = URLEncoding.default,
            headers: HTTPHeaders? = nil,
            interceptor: (any RequestInterceptor)? = nil,
            requestModifier: Alamofire.Session.RequestModifier? = nil
        ) -> DataRequest {
            request(
                path,
                parameters: NoneParameter(),
                encoding: encoding,
                headers: headers,
                interceptor: interceptor,
                requestModifier: requestModifier
            )
        }
        
        static func request<Parameters: APIParameters>(
            _ path: PathDefinition<Parameters>,
            parameters: Parameters,
            encoding: any ParameterEncoding = URLEncoding.default,
            headers: HTTPHeaders? = nil,
            interceptor: (any RequestInterceptor)? = nil,
            requestModifier: Alamofire.Session.RequestModifier? = nil
        ) -> DataRequest {
            return Session.request(
                baseURL.appendingPathComponent(path.path, conformingTo: .url),
                method: path.method,
                parameters: parameters.makeSendableParameters(),
                encoding: encoding,
                headers: headers,
                interceptor: interceptor,
                requestModifier: requestModifier
            )
        }
        
        static let baseURL = URL(string: "https://api.themoviedb.org")!
        
        static let Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.headers.add(.authorization(bearerToken: appKey))
            configuration.headers.add(.accept("application/json"))
            let session = Alamofire.Session(configuration: configuration)
            return session
        }()
    }
}

extension MovieAPI.HTTP.PathDefinition where Parameters == NoneParameter {
    
    init(method: HTTPMethod, path: String) {
        self.init(method: method, path: path, parameterType: NoneParameter.self)
    }
}

extension MovieAPI {
    static let appKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNDU0ZGQzM2M5MmY2NjdmOWI4NzlmYmUwZjg1OTRhZSIsIm5iZiI6MTc0Mjk1NjkxOC44MzksInN1YiI6IjY3ZTM2OTc2M2RiZTNhYjFmMmYwNDk2YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lyKwz1A7EaSuN-pMLoQWRPu_fAexWxACt-w5Gde2VXo"
}
