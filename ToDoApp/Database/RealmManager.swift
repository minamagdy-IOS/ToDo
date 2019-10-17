//
//  RealmManager.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 15.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RealmSwift

typealias BooleamCompletion                  = (_ success: Bool, _ error: Error?) -> ()
typealias ObjectsCompletion<Element: Object> = (_ objects: Results<Element>?, _ error: Error?) -> ()
typealias UpdateObjectBlock<Element: Object> = (_ object: Element?, _ error: Error?) -> ()

class RealmManager {
    
    static let sharedManager = RealmManager()
    
    private let queue = DispatchQueue(label: "realm", qos: .background)
    
}

extension RealmManager {
    
    func add(object: Object, completion: BooleamCompletion? = nil) {
        queue.async {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(object)
                }
                DispatchQueue.main.async {
                    completion?(true, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion?(false, error)
                }
            }
        }
    }
    
    func update<Element: Object>(_ type: Element.Type, object: Element, block: UpdateObjectBlock<Element>? = nil) {
        let objectRef = ThreadSafeReference(to: object)
        queue.async {
            do {
                let realm = try Realm()
                let object = realm.resolve(objectRef)
                try realm.write {
                    block?(object, nil)
                }
            } catch let error {
                block?(nil, error)
            }
        }
    }
    
    func delete(object: Object, completion: BooleamCompletion? = nil) {
        let objectRef = ThreadSafeReference(to: object)
        queue.async {
            do {
                let realm = try Realm()
                guard let object = realm.resolve(objectRef) else {
                    DispatchQueue.main.async {
                        completion?(false, nil)
                    }
                    return
                }
                try realm.write {
                    realm.delete(object)
                }
                DispatchQueue.main.async {
                    completion?(true, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion?(false, error)
                }
            }
        }
    }
    
}

extension RealmManager {
    
    func getObjects<Element: Object>(type: Element.Type, sortedBy key: String? = nil, completion: ObjectsCompletion<Element>? = nil) {
        queue.async {
            do {
                let realm = try Realm()
                var results = realm.objects(type)
                if let key = key {
                    results = results.sorted(byKeyPath: key)
                }
                let resultsRef = ThreadSafeReference(to: results)
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        completion?(realm.resolve(resultsRef), nil)
                    } catch let error {
                        completion?(nil, error)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
            }
        }
    }
    
}
