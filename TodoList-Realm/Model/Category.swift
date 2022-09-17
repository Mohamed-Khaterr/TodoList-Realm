//
//  Category.swift
//  TodoList-Realm
//
//  Created by Khater on 9/15/22.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    // Forward Relationship
    let items = List<Item>()
}
