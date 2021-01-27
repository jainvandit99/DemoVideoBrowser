//
//  Functions.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 26/01/21.
//

import UIKit
import AVFoundation
import Kingfisher

class Functions {
    static func readJSONFromFile(fileName: String) -> Data
      {
        var jsonData: Data?
          if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
              do {
                  let fileUrl = URL(fileURLWithPath: path)
                  // Getting data from JSON file using the file URL
                  let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                  let json = try? JSONSerialization.jsonObject(with: data)
                jsonData = try? JSONSerialization.data(withJSONObject: json ?? nil, options: .prettyPrinted)
              } catch {
                  print(error)
              }
          }
        return jsonData ?? Data()
        
      }
}


//Data Provider To Provide Thumbnail Image From Video
struct VideoThumbnailImageProvider: ImageDataProvider {

    enum ProviderError: Error {
        case convertingFailed(CGImage)
    }

    let url: URL
    let size: CGSize

    var cacheKey: String { return "\(url.absoluteString)_\(size)" }
    func data(handler: @escaping (Result<Data, Error>) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: self.url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            assetImgGenerate.maximumSize = self.size
            let time = CMTime(seconds: 1, preferredTimescale: 10)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                if let data = UIImage(cgImage: img).jpegData(compressionQuality: 0.5) {
                    handler(.success(data))
                } else {
                    handler(.failure(ProviderError.convertingFailed(img)))
                }
            } catch {
                handler(.failure(error))
            }
        }
    }
}

