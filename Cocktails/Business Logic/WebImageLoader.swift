//
//  WebImageLoader.swift
//  Cocktails
//
//  Created by Hudson Maul on 22/10/2023.
//

import UIKit

protocol ImageLoadable {
    var cachePath: String {get}
    var cacheURL: URL {get}
    var fileManager: FileManager {get}

    func loadOrFetchImage(forURL url: URL) async throws -> Data?
    func loadImage(forURL url: URL) -> Data?
    func fetchImage(forURL url: URL) async throws -> Data?
    func clearCache()
    func cacheImage(forURL url: URL, atTemporaryURL tempURL: URL) throws
    func imagePathForCachedImage(withURL url: URL) -> URL
}

extension ImageLoadable {
    
    // MARK: Props (public)

    public var fileManager: FileManager { FileManager.default }
    public var cacheURL: URL {
        fileManager.documentsDirectory!.appendingPathComponent(cachePath)
    }
    
    // MARK: API (public)
    
    public func loadOrFetchImage(forURL url: URL) async throws -> Data? {
        guard let data = loadImage(forURL: url) else {
            return try await fetchImage(forURL: url)
        }
        return data
    }
    
    public func loadImage(forURL url: URL) -> Data? {
        let cachedImagePath = imagePathForCachedImage(withURL: url)
        return try? Data(contentsOf: cachedImagePath)
    }
    
    public func fetchImage(forURL url: URL) async throws -> Data? {
        let (tempURL, _) = try await URLSession.shared.download(from: url, delegate: nil)
        do {
            try cacheImage(forURL: url, atTemporaryURL: tempURL)
        } catch {
            print("Caching image for url failed: \(error)")
        }
        return try Data(contentsOf: url)
    }
    
    public func clearCache() {
        do {
            try fileManager.removeItem(at: cacheURL)
        } catch  {
            // Error handling out of scope for project?
        }
    }
    
    // MARK: API (private)
    
    func cacheImage(forURL url: URL, atTemporaryURL tempURL: URL) throws {
        let cachedImagePath = imagePathForCachedImage(withURL: url)
        createCacheDirectoryIfNeeded()
        
        if fileManager.fileExists(atPath: cachedImagePath.path) {
            try fileManager.removeItem(at: cachedImagePath)
        }
        try fileManager.copyItem(at: tempURL, to: cachedImagePath)
    }
    
    func imagePathForCachedImage(withURL url: URL) -> URL {
        cacheURL.appendingPathComponent( url.lastPathComponent, isDirectory: false)
    }
    
    public func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: cacheURL.path) else {
            return
        }
            
        do {
            try fileManager.createDirectory(atPath: cacheURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create dir: \(cacheURL.absoluteString)")
        }
    }
}

struct WebImageLoader: ImageLoadable {
    
    public var cachePath: String { "imageCache" }

}

private extension FileManager {
    
    var documentsDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

}
