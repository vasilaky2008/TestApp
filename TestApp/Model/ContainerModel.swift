//
//  ContainerModel.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ArticleModel {
    let url: String
    let title: String

    init (with json: JSON) {
        self.url = json["url"].stringValue
        self.title = json["title"].stringValue
    }
}


