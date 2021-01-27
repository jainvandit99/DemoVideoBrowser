//
//  HomeViewModel.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 26/01/21.
//

import Foundation

class HomeViewModel {
    
    public let videoData: [VideoData]
    
    init() {
        let data = Functions.readJSONFromFile(fileName: "assignment")
        let decoder = JSONDecoder()
        do{
            self.videoData = try decoder.decode([VideoData].self, from: data)
        }catch {
            print(error)
            self.videoData = [VideoData]()
        }
    }
}
