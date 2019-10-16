//
//  ToDoItemsViewModel.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 16.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RealmSwift

class ToDoItemsVieWModel {
    
    func getItems() -> Results<ToDoItem>? {
        return RealmManager.sharedManager.getObjects(type: ToDoItem.self)
    }
    
}
