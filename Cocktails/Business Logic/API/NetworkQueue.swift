//
//  NetworkQueue.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

class NetworkQueue: NSObject {
    
    // MARK: Props (private)
        
    lazy public var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "Network Queue"
        return queue
    }()
    
    public var hasOperations: Bool { !queue.operations.isEmpty }

    // MARK: Life cycle
    
    static let shared = NetworkQueue()
 
    // MARK: Queuing
    
    public func enqueue<T: Decodable>(_ newOperation: NetworkOperation<T>) {
        guard !isEnqueued(newOperation) else {
            debugPrint("Skipped op \(newOperation.request.url!). Already enqueued.")
            return
        }
        
        queue.addOperation(newOperation)
        debugPrint("Queued op for URL: \(newOperation.request.url!)")
    }
    
    private func isEnqueued<T: Decodable>(_ newOperation: NetworkOperation<T>) -> Bool {
        let enqueuedRequestURLs = queue.operations.compactMap {
            ($0 as? NetworkOperation<T>)?.request.url
        }
        return enqueuedRequestURLs.contains(newOperation.request.url!)
    }
      
}

