//
//  Model.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 26/01/21.
//

import Foundation

struct VideoData: Decodable {
    var title: String
    var videoURLs: [String]
    
    enum RootCodingKey: String, CodingKey {
        case title = "title"
        case nodes = "nodes"
    }
    
    enum VideoCodingKey: String, CodingKey {
        case video = "video"
    }
    
    enum URLCodingKey: String, CodingKey {
        case videoURL = "encodeUrl"
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        title = try rootContainer.decode(String.self, forKey: .title)
        
        var videoUnkeyedContainer = try rootContainer.nestedUnkeyedContainer(forKey: .nodes)
        videoURLs = [String]()
        while !videoUnkeyedContainer.isAtEnd{
            let urlContainer = try videoUnkeyedContainer.nestedContainer(keyedBy: VideoCodingKey.self).nestedContainer(keyedBy: URLCodingKey.self, forKey: .video)
            videoURLs.append(try urlContainer.decode(String.self, forKey: .videoURL))
        }
    }
}

