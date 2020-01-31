//
//  Observable.swift
//  WatchOut
//
//  Created by iOS1920 on 15.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//


// classic publisher+observer pattern
// used because other frameworks made problems

// Publisher
protocol ObservableProtocol : class {
    var observers : [ObserverProtocol] { get set }

    func addObserver(_ observer: ObserverProtocol)
    func removeObserver(_ observer: ObserverProtocol)
    func notifyObservers(_ observers: [ObserverProtocol])
}

// Observer
protocol ObserverProtocol {

    var id : Int { get set }
    func onValueChanged(_ value: Any?)
}

class Observable<T> {

    typealias CompletionHandler = ((T) -> Void)

    var value : T {
        didSet {
            self.notifyObservers(self.observers)
        }
    }

    var observers : [Int : CompletionHandler] = [:]

    init(value: T) {
        self.value = value
    }
    
    func addObserver(_ observer: ObserverProtocol, completion: @escaping CompletionHandler) {
        self.observers[observer.id] = completion
    }

    func removeObserver(_ observer: ObserverProtocol) {
        self.observers.removeValue(forKey: observer.id)
    }

    func notifyObservers(_ observers: [Int : CompletionHandler]) {
        observers.forEach({ $0.value(value) })
    }

    deinit {
        observers.removeAll()
    }
}
