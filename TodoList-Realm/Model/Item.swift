//
//  Item.swift
//  TodoList-Realm
//
//  Created by Khater on 9/15/22.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    // Revers Relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
