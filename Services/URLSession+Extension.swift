//
//  URLSession+Extension.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 5/1/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine

public extension URLSession {
    
    func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        self.downloadTaskPublisher(for: .init(url: url))
    }
    
    func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        .init(request: request, session: self)
    }
    
    struct DownloadTaskPublisher: Publisher {
        public typealias Output = (url: URL, response: URLResponse)
        public typealias Failure = URLError
        
        public let request: URLRequest
        public let session: URLSession
        
        public init(request: URLRequest, session: URLSession) {
            self.request = request
            self.session = session
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: session, request: request)
            subscriber.receive(subscription: subscription)
        }
    }
    
    final class DownloadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (url: URL, response: URLResponse),
        SubscriberType.Failure == URLError
    {
        private var subscriber: SubscriberType?
        private weak var session: URLSession!
        private var request: URLRequest!
        private var task: URLSessionDownloadTask!

        init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        public func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {
                return
            }
            
            self.task = self.session.downloadTask(with: request) { [weak self] url, response, error in
                if let error = error as? URLError {
                    self?.subscriber?.receive(completion: .failure(error))
                    return
                }
                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                guard let url = url else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badURL)))
                    return
                }
                do {
                    let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let fileUrl = cacheDir.appendingPathComponent((UUID().uuidString))
                    try FileManager.default.moveItem(atPath: url.path, toPath: fileUrl.path)
                    _ = self?.subscriber?.receive((url: fileUrl, response: response))
                    self?.subscriber?.receive(completion: .finished)
                }
                catch {
                    self?.subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
                }
            }
            self.task.resume()
        }

        public func cancel() {
            self.task.cancel()
        }
    }
    
    final class DownloadTaskSubscriber: Subscriber {
        public typealias Input = (url: URL, response: URLResponse)
        public typealias Failure = URLError

        var subscription: Subscription?

        public func receive(subscription: Subscription) {
            self.subscription = subscription
            self.subscription?.request(.unlimited)
        }

        public func receive(_ input: Input) -> Subscribers.Demand {
            print("Subscriber value \(input.url)")
            return .unlimited
        }

        public func receive(completion: Subscribers.Completion<Failure>) {
            print("Subscriber completion \(completion)")
            self.subscription?.cancel()
            self.subscription = nil
        }
    }
}
