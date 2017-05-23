//
//  GitHubViewModel.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/23.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift
import SwiftyJSON
import Moya
import ObjectMapper

class GitHubViewModel: NSObject {
    
    func getUserProfile(_ userName:String) -> Observable<GitHubModel> {
        
        return GitHubProvider
            .request(.userProfile(userName))
            .mapObject(GitHubModel.self)
    }
    
    func getUserRepositories(_ userName:String) -> Observable<[GitHubModel]> {
        
        return GitHubProvider
            .request(.userRepositories(userName))
            .mapUserRepo(GitHubModel.self)
    }
    
    func getRepositories(_ repoName:String) -> Observable<[GitHubModel]> {
        
        return GitHubProvider
            .request(.searchRepositories(repoName))
            .mapRepositories(GitHubModel.self)
    }
    
}
