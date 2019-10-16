//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 15.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RealmSwift

class ToDoItem: Object {
    
    @objc dynamic var title = ""
    
    @objc dynamic var detail = ""
    
    convenience init(title: String, detail: String) {
        self.init()
        self.title = title
        self.detail = detail
    }
    
}
