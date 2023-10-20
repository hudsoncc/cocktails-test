//
//  NetworkOp.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

class NetworkOperation<T: Decodable>: Operation {
    
    typealias ResponseHandler = (Result<T, Error>) -> Void
    
    // MARK: Enums
    
    public enum NetworkError: Error {
        case operationCancelled
        case noResponseData
    }
    
    private enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    
    // MARK: Props (public)
    
    override var isReady: Bool {
        super.isReady && state == .isReady
    }
    
    override var isExecuting: Bool {
        state == .isExecuting
    }
    
    override var isFinished: Bool {
        state == .isFinished
    }
    
    override var isAsynchronous: Bool {
        true
    }
    
    private(set) var request: URLRequest!

    // MARK: Props (private)
    
    private var responseHandler: ResponseHandler?

    private var state = State.isReady {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    private lazy var urlSession: URLSession = {
        URLSession(configuration: .default)
    }()
    
    // MARK: Life cycle
    
    convenience init(request: URLRequest, responseHandler: ResponseHandler? = nil) {
        self.init()
        self.request = request
        self.responseHandler = responseHandler
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        if !isExecuting {
            state = .isExecuting
        }
        main()
    }
    
    
    override func main() {
        makeRequest()
    }
    
    private func finish() {
        guard isExecuting else { return }
        state = .isFinished
        debugPrint("Finished op for endpoint: \(request.url!)")
    }
    
    override func cancel() {
        super.cancel()
        debugPrint("Skipping network op: \(request.url!). The op was cancelled.")
        finish()
    }
    
    // MARK: Request handling
    
    private func makeRequest() {
        guard !isCancelled else {
            responseHandler?(.failure(NetworkError.operationCancelled))
            return
        }
        
        let dataTask = urlSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self else {
                return
            }
            
            guard !isCancelled else {
                responseHandler?(.failure(NetworkError.operationCancelled))
                return
            }
            
            if let error = error {
                responseHandler?(.failure(error))
                return
            }
            
            guard let data = data else {
                responseHandler?(.failure(NetworkError.noResponseData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                responseHandler?(.success(result))
            } catch {
                responseHandler?(.failure(error))
            }
            
            finish()
        }
        
        dataTask.resume()
    }

}
