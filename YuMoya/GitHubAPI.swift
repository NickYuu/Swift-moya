//
//  GitHubAPI.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/20.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import Foundation
import Moya


let GitHubProvider = RxMoyaProvider<GitHubService>()


// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum GitHubService {
    case userProfile(String)
    case userRepositories(String)
    case searchRepositories(String)
}


extension GitHubService: TargetType {
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    //https://api.github.com/users/NickYuu/repos
    public var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        case .searchRepositories(_):
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .userRepositories(_):
            return ["sort": "pushed"]
        case .searchRepositories(let str):
            return ["q": str, "sort": "stars", "order": "desc"]
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .request
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .userRepositories(_):
            return "[\"name\"]".data(using: String.Encoding.utf8)!
            //"[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .searchRepositories(_):
            return Data()
        }
    }
}



//MARK: - Response Handlers
//extension Moya.Response {
//    func mapNSArray() throws -> Array<Any> {
//        let any = try self.mapJSON()
//        guard let array = any as? Array<Any> else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return array
//    }
//    
//    func mapDic() throws -> [String:Any] {
//        let any = try self.mapJSON()
//        guard let array = any as? [String:Any] else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return array
//    }
//}
