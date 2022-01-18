//
//  ImageCacheManager.swift
//  ImageCache
//
//  Created by 박상우 on 2022/01/18.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    
    func loadImage(url: URL?, completion: @escaping (Data) -> ()) {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let url = url else { return }
        var filePath = URL(fileURLWithPath: cachesDirectory.path)
        filePath.appendPathComponent(url.lastPathComponent)
        
        // memory cache check

        let cachedKey = NSString(string: filePath.path)
        if let cachedData = cache.object(forKey: cachedKey) {
            let imageData = Data(referencing: cachedData)
            completion(imageData)
            return
        }
        
        // disk cache(file) check
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            if let data = NSData(contentsOf: filePath) {
                cache.setObject(data, forKey: NSString(string: filePath.path))
                completion(Data(referencing: data))
                return
            }
        }
        
        // image download and file save, cache save
        
        URLSession.shared.downloadTask(with: url) { [weak self] url, response, error in
            guard let url = url,
                  let content = try? Data(contentsOf: url),
                  let cacheData = NSData(contentsOf: url) else { return }
            self?.cache.setObject(cacheData, forKey: NSString(string: filePath.path))
            FileManager.default.createFile(atPath: filePath.path, contents: content, attributes: nil)
            completion(content)
        }.resume()
    }
}
