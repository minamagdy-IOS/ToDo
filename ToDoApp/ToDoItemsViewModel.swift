//
//  ToDoItemsViewModel.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 16.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RealmSwift

class ToDoItemsVieWModel {
    
    var results: Results<ToDoItem>?
    
    func getItems(completion: BooleamCompletion? = nil) {
        RealmManager.sharedManager.getObjects(type: ToDoItem.self, sortedBy: "createdDate") { (results, error) in
            self.results = results
            completion?(results != nil, error)
        }
    }
    
    func delete(itemAt index: Int, completion: BooleamCompletion? = nil) {
        guard let results = results else {
            completion?(false, nil)
            return
        }
        let item = results[index]
        let editViewModel = ToDoItemEditViewModel(item: item)
        editViewModel.delete(completion: completion)
    }
    
}
