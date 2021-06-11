//
//  Feed.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import Foundation

struct Feed: Decodable {
    let id: Int
    let createdAt: String
    let createdBefore: String
    let author: Author
    let video: Video
}

struct Author: Decodable {
    let id: Int
    let name: String
}

struct Video: Decodable {
    let handler: String
    let url: String
    let poster: String
    let length: Int
}
