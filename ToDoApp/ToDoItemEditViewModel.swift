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
    
    func add(title: String, detail: String) -> Error? {
        do {
            item.title = title
            item.detail = detail
            try RealmManager.sharedManager.add(object: item)
        } catch let error {
            return error
        }
        return nil
    }

    func update(title: String, detail: String) -> Error? {
        do {
            try RealmManager.sharedManager.realm?.write {
                item.title = title
                item.detail = detail
            }
        } catch let error {
            return error
        }
        return nil
    }
    
    func delete() -> Error? {
        do {
            try RealmManager.sharedManager.delete(object: item)
        } catch let error {
            return error
        }
        return nil
    }
    
}
