//
//  WebImageLoader.swift
//  Cocktails
//
//  Created by Hudson Maul on 22/10/2023.
//

import UIKit

struct WebImageLoader {
    
    public var fileManager = FileManager.default

    // MARK: API (public)

    public func loadOrFetchImage(forURL url: URL) async throws -> Data? {
        guard let data = loadImage(forURL: url) else {
            return try await fetchImage(forURL: url)
        }
        return data
    }
    
    public func loadImage(forURL url: URL) -> Data? {
        let cachedImagePath = cachedImagePath(forURL: url)
        return try? Data(contentsOf: cachedImagePath)
    }
    
    public func fetchImage(forURL url: URL) async throws -> Data? {
        let (tempURL, _) = try await URLSession.shared.download(from: url, delegate: nil)
        try cacheImage(forURL: url, atTemporaryURL: tempURL)
        return try Data(contentsOf: url)
    }
    
    public func clearCache() {
        let cachePath = fileManager.temporaryDirectory.path
        
        do {
            let fileName = try fileManager.contentsOfDirectory(atPath: cachePath)
            
            for file in fileName {
                let filePath = URL(fileURLWithPath: cachePath).appendingPathComponent(file).absoluteURL
                try fileManager.removeItem(at: filePath)
            }
        } catch  {
            // Error handling out of scope for project?
        }
    }
    
    // MARK: API (private)    
    
    private func cacheImage(forURL url: URL, atTemporaryURL tempURL: URL) throws {
        let cachedImagePath = cachedImagePath(forURL: url)
        if fileManager.fileExists(atPath: cachedImagePath.path) {
            try fileManager.removeItem(at: cachedImagePath)
        }
        try fileManager.copyItem(at: tempURL, to: cachedImagePath)
    }
    
    private func cachedImagePath(forURL url: URL) -> URL {
        let filePath = fileManager.temporaryDirectory
        return filePath.appendingPathComponent( url.lastPathComponent, isDirectory: false)
    }
    
}
