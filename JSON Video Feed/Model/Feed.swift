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
    let athlete: Athlete
    let description: String
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

struct Athlete: Decodable {
    let name: String
    let avatar: String
    let club: String
    let country: Country
    let isCelebrity: Bool
}

struct Country: Decodable {
    let name: String
    let icon: String
}
