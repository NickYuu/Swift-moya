//
//  GitHubModel.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/23.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class GitHubModel: Mappable {
    
    var name                : String?
    var html_url            : String?
    var stargazers_count    : Int?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name                <- map["name"]
        html_url            <- map["html_url"]
        stargazers_count    <- map["stargazers_count"]
    }
}
