//
//  RealmManager.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 15.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    static let sharedManager = RealmManager()
    
    private var realm: Realm?
    
}

extension RealmManager {
    
    class func initialize() throws {
        RealmManager.sharedManager.realm = try Realm()
    }
    
}

extension RealmManager {
    
    func add(object: Object) throws {
        guard let realm = self.realm else { return }
        try realm.write {
            realm.add(object)
        }
    }
    
    func update(object: Object) throws {
        guard let realm = self.realm else { return }
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete(object: Object) throws {
        guard let realm = self.realm else { return }
        try realm.write {
            realm.delete(object)
        }
    }
    
}

extension RealmManager {
    
    func getObject<Element: Object>(type: Element.Type) -> Results<Element>? {
        guard let realm = self.realm else { return nil }
        return realm.objects(type)
    }
    
}
