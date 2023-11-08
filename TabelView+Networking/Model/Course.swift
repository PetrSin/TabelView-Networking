//
//  Course.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import SwiftyJSON

struct Course: Decodable {

    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case imageUrl
        case numberOfLessons = "number_of_lessons"
        case numberOfTests = "number_of_tests"
    }
    
    init(json: JSON){
        id = json["id"].int
        name = json["name"].string
        link = json["link"].string
        imageUrl = json["imageUrl"].string
        numberOfLessons = json["number_of_lessons"].int
        numberOfTests = json["number_of_tests"].int
    }
}
