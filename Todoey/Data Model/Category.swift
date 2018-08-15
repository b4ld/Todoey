//
//  Category.swift
//  Todoey
//
//  Created by Pedro Carmezim on 13/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var colour:String = ""
    
    //relations
    let items = List<Item>()

}
