//
//  ToDoItemEditViewModel.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 16.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class ToDoItemEditViewModel {
    
    let item: ToDoItem
    
    init() {
        item = ToDoItem()
    }
    
    init(item: ToDoItem) {
        self.item = item
    }
    
    func add(title: String, detail: String, completion: BooleamCompletion? = nil) {
        item.title = title
        item.detail = detail
        RealmManager.sharedManager.add(object: item, completion: completion)
    }
    
    func update(title: String, detail: String, completion: BooleamCompletion? = nil) {
        RealmManager.sharedManager.update(ToDoItem.self, object: self.item) { (object, error) in
            object?.title = title
            object?.detail = detail
            DispatchQueue.main.async {
                completion?(object != nil, error)
            }
        }
    }
    
    func delete(completion: BooleamCompletion? = nil) {
        RealmManager.sharedManager.delete(object: item, completion: completion)
    }
    
}
