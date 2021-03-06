//
//  Item.swift
//  Todoey
//
//  Created by Pedro Carmezim on 13/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    
    //Relations
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    //if we add new property, and there is a object allready created - need to delete app and restart
}
