//
//  Observable+ObjectMapper.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/23.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import SwiftyJSON

extension Response {
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    public func mapRepositories<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        let json = JSON(data: self.data)
        let jsonArray = json["items"]
        
        guard let array = jsonArray.arrayObject as? [[String: Any]],
            let objects = Mapper<T>().mapArray(JSONArray: array) else {
                throw MoyaError.jsonMapping(self)
        }
        return objects
    }
    
    public func mapUserRepo<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        let json = JSON(data: self.data)
        let jsonArray = json
        
        guard let array = jsonArray.arrayObject as? [[String: Any]],
            let objects = Mapper<T>().mapArray(JSONArray: array) else {
                throw MoyaError.jsonMapping(self)
        }
        return objects
    }
}

extension ObservableType where E == Response {
    public func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
    
    public func mapRepositories<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapRepositories(T.self))
        }
    }
    
    public func mapUserRepo<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapUserRepo(T.self))
        }
    }
    
}
