//
//  Photo.swift
//  JSONwithPagination
//
//  Created by Adrian Suryo Abiyoga on 20/01/25.
//

import SwiftUI

struct Photo: Identifiable, Codable, Hashable {
    var id: String
    var author: String
    var url: String
    private var downloadURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }
    
    var downloadURL: URL? {
        return URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        return URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}

